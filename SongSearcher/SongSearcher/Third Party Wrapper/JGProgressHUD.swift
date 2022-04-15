//
//  JGProgressHUD.swift
//  SongSearcher
//
//  Created by Zheng-Yuan Yu on 2022/4/10.
//

import Foundation
import JGProgressHUD

final class ToastDisplayer {

    enum ToastType {
        case loading
        case error
    }

    enum ToastText: String {
        case loading = "下載中"
        case error = "資料載入異常"
    }

    static let shared = ToastDisplayer()
    private init() {}
    let hud = JGProgressHUD(style: .light)

    func showToast(type: ToastType, text: ToastText) {
        if !Thread.isMainThread {
            DispatchQueue.main.async {
                self.showToast(type: type, text: text)
            }
            return
        }

        let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate

        hud.indicatorView = JGProgressHUDIndeterminateIndicatorView()
        hud.textLabel.text = text.rawValue
        hud.show(in: sceneDelegate?.window ?? UIView())

        if type == .error {
            hud.dismiss(afterDelay: 1.5)
        }
    }
}
