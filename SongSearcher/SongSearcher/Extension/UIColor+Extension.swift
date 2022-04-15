//
//  UIColor+Extension.swift
//  SongSearcher
//
//  Created by Zheng-Yuan Yu on 2022/4/4.
//

import UIKit

enum BaseColor: String {
    case Major
    case BG
}

extension UIColor {

    static let Major = baseColor(.Major) ?? UIColor(red: 0 / 255, green: 50 / 255, blue: 78 / 255, alpha: 1)
    static let BG = baseColor(.BG) ?? UIColor(red: 235 / 255, green: 231 / 255, blue: 227 / 255, alpha: 1)

    private static func baseColor(_ color: BaseColor) -> UIColor? {

        return UIColor(named: color.rawValue)
    }
}

