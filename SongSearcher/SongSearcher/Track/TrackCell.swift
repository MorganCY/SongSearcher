//
//  TrackCell.swift
//  SongSearcher
//
//  Created by Zheng-Yuan Yu on 2022/3/20.
//

import Foundation
import UIKit

class TrackCell: UITableViewCell {
    @IBOutlet weak var label: UILabel!
    private var viewModel: TrackViewModel?

    func layoutCell(viewModel: TrackViewModel) {
        self.viewModel = viewModel
        layoutCell()
    }

    private func layoutCell() {
        guard let viewModel = viewModel else { return }
        label.text = viewModel.name
    }
}
