//
//  AppleMusicResponse.swift
//  SongSearcher
//
//  Created by Zheng-Yuan Yu on 2022/4/2.
//

import Foundation

struct AppleResponse: Codable {
    var results: AppleTrackList
}

struct AppleTrackList: Codable {
    var songs: AppleSongs
}

struct AppleSongs: Codable {
    var data: [AppleTrack]
}

struct AppleTrack: Codable {
    var attributes: AppleTrackData
}

struct AppleTrackData: Codable {
    var artwork: AppleArtwork
    var artistName: String
    var url: String
    var name: String
}

struct AppleArtwork: Codable {
    var url: String
}
