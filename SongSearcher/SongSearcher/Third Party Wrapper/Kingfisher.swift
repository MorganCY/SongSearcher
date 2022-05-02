//
//  Kingfisher.swift
//  SongSearcher
//
//  Created by Zheng-Yuan Yu on 2022/5/1.
//

import UIKit
import Kingfisher

extension UIImageView {

    func loadImage(_ urlString: String, placeHolder: UIImage? = nil) {

        let url = URL(string: urlString)

        self.kf.indicatorType = .activity

        self.kf.setImage(with: url, placeholder: placeHolder)
    }
}
