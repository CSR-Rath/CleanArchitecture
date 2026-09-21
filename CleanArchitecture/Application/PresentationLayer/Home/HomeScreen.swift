//
//  HomeScreen.swift
//  CleanArchitecture
//
//  Created by Sophearath.chhan on 9/18/26.
//

import SwiftUI

public struct HomeScreen: View {
    @StateObject private var viewModel: HomeViewModel

    public init(viewModel: HomeViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    public var body: some View {
        NavigationView {
            VStack {
                if viewModel.isLoading {
                    ProgressView("Loading Feed...")
                        .accessibilityIdentifier(AccessibilityID.Home.loadingView)
                } else if let error = viewModel.errorMessage {
                    VStack(spacing: 12) {
                        Text("Error: \(error)")
                            .accessibilityIdentifier(AccessibilityID.Home.errorText)
                            .foregroundColor(.red)
                        Button("Retry") {
                            Task { await viewModel.loadFeed() }
                        }
                        .accessibilityIdentifier(AccessibilityID.Home.retryButton)
                        .buttonStyle(.borderedProminent)
                    }
                } else {
                    List(viewModel.items) { item in
                        VStack(alignment: .leading, spacing: 6) {
                            Text(item.title)
                                .font(.headline)
                                .accessibilityIdentifier(AccessibilityID.Home.postTitle(id: item.id))
                            Text(item.body)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                    }
                    .accessibilityIdentifier(AccessibilityID.Home.feedList)
                }
            }
            .navigationTitle("Feed")
        }
        .task {
            await viewModel.loadFeed()
        }
    }
}
