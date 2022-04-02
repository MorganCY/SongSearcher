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

struct KKBOXResponse: Codable {
    var tracks: KKBOXTrackResponse
}

struct KKBOXTrackResponse: Codable {
    var data: [KKBOXTrack]
}

struct KKBOXTrack: Codable {
    var name: String
    var album: KKBOXAlbum
}

struct KKBOXAlbum: Codable {
    var artist: KKBOXArtist
    var images: [KKBOXTrackImage]
}

struct KKBOXTrackImage: Codable {
    var url: String
}

struct KKBOXArtist: Codable {
    var name: String
}
