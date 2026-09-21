//
//  FeedRepositoryImpl.swift
//  CleanArchitecture
//
//  Created by Sophearath.chhan on 9/18/26.
//

import Foundation

public final class FeedRepositoryImpl: FeedRepositoryProtocol {
    private let remoteDataSource: FeedRemoteDataSourceProtocol
    private let localDataSource: FeedLocalDataSourceProtocol

    public init(
        remoteDataSource: FeedRemoteDataSourceProtocol,
        localDataSource: FeedLocalDataSourceProtocol
    ) {
        self.remoteDataSource = remoteDataSource
        self.localDataSource = localDataSource
    }

    public func getFeed() async throws -> [FeedItem] {
        do {
            let dtos = try await remoteDataSource.fetchPosts()
            try? localDataSource.savePosts(dtos)
            return dtos.compactMap(FeedMapper.mapToDomain)
        } catch {
            let cachedDTOs = (try? localDataSource.getCachedPosts()) ?? []
            if cachedDTOs.isEmpty { throw error }
            return cachedDTOs.compactMap(FeedMapper.mapToDomain)
        }
    }
}

