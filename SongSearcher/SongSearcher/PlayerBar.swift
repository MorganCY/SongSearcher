//
//  PlayerBar.swift
//  SongSearcher
//
//  Created by Zheng-Yuan Yu on 2022/5/1.
//

import Foundation
import UIKit

class PlayerBar: UIView {

    let trackThumbnail = UIImageView()
    let trackNameLabel = UILabel()
    let artistLabel = UILabel()
    let playPauseButton = UIButton()
    let musicPlayer = MusicPlayer()
    var isPlaying = false

    init(viewModel: TrackViewModel) {
        super.init(frame: .zero)
        setTrackThumbnail(thumbnail: viewModel.imageUrlString)
        setTrackNameLabel(track: viewModel.name)
        setArtistLabel(artist: viewModel.artist)
        setPlayPauseButton()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setup() {
        layoutPosition()
        setBackground()
    }

    func setBackground() {
        backgroundColor = .Major
        layer.cornerRadius = 10
    }

    func setTrackThumbnail(thumbnail: String) {
        trackThumbnail.do {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.layer.cornerRadius = 6
            $0.clipsToBounds = true
            $0.loadImage(thumbnail, placeHolder: nil)
            NSLayoutConstraint.activate([
                $0.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
                $0.centerYAnchor.constraint(equalTo: centerYAnchor),
                $0.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.1),
                $0.heightAnchor.constraint(equalTo: widthAnchor, multiplier: 0.1)
            ])
        }
    }

    func setTrackNameLabel(track: String) {
        trackNameLabel.do {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.textColor = .white
            $0.font = UIFont(name: "PingfangTC-Regular", size: 14)
            $0.text = track + " " + "(試聽)"
            NSLayoutConstraint.activate([
                $0.leadingAnchor.constraint(equalTo: trackThumbnail.trailingAnchor, constant: 16),
                $0.topAnchor.constraint(equalTo: trackThumbnail.topAnchor),
                $0.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.6)
            ])
        }
    }

    func setArtistLabel(artist: String) {
        artistLabel.do {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.textColor = .white
            $0.font = UIFont(name: "PingfangTC-Regular", size: 10)
            $0.text = artist
            NSLayoutConstraint.activate([
                $0.leadingAnchor.constraint(equalTo: trackNameLabel.leadingAnchor),
                $0.bottomAnchor.constraint(equalTo: trackThumbnail.bottomAnchor)
            ])
        }
    }

    func setPlayPauseButton() {
        playPauseButton.do {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.setBackgroundImage(UIImage(named: "pauseButton"), for: .normal)
            NSLayoutConstraint.activate([
                $0.centerYAnchor.constraint(equalTo: centerYAnchor),
                $0.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
                $0.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.05),
                $0.heightAnchor.constraint(equalTo: widthAnchor, multiplier: 0.05)
            ])
        }
        playPauseButton.addTarget(self, action: #selector(playPauseButtonDidTap(_:)) , for: .touchUpInside)
    }

    @objc
    func playPauseButtonDidTap(_ sender: UIButton) {
        updateImage()
    }

    private func updatePlayStatus(url: URL) {
        // 傳入 track url
    }

    private func updateImage() {
        if isPlaying {
            playPauseButton.setBackgroundImage(UIImage(named: "pauseButton"), for: .normal)
        } else {
            playPauseButton.setBackgroundImage(UIImage(named: "playButton"), for: .normal)
        }
    }

    private func layoutPosition() {
        guard let superview = superview else { return }
        translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            widthAnchor.constraint(equalTo: superview.widthAnchor, multiplier: 0.9),
            heightAnchor.constraint(equalTo: superview.heightAnchor, multiplier: 0.06),
            centerXAnchor.constraint(equalTo: superview.centerXAnchor),
            bottomAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}
