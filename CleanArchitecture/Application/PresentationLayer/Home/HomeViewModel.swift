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

    private let getFeedUseCase: GetFeedUseCaseProtocol

    public init(getFeedUseCase: GetFeedUseCaseProtocol) {
        self.getFeedUseCase = getFeedUseCase
        
    }

    public func loadFeed() async {
        isLoading = true
        errorMessage = nil
        do {
            items = try await getFeedUseCase.execute()
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }
}
