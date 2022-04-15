//
//  APIResource.swift
//  SongSearcher
//
//  Created by Zheng-Yuan Yu on 2022/3/29.
//

import Foundation

final class APIResource {

    enum CredentialType: String {
        case kkbox_client_id
        case kkbox_client_secret
        case apple_developer_token
        case spotify_client_id
        case spotify_client_secret
    }

    private init() {}

    static let shared = APIResource()

    var basicUrl: URL? {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"

        return urlComponents.url
    }

    var apiKeyPlist: NSDictionary? {
        guard let filePath = Bundle.main.path(forResource: "APIKeys", ofType: "plist") else {
            fatalError("Couldn't find the api key.")
        }
        return NSDictionary(contentsOfFile: filePath)
    }

    func getCredential(of type: CredentialType) -> String? {
        apiKeyPlist?.object(forKey: type.rawValue) as? String
    }
}
