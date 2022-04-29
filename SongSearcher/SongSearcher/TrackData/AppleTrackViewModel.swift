//
//  AppleMusicTrackViewModel.swift
//  SongSearcher
//
//  Created by Zheng-Yuan Yu on 2022/4/2.
//

import Foundation
import MusicKit

class AppleTrackViewModel: TrackViewModel {
    var track: AppleTrack

    init(_ track: AppleTrack) {
        self.track = track
    }

    var name: String {
        return track.attributes.name
    }

    var artist: String {
        return track.attributes.artistName
    }

    var imageUrlString: String {
        return convertArtWorkUrl(url: track.attributes.artwork.url)
    }

    func convertArtWorkUrl(url: String) -> String {
        var imageUrlString = url.replacingOccurrences(of: "{w}", with: "100")
        imageUrlString = imageUrlString.replacingOccurrences(of: "{h}", with: "100")
        return imageUrlString
    }
}
