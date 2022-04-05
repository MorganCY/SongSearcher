//
//  Platform.swift
//  SongSearcher
//
//  Created by Zheng-Yuan Yu on 2022/4/4.
//

import Foundation

enum Library {
    case KKBOX(query: String?, type: String?)
    case AppleMusic(query: String?, type: String?)
    case Spotify(query: String?, type: String?)

    var queryHost: String {
        switch self {
        case .KKBOX:
            return "api.kkbox.com"
        case .AppleMusic:
            return "api.music.apple.com"
        case .Spotify:
            return "api.spotify.com"
        }
    }

    var queryPath: String {
        switch self {
        case .KKBOX:
            return "/v1.1/search"
        case .AppleMusic:
            return "/v1/catalog/tw/search"
        case .Spotify:
            return "/v1/search"
        }
    }

    var condition: [URLQueryItem] {
        switch self {
        case .KKBOX(let query, let type):
            return [URLQueryItem(name: "q", value: query),
                    URLQueryItem(name: "type", value: type),
                    URLQueryItem(name: "territory", value: "TW"),
                    URLQueryItem(name: "limit", value: "8")]
        case .AppleMusic(let query, let type):
            return [URLQueryItem(name: "term", value: query),
                    URLQueryItem(name: "types", value: type),
                    URLQueryItem(name: "limit", value: "8")]
        case .Spotify(let query, let type):
            return [URLQueryItem(name: "q", value: query),
                    URLQueryItem(name: "type", value: type),
                    URLQueryItem(name: "limit", value: "8")]
        }
    }
}
