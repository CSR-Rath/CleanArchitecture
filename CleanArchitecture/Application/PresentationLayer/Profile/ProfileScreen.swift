//
//  ProfileScreen.swift
//  CleanArchitecture
//
//  Created by Sophearath.chhan on 9/18/26.
//

import SwiftUI

public struct ProfileScreen: View {
    @StateObject private var viewModel: ProfileViewModel

    @State var isShowSheet: Bool = false
    
    public init(viewModel: ProfileViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    public var body: some View {
        NavigationView {
            VStack {
                if viewModel.isLoading {
                    ProgressView("Loading Profile...")
                        // .accessibilityIdentifier(AccessibilityID.Profile.loadingView)
                } else if let error = viewModel.errorMessage {
                    VStack(spacing: 12) {
                        Text("Error: \(error)")
                            // .accessibilityIdentifier(AccessibilityID.Profile.errorText)
                            .foregroundColor(.red)
                        Button("Retry") {
                            Task { await viewModel.loadProfile() }
                        }
//                        // .accessibilityIdentifier(AccessibilityID.Profile.retryButton)
//                        .buttonStyle(.borderedProminent)
                    }
                } else if let user = viewModel.user {
                    
                    VStack{
                        Button("Retry") {
                            isShowSheet = true
                        }
                        // .accessibilityIdentifier(AccessibilityID.Profile.retryButton)
                        
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
                        Text("data: \(viewModel.user ?? User(id: -1, name: "", email: ""))")
                    }
                } else {
                    if #available(iOS 17.0, *) {
                        ContentUnavailableView("No Profile Data", systemImage: "person.slash")
                    } else {
                        // Fallback on earlier versions
                    }
                }
            }
            .navigationTitle("Profile")
        }
        .task {
            await viewModel.loadProfile()
        }
    }
}
