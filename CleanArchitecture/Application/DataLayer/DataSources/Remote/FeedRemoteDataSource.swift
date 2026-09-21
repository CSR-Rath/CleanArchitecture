//
//  FeedRemoteDataSource.swift
//  CleanArchitecture
//
//  Created by Sophearath.chhan on 9/18/26.
//

import Foundation

public protocol FeedRemoteDataSourceProtocol {
    func fetchPosts() async throws -> [FeedItemDTO]
}

public final class FeedRemoteDataSource: FeedRemoteDataSourceProtocol {
    private let networkClient: NetworkClientProtocol

    public init(networkClient: NetworkClientProtocol) {
        self.networkClient = networkClient
    }

    public func fetchPosts() async throws -> [FeedItemDTO] {
        let request = try APIRequestBuilder.makeRequest(path: .posts)
        return try await networkClient.request(request)
    }
}
