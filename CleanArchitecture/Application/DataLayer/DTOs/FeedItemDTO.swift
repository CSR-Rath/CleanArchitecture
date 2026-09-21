//
//  FeedItemDTO.swift
//  CleanArchitecture
//
//  Created by Sophearath.chhan on 9/18/26.
//

import Foundation

public struct FeedItemDTO: Codable {
    public let id: Int?
    public let userId: Int?
    public let title: String?
    public let body: String?
}
