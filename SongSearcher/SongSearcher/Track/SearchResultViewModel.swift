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

    var accessToken: String?
    var refreshView: (() -> Void)?

    func fetchAccessToken() {
        _ = HTTPProvider.shared.fetchKKBOXAccessToken()
            .done { token in
                self.accessToken = token
            }
            .catch { error in
                print(error)
            }
    }

    func fetchTracks(library: Library) {
        switch library {

        case .KKBOX(query: _, type: _):

            guard let accessToken = accessToken else {
                return
            }

            _ = HTTPProvider.shared.query(library: library, token: accessToken)
                .done { (tracks: [KKBOXTrack]) in
                    self.setKKBOXTrackList(tracks)
                }
        case .AppleMusic(query: _, type: _):

            guard let token =  APIResource.shared.getCredential(of: .apple_developer_token) else {
                return
            }

            _ = HTTPProvider.shared.query(library: library, token: token)
                .done { (tracks: [AppleTrack]) in
                    self.setAppleMusicTrackList(tracks)
                }
        }
    }

    func onRefresh() {
        self.refreshView?()
    }

    func setKKBOXTrackList(_ trackList: [KKBOXTrack]) {
        trackViewModels.value = convertKKBOXTracksToViewModels(from: trackList)
    }

    func setAppleMusicTrackList(_ trackList: [AppleTrack]) {
        trackViewModels.value = convertAppleMusicTracksToViewModels(from: trackList)
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
}