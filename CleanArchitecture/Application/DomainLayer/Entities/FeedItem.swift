//
//  FeedItem.swift
//  CleanArchitecture
//
//  Created by Sophearath.chhan on 9/18/26.
//

import Foundation

public struct FeedItem: Identifiable, Equatable {
    public let id: Int
    public let userId: Int
    public let title: String
    public let body: String

    public init(id: Int, userId: Int, title: String, body: String) {
        self.id = id
        self.userId = userId
        self.title = title
        self.body = body
    }
}
