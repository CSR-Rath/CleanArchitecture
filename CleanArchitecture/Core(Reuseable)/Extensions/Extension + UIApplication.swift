//
//  Extension + UIApplication.swift
//  CleanArchitecture
//
//  Created by Sophearath.chhan on 10/6/26.
//

import UIKit

extension UIApplication {

    var keyWindow: UIWindow? {
        connectedScenes
            .compactMap { $0 as? UIWindowScene}
            .flatMap(\.windows)
            .first { $0.isKeyWindow}
    }

    func topMostViewController(base: UIViewController? = nil) -> UIViewController? {

        let root = base ?? keyWindow?.rootViewController

        if let navigationController = root as? UINavigationController {

            return topMostViewController(  base: navigationController.visibleViewController)
        }

        if let tabBarController = root as? UITabBarController {

            return topMostViewController(base: tabBarController.selectedViewController)
        }

        if let presented = root?.presentedViewController {

            return topMostViewController(base: presented)
        }

        return root
    }
}
