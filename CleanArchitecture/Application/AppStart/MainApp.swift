//
//  CleanArchitectureApp.swift
//  CleanArchitecture
//
//  Created by Sophearath.chhan on 9/18/26.
//

import SwiftUI

@main
struct MainApp: App {
    
    // MARK: - Connect to AppDelegate
//    @UIApplicationDelegateAdaptor(AppDelegate.self)
//    private var appDelegate
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            AppCoordinatorView()
        }
    }
}


