//
//  FeedRemoteDataSource.swift
//  CleanArchitecture
//
//  Created by Sophearath.chhan on 9/18/26.
//

import Foundation

protocol FeedRemoteDataSourceProtocol {
    func fetchPosts() async throws -> [FeedItemDTO]
}

final class FeedRemoteDataSource: FeedRemoteDataSourceProtocol {
    private let networkClient: NetworkClientProtocol

    init(networkClient: NetworkClientProtocol) {
        self.networkClient = networkClient
    }

    func fetchPosts() async throws -> [FeedItemDTO] {
        let request = try BuildRequest.makeRequest(path: .posts)
        return try await networkClient.request(request)
    }
}
