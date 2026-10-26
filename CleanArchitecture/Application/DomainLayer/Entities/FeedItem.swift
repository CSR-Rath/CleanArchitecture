//
//  FeedItem.swift
//  CleanArchitecture
//
//  Created by Sophearath.chhan on 9/18/26.
//

import Foundation

struct FeedItem: Identifiable, Equatable {
    let id: Int
    let userId: Int
    let title: String
    let body: String

    init(id: Int, userId: Int, title: String, body: String) {
        self.id = id
        self.userId = userId
        self.title = title
        self.body = body
    }
}
