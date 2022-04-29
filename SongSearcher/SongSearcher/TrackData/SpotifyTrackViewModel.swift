//
//  SpotifyTrackViewModel.swift
//  SongSearcher
//
//  Created by Zheng-Yuan Yu on 2022/4/3.
//

import Foundation

class SpotifyTrackViewModel: TrackViewModel {

    var track: SpotifyTrack

    init(_ track: SpotifyTrack) {
        self.track = track
    }

    var name: String {
        return track.name
    }

    var artist: String {
        return track.artists[0].name
    }

    var imageUrlString: String {
        return track.album.images[0].url
    }
}
