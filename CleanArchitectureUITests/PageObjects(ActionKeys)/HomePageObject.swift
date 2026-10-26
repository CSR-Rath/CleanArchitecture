//
//  HomePageObject.swift
//  CleanArchitecture
//
//  Created by Sophearath.chhan on 9/18/26.
//

import XCTest
@testable import CleanArchitecture


final class HomePageObject: BasePageObject {
    // MARK: - Queries
    var feedList: XCUIElement {
        app.tables["home_feed_list"]
    }

    var loadingIndicator: XCUIElement {
        app.activityIndicators["home_loading_view"]
    }

    var retryButton: XCUIElement {
        app.buttons["home_retry_button"]
    }

    func postTitle(id: Int) -> XCUIElement {
        app.staticTexts["home_post_title_\(id)"]
    }

    // MARK: - Actions
    @discardableResult
    func waitForFeedToLoad(timeout: TimeInterval = 5) -> Bool {
        return waitForElement(feedList, timeout: timeout)
    }

    func tapRetry() {
        retryButton.tap()
    }
}
