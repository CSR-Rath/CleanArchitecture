//
//  FeedLocalDataSource.swift
//  CleanArchitecture
//
//  Created by Sophearath.chhan on 9/18/26.
//

import Foundation

public protocol FeedLocalDataSourceProtocol {
    func getCachedPosts() throws -> [FeedItemDTO]
    func savePosts(_ posts: [FeedItemDTO]) throws
    func clearCache()
}

public final class FeedLocalDataSource: FeedLocalDataSourceProtocol {
    private let userDefaults: UserDefaults
    private let cacheKey = "cached_feed_posts"

    public init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }

    public func getCachedPosts() throws -> [FeedItemDTO] {
        guard let data = userDefaults.data(forKey: cacheKey) else { return [] }
        return try JSONDecoder().decode([FeedItemDTO].self, from: data)
    }

    public func savePosts(_ posts: [FeedItemDTO]) throws {
        let data = try JSONEncoder().encode(posts)
        userDefaults.set(data, forKey: cacheKey)
    }

    public func clearCache() {
        userDefaults.removeObject(forKey: cacheKey)
    }
}

