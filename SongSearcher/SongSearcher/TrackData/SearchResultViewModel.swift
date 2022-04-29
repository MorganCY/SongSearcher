//
//  ViewModel.swift
//  SongSearcher
//
//  Created by Zheng-Yuan Yu on 2022/3/20.
//

import Foundation
import PromiseKit

class SearchResultViewModel {

    enum QueryType: String {
        case track
        case artist
    }

    var trackViewModels = Box([TrackViewModel]())

    var kkboxAccessToken: String?
    var spotifyAccessToken: String?
    var refreshView: (() -> Void)?
    var loadView: (() -> Void)?
    var errorView: (() -> Void)?
    var dismissReminder: (() -> Void)?

    func fetchKKBOXAccessToken() {
        _ = HTTPProvider.shared.fetchKKBOXAccessToken()
            .done { token in
                self.kkboxAccessToken = token
            }
            .catch { _ in
                self.showError()
            }
    }

    func fetchSpotifyAccessToken() {
        _ = HTTPProvider.shared.fetchSpotifyAccessToken()
            .done { token in
                self.spotifyAccessToken = token
            }
            .catch{ _ in
                self.showError()
            }
    }

    func fetchTracks(library: Library) {

        showLoading()

        switch library {

        case .KKBOX:

            guard let accessToken = kkboxAccessToken else {
                return
            }

            _ = HTTPProvider.shared.query(library: library, token: accessToken)
                .done { (tracks: [KKBOXTrack]) in
                    self.dismissLoading()
                    self.setKKBOXTrackList(tracks)
                }
                .catch{ _ in
                    self.dismissLoading()
                    self.showError()
                }

        case .AppleMusic:

            guard let token = APIResource.shared.getCredential(of: .apple_developer_token) else {
                return
            }

            _ = HTTPProvider.shared.query(library: library, token: token)
                .done { (tracks: [AppleTrack]) in
                    self.dismissLoading()
                    self.setAppleMusicTrackList(tracks)
                }
                .catch{ _ in
                    self.dismissLoading()
                    self.showError()
                }

        case .Spotify:

            guard let accessToken = spotifyAccessToken else {
                return
            }

            _ = HTTPProvider.shared.query(library: library, token: accessToken)
                .done { (tracks: [SpotifyTrack]) in
                    self.dismissLoading()
                    self.setSpotifyTrackList(tracks)
                }
                .catch{ _ in
                    self.dismissLoading()
                    self.showError()
                }
        }
    }

    func onRefresh() {
        self.refreshView?()
    }

    func showLoading() {
        self.loadView?()
    }

    func showError() {
        self.errorView?()
    }

    func dismissLoading() {
        self.dismissReminder?()
    }

    func setKKBOXTrackList(_ trackList: [KKBOXTrack]) {
        trackViewModels.value = convertKKBOXTracksToViewModels(from: trackList)
    }

    func setAppleMusicTrackList(_ trackList: [AppleTrack]) {
        trackViewModels.value = convertAppleMusicTracksToViewModels(from: trackList)
    }

    func setSpotifyTrackList(_ trackList: [SpotifyTrack]) {
        trackViewModels.value = convertSpotifyTracksToViewModels(from: trackList)
    }

    func convertKKBOXTracksToViewModels(from tracks: [KKBOXTrack]) -> [KKBOXTrackViewModel] {
        var viewModels = [KKBOXTrackViewModel]()
        for track in tracks {
            let viewModel = KKBOXTrackViewModel(track)
            viewModels.append(viewModel)
        }
        return viewModels
    }

    func convertAppleMusicTracksToViewModels(from tracks: [AppleTrack]) -> [AppleTrackViewModel] {
        var viewModels = [AppleTrackViewModel]()
        for track in tracks {
            let viewModel = AppleTrackViewModel(track)
            viewModels.append(viewModel)
        }
        return viewModels
    }

    func convertSpotifyTracksToViewModels(from tracks: [SpotifyTrack]) -> [SpotifyTrackViewModel] {
        var viewModels = [SpotifyTrackViewModel]()
        for track in tracks {
            let viewModel = SpotifyTrackViewModel(track)
            viewModels.append(viewModel)
        }
        return viewModels
    }

    func removeTrackList() {
        trackViewModels.value = []
    }
}
