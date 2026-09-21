//
//  HomePageObject.swift
//  CleanArchitecture
//
//  Created by Sophearath.chhan on 9/18/26.
//

import XCTest
@testable import CleanArchitecture


public final class HomePageObject: BasePageObject {
    // MARK: - Queries
    public var feedList: XCUIElement {
        app.tables["home_feed_list"]
    }

    public var loadingIndicator: XCUIElement {
        app.activityIndicators["home_loading_view"]
    }

    public var retryButton: XCUIElement {
        app.buttons["home_retry_button"]
    }

    public func postTitle(id: Int) -> XCUIElement {
        app.staticTexts["home_post_title_\(id)"]
    }

    // MARK: - Actions
    @discardableResult
    public func waitForFeedToLoad(timeout: TimeInterval = 5) -> Bool {
        return waitForElement(feedList, timeout: timeout)
    }

    public func tapRetry() {
        retryButton.tap()
    }
}
