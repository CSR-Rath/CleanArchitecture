//
//  CleanArchitectureApp.swift
//  CleanArchitecture
//
//  Created by Sophearath.chhan on 9/18/26.
//

import SwiftUI

@main
struct AppStart: App {
    
    // MARK: Connect to AppDelegate
    @UIApplicationDelegateAdaptor(AppDelegate.self)
    private var appDelegate
    
    var body: some Scene {
        WindowGroup {
            EmptyView()
        }
    }
}


