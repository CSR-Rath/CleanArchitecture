//
//  FeedMapper.swift
//  CleanArchitecture
//
//  Created by Sophearath.chhan on 9/18/26.
//

import Foundation

public enum FeedMapper {
    public static func mapToDomain(_ dto: FeedItemDTO) -> FeedItem? {
        guard let id = dto.id else { return nil }

        return FeedItem(
            id: id,
            userId: dto.userId ?? 0,
            title: dto.title ?? "Untitled",
            body: dto.body ?? ""
        )
    }
}
