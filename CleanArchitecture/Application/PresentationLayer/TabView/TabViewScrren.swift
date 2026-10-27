//
//  TabViewScrren.swift
//  CleanArchitecture
//
//  Created by Sophearath.chhan on 10/7/26.
//

import SwiftUI

struct TabViewScreen: View {
    
    private let profileViewModel: ProfileViewModel
    private let homeViewModel: HomeViewModel
    
    init() {
        let networkClient = NetworkClient()
        self.profileViewModel = ProfileDIContainer(networkClient: networkClient).makeProfileVM()
        self.homeViewModel = HomeDIContainer(networkClient: networkClient).makeHomeVM()
    }
    
    
    var body: some View {
        
        TabView {
            ProfileScreen(viewModel: profileViewModel)
                .tabItem {
                    Label("Profile", systemImage: "person")
                }
                .tag(0)
            
            HomeScreen(viewModel: homeViewModel)
                .tabItem {
                    Label("Feed", systemImage: "house")
                }
                .tag(1)
        }
    }
}
