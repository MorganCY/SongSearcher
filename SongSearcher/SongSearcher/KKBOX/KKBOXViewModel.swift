//
//  ViewModel.swift
//  SongSearcher
//
//  Created by Zheng-Yuan Yu on 2022/3/20.
//

import Foundation
import PromiseKit

class KKBOXViewModel {

    enum QueryType: String {
        case track
        case artist
    }

    let trackViewModels = Box([TrackViewModel]())

    var accessToken: String?
    var refreshView: (() -> Void)?

    func fetchAccessToken() {
        _ = KKBOXProvider.shared.fetchAccessToken()
            .done { token in
                self.accessToken = token
            }
            .catch { error in
                print(error)
            }
    }

    func fetchTracks(query: String, type: String) {
        guard let accessToken = accessToken else {
            return
        }

        _ = KKBOXProvider.shared.query(accessToken: accessToken, query: query, type: type)
            .done { tracks in
                self.trackViewModels.value.removeAll()
                self.setTrackList(tracks)
            }
    }

    func onRefresh() {
        self.refreshView?()
    }

    func setTrackList(_ trackList: [KKBOXTrackData]) {
        trackViewModels.value += convertTracksToViewModels(from: trackList)
    }

    func convertTracksToViewModels(from tracks: [KKBOXTrackData]) -> [TrackViewModel] {
        var viewModels = [TrackViewModel]()
        for track in tracks {
            let viewModel = TrackViewModel(track)
            viewModels.append(viewModel)
        }
        return viewModels
    }
}
