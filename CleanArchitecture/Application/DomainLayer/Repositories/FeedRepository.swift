//
//  FeedRepository.swift
//  CleanArchitecture
//
//  Created by Sophearath.chhan on 9/18/26.
//

import Foundation

public protocol FeedRepositoryProtocol {
    func getFeed() async throws -> [FeedItem]
}
