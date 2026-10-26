//
//  ProfileScreen.swift
//  CleanArchitecture
//
//  Created by Sophearath.chhan on 9/18/26.
//

import SwiftUI

struct ProfileScreen: View {
    @StateObject private var viewModel: ProfileViewModel
    
    @State var isShowSheet: Bool = false
    
    init(viewModel: ProfileViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        
        VStack {
            if viewModel.state == .loading {
                ProgressView("Loading Profile...")
                // .accessibilityIdentifier(AccessibilityID.Profile.loadingView)
            }else if let user = viewModel.user {
                
                VStack{
                    
                    List {
                        Section(header: Text("Details")) {
                            Text("Name: \(user.name)")
                            // .accessibilityIdentifier(AccessibilityID.Profile.nameText)
                            Text("Email: \(user.email)")
                            // .accessibilityIdentifier(AccessibilityID.Profile.emailText)
                        }
                    }
                    // .accessibilityIdentifier(AccessibilityID.Profile.detailsList)
                }
                .sheet(isPresented: $isShowSheet) {
                    Text("data: \(viewModel.user?.email ?? "")")
                }
            } else {
                if #available(iOS 17.0, *) {
                    ContentUnavailableView("No Profile Data", systemImage: "person.slash")
                } else {
                    // Fallback on earlier versions
                }
            }
        }
        
        .onViewDidLoad {
            
        }
        .onAppear(){
            Task{
                await viewModel.loadProfile()
            }
        }
    }
}
