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
        ZStack {
            Color(red: 235 / 255, green: 231 / 255, blue: 227 / 255)
                .ignoresSafeArea()
            HStack {
                KFImage(URL(string: viewModel.imageUrlString))
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 40, height: 40)
                    .cornerRadius(10)

                VStack(alignment: .leading) {
                    Text(viewModel.name)
                        .font(.body)
                        .foregroundColor(.black)
                        .lineLimit(1)
                    Text(viewModel.artist)
                        .font(.caption)
                        .foregroundColor(.gray)
                        .lineLimit(1)
                }
                Spacer()
            }
            .padding(.horizontal, 20)
        .padding(.vertical, 12)
        }
    }
}

struct TrackCell_Preview: PreviewProvider {
    static var previews: some View {
        TrackCell(viewModel: KKBOXTrackViewModel.init(KKBOXTrack(name: "軌跡", album: KKBOXAlbum(artist: KKBOXArtist(name: "周杰倫"), images: [KKBOXTrackImage(url: "https://i.kfs.io/album/tw/47735,0v3/fit/160x160.jpg")]))))
    }
}
