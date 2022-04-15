//
//  UIView+Extension.swift
//  SongSearcher
//
//  Created by Zheng-Yuan Yu on 2022/4/1.
//

import UIKit

extension UIView {
    func stickSubView(_ subView: UIView) {
        guard subviews.contains(subView) else {
            return
        }
        subView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            leadingAnchor.constraint(equalTo: subView.leadingAnchor),
            trailingAnchor.constraint(equalTo: subView.trailingAnchor),
            topAnchor.constraint(equalTo: subView.topAnchor),
            bottomAnchor.constraint(equalTo: subView.bottomAnchor)
        ])
    }
}
