//
//  GetFeedUseCase.swift
//  CleanArchitecture
//
//  Created by Sophearath.chhan on 9/18/26.
//

import Foundation

public protocol GetFeedUseCaseProtocol {
    func execute() async throws -> [FeedItem]
}

public final class GetFeedUseCase: GetFeedUseCaseProtocol {
    private let repository: FeedRepositoryProtocol

    public init(repository: FeedRepositoryProtocol) {
        self.repository = repository
    }

    public func execute() async throws -> [FeedItem] {
        return try await repository.getFeed()
    }
}
