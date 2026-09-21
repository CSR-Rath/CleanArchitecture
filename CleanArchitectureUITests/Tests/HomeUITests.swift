//
//  HomeUITests.swift
//  CleanArchitecture
//
//  Created by Sophearath.chhan on 9/18/26.
//

import XCTest

final class HomeUITests: BaseUITestCase {

    func testFeedDisplaysSuccessfully() {
        let homePage = HomePageObject(app: app)

//        XCTAssertTrue(
//            homePage.waitForFeedToLoad(timeout: 5),
//            "Expected feed list to appear within 5 seconds"
//        )

        XCTAssertTrue(
            homePage.postTitle(id: 1).exists,
            "Expected post title with ID 1 to be visible"
        )
    }
}
