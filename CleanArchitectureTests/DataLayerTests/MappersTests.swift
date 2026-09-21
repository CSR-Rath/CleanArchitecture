//
//  MappersTests.swift
//  CleanArchitecture
//
//  Created by Sophearath.chhan on 9/18/26.
//

import XCTest
@testable import CleanArchitecture

final class MappersTests: XCTestCase {
    func testFeedMapperWithValidDTO() {
        let dto = FeedItemDTO(id: 1, userId: 1, title: "Title", body: "Body")
        let entity = FeedMapper.mapToDomain(dto)

        XCTAssertNotNil(entity)
        XCTAssertEqual(entity?.id, 1)
        XCTAssertEqual(entity?.title, "Title")
    }

    func testFeedMapperWithMissingIdReturnsNil() {
        let dto = FeedItemDTO(id: nil, userId: 1, title: "Title", body: "Body")
        let entity = FeedMapper.mapToDomain(dto)

        XCTAssertNil(entity)
    }
}
