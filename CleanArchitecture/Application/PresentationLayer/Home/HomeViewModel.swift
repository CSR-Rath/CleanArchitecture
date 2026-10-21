//
//  HomeViewModel.swift
//  CleanArchitecture
//
//  Created by Sophearath.chhan on 9/18/26.
//

import Foundation
import Combine

@MainActor
public final class HomeViewModel: ObservableObject {
    
    // private(set) Can modify inside the class
    @Published public private(set) var items: [FeedItem] = []
    @Published public private(set) var isLoading: Bool = false
    @Published public private(set) var errorMessage: String?
    
    @Published var isUIStateView : UIStateView = .idle

    private let getFeedUseCase: GetFeedUseCaseProtocol

    public init(getFeedUseCase: GetFeedUseCaseProtocol) {
        self.getFeedUseCase = getFeedUseCase
        
    }

    public func loadFeed() async {
        
        isUIStateView = .loading
        
        do {
            items = try await getFeedUseCase.execute()
            isUIStateView = .idle
        } catch {
            isUIStateView = .failed(error.asError)

        }
    }
}
