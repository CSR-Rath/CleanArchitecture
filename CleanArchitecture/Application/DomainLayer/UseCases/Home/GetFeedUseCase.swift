//
//  GetFeedUseCase.swift
//  CleanArchitecture
//
//  Created by Sophearath.chhan on 9/18/26.
//

import Foundation

protocol GetFeedUseCaseProtocol {
    func execute() async throws -> [FeedItem]
}

final class GetFeedUseCase: GetFeedUseCaseProtocol {
    private let repository: FeedRepositoryProtocol
    
    init(repository: FeedRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute() async throws -> [FeedItem] {
        return try await repository.getFeed()
    }
}
