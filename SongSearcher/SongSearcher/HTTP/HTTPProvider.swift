//
//  SpotifyProvider.swift
//  SongSearcher
//
//  Created by Zheng-Yuan Yu on 2022/3/19.
//

import Foundation
import PromiseKit

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

    func fetchSpotifyAccessToken()  -> Promise<String> {
        Promise<String> { seal in
            var authUrl: URL? {
                guard let url = APIResource.shared.basicUrl,
                      var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
                          return nil
                      }

                urlComponents.host = "accounts.spotify.com"
                urlComponents.path = "/api/token"

                return urlComponents.url
            }

            guard let clientId = APIResource.shared.getCredential(of: .spotify_client_id) else {
                      return
                  }
            let request = URLRequest(url: authUrl!, method: .POST, header: ["Authorization": "Basic \(clientId)", "Content-Type": "application/x-www-form-urlencoded"], body: "grant_type=client_credentials".data(using: .utf8))

            httpClient.requestData(request) { (result: Swift.Result<SpotifyAuth, Error>) in
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

                urlComponents.host = library.queryHost
                urlComponents.path = library.queryPath
                urlComponents.queryItems = library.condition

                return urlComponents.url
            }

            let request = URLRequest(url: searchUrl!, method: .GET, header: ["Authorization": "Bearer \(token)"])

            switch library {
            case .KKBOX:
                httpClient.requestData(request) { (result: Swift.Result<KKBOXResponse, Error>) in
                    switch result {
                    case .success(let responseTrack):
                        seal.fulfill(responseTrack.tracks.data as! T)
                    case .failure(let error):
                        seal.reject(error)
                    }
                }
            case .AppleMusic:
                httpClient.requestData(request) { (result: Swift.Result<AppleResponse, Error>) in
                    switch result {
                    case .success(let responseTrack):
                        seal.fulfill(responseTrack.results.songs.data as! T)
                    case .failure(let error):
                        seal.reject(error)
                    }
                }
            case .Spotify:
                httpClient.requestData(request) { (result: Swift.Result<SpotifyResponse, Error>) in
                    switch result {
                    case .success(let responseTrack):
                        seal.fulfill(responseTrack.tracks.items as! T)
                    case .failure(let error):
                        seal.reject(error)
                    }
                }
            }
        }
    }
}
