//
//  SpotifyResponse.swift
//  SongSearcher
//
//  Created by Zheng-Yuan Yu on 2022/4/3.
//

struct SpotifyAuth: Codable {
    var accessToken: String

    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
    }
}

struct SpotifyResponse: Codable {
    var tracks: SpotifyTrackReponse
}

struct SpotifyTrackReponse: Codable {
    var items: [SpotifyTrack]
}

struct SpotifyTrack: Codable {
    var album: SpotifyAlbum
    var artists: [SpotifyArtist]
    var name: String
    var externalUrls: ExternalUrls

    enum CodingKeys: String, CodingKey {
        case album
        case artists
        case name
        case externalUrls = "external_urls"
    }
}

struct SpotifyAlbum: Codable {
    var images: [SpotifyImage]
}

struct SpotifyImage: Codable {
    var url: String
}

struct SpotifyArtist: Codable {
    var name: String
}

struct ExternalUrls: Codable {
    var spotify: String
}
