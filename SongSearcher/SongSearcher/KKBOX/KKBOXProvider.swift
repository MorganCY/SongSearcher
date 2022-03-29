//
//  SpotifyProvider.swift
//  SongSearcher
//
//  Created by Zheng-Yuan Yu on 2022/3/19.
//

import Foundation
import PromiseKit

final class KKBOXProvider {
    private init() {}

    static let shared = KKBOXProvider()

    let httpClient = HTTPClient()

    func fetchAccessToken() -> Promise<String> {
        Promise<String> { seal in
            var authUrl: URL? {
                guard let url = APIResource.shared.basicUrl,
                      var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
                          return nil
                      }

                urlComponents.host = "account.kkbox.com"
                urlComponents.path += "/oauth2"
                urlComponents.path += "/token"

                return urlComponents.url
            }

            guard let clientId = APIResource.shared.getCredential(of: .client_id),
                  let clientSecret = APIResource.shared.getCredential(of: .client_secret) else {
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

    func query(accessToken: String, query: String, type: StringLiteralType) -> Promise<[KKBOXTrackData]> {
        Promise<[KKBOXTrackData]> { seal in
            var searchUrl: URL? {
                guard let url = APIResource.shared.basicUrl,
                      var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
                          return nil
                      }

                urlComponents.host = "api.kkbox.com"
                urlComponents.path += "/v1.1"
                urlComponents.path += "/search"
                urlComponents.queryItems = [
                    URLQueryItem(name: "q", value: query),
                    URLQueryItem(name: "type", value: type),
                    URLQueryItem(name: "territory", value: "TW")
                ]

                return urlComponents.url
            }

            let request = URLRequest(url: searchUrl!, method: .GET, header: ["Authorization": "Bearer \(accessToken)"])

            httpClient.requestData(request) { (result: Swift.Result<KKBOXTrackResponse, Error>) in
                switch result {
                case .success(let responseTrack):
                    seal.fulfill(responseTrack.tracks.data)
                case .failure(let error):
                    seal.reject(error)
                }
            }
        }
    }
}
