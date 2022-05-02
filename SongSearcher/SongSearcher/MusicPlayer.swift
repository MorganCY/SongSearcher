//
//  MusicPlayer.swift
//  SongSearcher
//
//  Created by Zheng-Yuan Yu on 2022/5/1.
//

import Foundation
import AVFoundation

class MusicPlayer {

    let avplayer = AVPlayer()

    func play(url: URL) {
        avplayer.replaceCurrentItem(with: AVPlayerItem(url: url))
        avplayer.play()
    }

    func stop() {
        avplayer.pause()
        avplayer.replaceCurrentItem(with: nil)
    }
}
