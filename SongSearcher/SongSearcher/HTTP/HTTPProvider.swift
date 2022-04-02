//
//  SpotifyProvider.swift
//  SongSearcher
//
//  Created by Zheng-Yuan Yu on 2022/3/19.
//

import Foundation
import PromiseKit

enum Library {
    case KKBOX(query: String?, type: String?)
    case AppleMusic(query: String?, type: String?)

    var host: String {
        switch self {
        case .KKBOX:
            return "api.kkbox.com"
        case .AppleMusic:
            return "api.music.apple.com"
        }
    }

    var path: String {
        switch self {
        case .KKBOX:
            return "/v1.1/search"
        case .AppleMusic:
            return "/v1/catalog/tw/search"
        }
    }

    var query: [URLQueryItem] {
        switch self {
        case .KKBOX(let query, let type):
            return [URLQueryItem(name: "q", value: query),
                    URLQueryItem(name: "type", value: type),
                    URLQueryItem(name: "territory", value: "TW")]
        case .AppleMusic(let query, let type):
            return [URLQueryItem(name: "term", value: query),
                    URLQueryItem(name: "types", value: type)]
        }
    }
}

final class HTTPProvider {

    private init() {}

    static let shared = HTTPProvider()

    let httpClient = HTTPClient()

    func fetchKKBOXAccessToken() -> Promise<String> {
        Promise<String> { seal in
            var authUrl: URL? {
                guard let url = APIResource.shared.basicUrl,
                      var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
                          return nil
                      }

                urlComponents.host = "account.kkbox.com"
                urlComponents.path = "/oauth2/token"

                return urlComponents.url
            }

            guard let clientId = APIResource.shared.getCredential(of: .kkbox_client_id),
                  let clientSecret = APIResource.shared.getCredential(of: .kkbox_client_secret) else {
                      return
                  }

            let curlBody = "grant_type=client_credentials&client_id=\(clientId)&client_secret=\(clientSecret)".data(using: .utf8)

            let request = URLRequest(url: authUrl!, method: .POST, header: ["Content-Type": "application/x-www-form-urlencoded"], body: curlBody)

            httpClient.requestData(request) { (result: Swift.Result<KKBOXAuth, Error>) in
                switch result {
                case .success(let responseAuth):
                    seal.fulfill(responseAuth.accessToken)
                case .failure(let error):
                    seal.reject(error)
                }
            }
        }
    }

    func query<T>(library: Library, token: String) -> Promise<T> {
        Promise<T> { seal in
            var searchUrl: URL? {
                guard let url = APIResource.shared.basicUrl,
                      var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
                          return nil
                      }

                urlComponents.host = library.host
                urlComponents.path = library.path
                urlComponents.queryItems = library.query

                return urlComponents.url
            }

            let request = URLRequest(url: searchUrl!, method: .GET, header: ["Authorization": "Bearer \(token)"])

            switch library {
            case .KKBOX(_, _):
                httpClient.requestData(request) { (result: Swift.Result<KKBOXResponse, Error>) in
                    switch result {
                    case .success(let responseTrack):
                        seal.fulfill(responseTrack.tracks.data as! T)
                    case .failure(let error):
                        seal.reject(error)
                    }
                }
            case .AppleMusic(_, _):
                httpClient.requestData(request) { (result: Swift.Result<AppleResponse, Error>) in
                    switch result {
                    case .success(let responseTrack):
                        seal.fulfill(responseTrack.results.songs.data as! T)
                    case .failure(let error):
                        seal.reject(error)
                    }
                }
            }
        }
    }
}
