//
//  TrackViewModel.swift
//  SongSearcher
//
//  Created by Zheng-Yuan Yu on 2022/3/20.
//

import Foundation

class TrackViewModel {
    var track: KKBOXTrackData

    init(_ track: KKBOXTrackData) {
        self.track = track
    }

    var name: String {
        return track.name
    }

    var urlString: String {
        return track.urlString
    }
}
