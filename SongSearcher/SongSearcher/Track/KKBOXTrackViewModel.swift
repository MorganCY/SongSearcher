//
//  TrackViewModel.swift
//  SongSearcher
//
//  Created by Zheng-Yuan Yu on 2022/3/20.
//

import Foundation

class KKBOXTrackViewModel: TrackViewModel {
    var track: KKBOXTrack

    init(_ track: KKBOXTrack) {
        self.track = track
    }

    var name: String {
        return track.name
    }

    var artist: String {
        return track.album.artist.name
    }

    var imageUrlString: String {
        return track.album.images[0].url
    }
}
