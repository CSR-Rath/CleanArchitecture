//
//  ProfilePageObject.swift
//  CleanArchitecture
//
//  Created by Sophearath.chhan on 9/19/26.
//

import XCTest
@testable import CleanArchitecture

public struct ProfilePageObject {
    private let app: XCUIApplication

    public init(app: XCUIApplication) {
        self.app = app
    }

    // MARK: - Queries
    public var detailsList: XCUIElement {
        app.tables["profile_details_list"]
    }

    public var loadingIndicator: XCUIElement {
        app.activityIndicators["profile_loading_view"]
    }

    public var retryButton: XCUIElement {
        app.buttons["profile_retry_button"]
    }

    public var nameLabel: XCUIElement {
        app.staticTexts["profile_name_text"]
    }

    public var emailLabel: XCUIElement {
        app.staticTexts["profile_email_text"]
    }

    // MARK: - Actions & Assertions
    @discardableResult
    public func waitForProfileToLoad(timeout: TimeInterval = 5) -> Bool {
        return detailsList.waitForExistence(timeout: timeout)
    }

    public func tapRetry() {
        retryButton.tap()
    }
}
