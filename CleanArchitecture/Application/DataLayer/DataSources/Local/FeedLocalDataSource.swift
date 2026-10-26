//
//  FeedLocalDataSource.swift
//  CleanArchitecture
//
//  Created by Sophearath.chhan on 9/18/26.
//

import Foundation

protocol FeedLocalDataSourceProtocol {
    func getCachedPosts() throws -> [FeedItemDTO]
    func savePosts(_ posts: [FeedItemDTO]) throws
    func clearCache()
}

final class FeedLocalDataSource: FeedLocalDataSourceProtocol {
    private let userDefaults: UserDefaults
    private let cacheKey = "cached_feed_posts"

    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }

    func getCachedPosts() throws -> [FeedItemDTO] {
        guard let data = userDefaults.data(forKey: cacheKey) else { return [] }
        return try JSONDecoder().decode([FeedItemDTO].self, from: data)
    }

    func savePosts(_ posts: [FeedItemDTO]) throws {
        let data = try JSONEncoder().encode(posts)
        userDefaults.set(data, forKey: cacheKey)
    }

    func clearCache() {
        userDefaults.removeObject(forKey: cacheKey)
    }
}

