//
//  SceneDelegate.swift
//  CleanArchitecture
//
//  Created by Sophearath.chhan on 10/6/26.
//

import UIKit
import SwiftUI

final class SceneDelegate: NSObject, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = scene as? UIWindowScene else {return}
        
        
        let hostingController = UIHostingController(rootView: AppCoordinatorView())
        
        let window = AutoTimeoutWindow(windowScene: windowScene)
        window.rootViewController = hostingController
        self.window = window
        window.makeKeyAndVisible()
        
        SessionTimeoutManager.shared.resetSession()
        
    }
}
