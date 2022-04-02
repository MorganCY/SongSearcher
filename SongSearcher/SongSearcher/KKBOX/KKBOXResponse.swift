//
//  Responses.swift
//  SongSearcher
//
//  Created by Zheng-Yuan Yu on 2022/3/19.
//

struct KKBOXAuth: Codable {
    var accessToken: String

    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
    }
}

struct KKBOXTrackResponse: Codable {
    var tracks: KKBOXTrack
}

struct KKBOXTrack: Codable {
    var data: [KKBOXTrackData]
}

struct KKBOXTrackData: Codable {
    var name: String
    var album: Album
}

struct Album: Codable {
    var artist: Artist
    var images: [TrackImage]
}

struct TrackImage: Codable {
    var urlString: String

    enum CodingKeys: String, CodingKey {
        case urlString = "url"
    }
}

struct Artist: Codable {
    var name: String
}
