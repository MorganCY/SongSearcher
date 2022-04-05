//
//  UIApplication+Extension.swift
//  SongSearcher
//
//  Created by Zheng-Yuan Yu on 2022/4/5.
//

import Foundation
import UIKit

extension UIApplication {
    var statusBarView: UIView? {
        if responds(to: Selector(("statusBar"))) {
            return value(forKey: "statusBar") as? UIView
        }
        return nil
    }
}
