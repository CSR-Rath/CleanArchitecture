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
        BaseView(
            title: "Hello",
            isContentScrollView: true,
            onViewDidload: {
                Task{
                    await viewModel.loadFeed()
                }
            },
            
            onRefresh: {
                await viewModel.loadFeed()
            },
            leadingItem: {
                EmptyView()
            },
            header: {
                
                Text("Header")
            },
            content: {
                VStack {
                    
                    Text("content")
                    
                    if viewModel.isLoading {
                        ProgressView("Loading Feed...")
                            .background(Color.red)
                        // .accessibilityIdentifier(AccessibilityID.Home.loadingView)
                    } else if let error = viewModel.errorMessage {
                        VStack(spacing: 12) {
                            Text("Error: \(error)")
                            // .accessibilityIdentifier(AccessibilityID.Home.errorText)
                                .foregroundColor(.red)
                            Button("Retry") {
                                Task { await viewModel.loadFeed() }
                            }
                            .buttonStyle(.borderedProminent)
                        }
                    } else {
                        
                        List(viewModel.items) { item in
                            VStack(alignment: .leading, spacing: 6) {
                                
                                Text("\(1). \(item.title)")
                                    .font(.headline)
                                
                                Text(item.body)
                                    .font(.subheadline)
                                    .foregroundStyle(.orange)
                            }
                            
                            
                        }
                        
//                        ForEach(
//                            Array(viewModel.items.enumerated()),
//                            id: \.element.id
//                        ) { index, item in
//
//                            VStack(alignment: .leading, spacing: 6) {
//
//                                Text("\(index + 1). \(item.title)")
//                                    .font(.headline)
//
//                                Text(item.body)
//                                    .font(.subheadline)
//                                    .foregroundStyle(.orange)
//                            }
//                        }
                            
                            


                    }
                }
            },
            footer: {
                
                Text("footer")
            })
    }
}
