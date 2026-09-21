//
//  CleanArchitectureApp.swift
//  CleanArchitecture
//
//  Created by Sophearath.chhan on 9/18/26.
//

import SwiftUI

@main
struct CleanArchitectureApp: App {
    private let networkClient = NetworkClient()

    var body: some Scene {
        WindowGroup {
            TabView {
                
                // Optaion 1
                ProfileScreen(viewModel: ProfileDIContainer.init(networkClient: networkClient).makeProfileVM())
                    .tabItem {
                        Label("Profile", systemImage: "person")
                    }
                    .tag(0)
                
                HomeScreen(viewModel: HomeDIContainer.init(networkClient: networkClient).makeHomeVM())
                    .tabItem {
                        Label("Feed", systemImage: "house")
                    }
                    .tag(1)
                
                
                // Optaion 2
//                HomeDIContainer(networkClient: networkClient).makeHomeView()
//                    .tabItem {
//                        Label("Feed", systemImage: "house")
//                    }
//                    .tag(1)
//                
//                ProfileDIContainer(networkClient: networkClient).makeProfileView()
//                    .tabItem {
//                        Label("Profile", systemImage: "person")
//                    }
//                    .tag(0)

            }
        }
    }
}
