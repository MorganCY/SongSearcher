//
//  TrackCell.swift
//  SongSearcher
//
//  Created by Zheng-Yuan Yu on 2022/3/20.
//

import Foundation
import SwiftUI
import Kingfisher

struct TrackCell: View {

    var viewModel: TrackViewModel

    init(viewModel: TrackViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        HStack {
            KFImage(URL(string: viewModel.imageUrlString))
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 40, height: 40)

            VStack(alignment: .leading) {
                Text(viewModel.name)
                    .font(.body)
                    .foregroundColor(.black)
                Text(viewModel.artist)
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 12)
    }
}

struct TrackCell_Preview: PreviewProvider {
    static var previews: some View {
        TrackCell(viewModel: KKBOXTrackViewModel.init(KKBOXTrack(name: "軌跡", album: KKBOXAlbum(artist: KKBOXArtist(name: "周杰倫"), images: [KKBOXTrackImage(url: "https://i.kfs.io/album/tw/47735,0v3/fit/160x160.jpg")]))))
    }
}
