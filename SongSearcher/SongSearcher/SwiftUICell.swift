//
//  SwiftUICell.swift
//  SongSearcher
//
//  Created by Zheng-Yuan Yu on 2022/3/31.
//

import Foundation
import SwiftUI

class SwiftUICell<Content: View>: UITableViewCell {
    override func prepareForReuse() {
        super.prepareForReuse()
        contentView.subviews.forEach {
            $0.removeFromSuperview()
        }
    }

    func configure(_ content: Content) {
        let configuredContent = UIHostingController(rootView: content)
        configuredContent.view.backgroundColor = .clear
        contentView.addSubview(configuredContent.view)
        configuredContent.view.translatesAutoresizingMaskIntoConstraints = false
        contentView.stickSubView(configuredContent.view)
    }
}
