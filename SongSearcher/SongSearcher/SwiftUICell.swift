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
        let content = UIHostingController(rootView: content)
        content.view.backgroundColor = .clear
        contentView.addSubview(content.view)
        content.view.translatesAutoresizingMaskIntoConstraints = false
        contentView.stickSubView(content.view)
    }
}
