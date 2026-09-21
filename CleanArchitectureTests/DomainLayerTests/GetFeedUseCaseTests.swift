//
//  GetFeedUseCaseTests.swift
//  CleanArchitecture
//
//  Created by Sophearath.chhan on 9/18/26.
//

import XCTest
@testable import CleanArchitecture

final class MockFeedRepository: FeedRepositoryProtocol {
    var resultToReturn: Result<[FeedItem], Error> = .success([])
    private(set) var getFeedCallCount = 0

    func getFeed() async throws -> [FeedItem] {
        getFeedCallCount += 1
        return try resultToReturn.get()
    }
}

@MainActor
final class GetFeedUseCaseTests: XCTestCase {

    func testExecuteSuccessReturnsItems() async throws {
        // Given (Arrange)
        let mockRepository = MockFeedRepository()
        let expectedItems = [FeedItem(id: 1, userId: 1, title: "Test", body: "Body")]
        mockRepository.resultToReturn = .success(expectedItems)

        let useCase = GetFeedUseCase(repository: mockRepository)

        // When (Act)
        let items = try await useCase.execute()

        // Then (Assert)
        XCTAssertEqual(mockRepository.getFeedCallCount, 1)
        XCTAssertEqual(items, expectedItems)
    }

    func testExecuteFailureThrowsError() async {
        // Given (Arrange)
        let mockRepository = MockFeedRepository()
        mockRepository.resultToReturn = .failure(URLError(.badServerResponse))
        let useCase = GetFeedUseCase(repository: mockRepository)

        // When / Then (Act / Assert)
        do {
            _ = try await useCase.execute()
            XCTFail("Expected execute() to throw, but it succeeded")
        } catch {
            XCTAssertEqual(mockRepository.getFeedCallCount, 1)
        }
    }
}

//
//final class MockFeedRepository: FeedRepositoryProtocol {
//    var resultToReturn: Result<[FeedItem], Error> = .success([])
//
//    func getFeed() async throws -> [FeedItem] {
//        try resultToReturn.get()
//    }
//}
//
//
//@MainActor
//final class GetFeedUseCaseTests: XCTestCase {
//
//    func testExecuteSuccessReturnsItems() async throws {
//        let mockRepository = MockFeedRepository()
////        mockRepository.resultToReturn =  .failure(NetworkError.invalidResponse)
//        
//        let expectedItems = [FeedItem(id: 1, userId: 1, title: "Test", body: "Body")]
//        mockRepository.resultToReturn = .success(expectedItems)
//
//        let useCase = GetFeedUseCase(repository: mockRepository)
//        let items = try await useCase.execute()
//
//        print("🧪 items: \(items)")
//
//
//        XCTAssertEqual(items.count, 1)
//        XCTAssertEqual(items.first?.title, "Test")
//    }
//}


//@MainActor
//final class GetFeedUseCaseTests: XCTestCase {
//    
//    
//    func testExecuteSuccessReturnsItems() async throws {
//        let mockRepository = MockFeedRepository()
//        let expectedItems = [FeedItem(id: 1, userId: 1, title: "Test", body: "Body")]
//        mockRepository.resultToReturn = .success(expectedItems)
//
//        let useCase = GetFeedUseCase(repository: mockRepository)
//        let items = try await useCase.execute()
//
//        XCTAssertEqual(items.count, 1)
//        XCTAssertEqual(items.first?.title, "Test")
//    }
//    
//    
//    
//}
