//
//  HomeViewModel.swift
//  CleanArchitecture
//
//  Created by Sophearath.chhan on 9/18/26.
//

import Foundation
import Combine

@MainActor
final class HomeViewModel: ObservableObject {
    
    // private(set) Can modify inside the class
    @Published private(set) var items: [FeedItem] = []
    @Published private(set) var isLoading: Bool = false
    @Published private(set) var errorMessage: String?
    
    @Published var isUIStateView : UIState = .idle

    private let getFeedUseCase: GetFeedUseCaseProtocol

    init(getFeedUseCase: GetFeedUseCaseProtocol) {
        self.getFeedUseCase = getFeedUseCase
        
    }

    func loadFeed() async {
        
        isUIStateView = .loading
        
        do {
            items = try await getFeedUseCase.execute()
            isUIStateView = .idle
        } catch {
//            isUIStateView = .failedAction(error: <#T##AppMessage#>, leftBtn: <#T##ButtonInfo?#>, rightBtn: <#T##ButtonInfo#>)

        }
    }
}
