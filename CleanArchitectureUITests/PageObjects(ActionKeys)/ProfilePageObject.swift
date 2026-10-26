//
//  ProfilePageObject.swift
//  CleanArchitecture
//
//  Created by Sophearath.chhan on 9/19/26.
//

import XCTest
@testable import CleanArchitecture

struct ProfilePageObject {
    private let app: XCUIApplication

    init(app: XCUIApplication) {
        self.app = app
    }

    // MARK: - Queries
    var detailsList: XCUIElement {
        app.tables["profile_details_list"]
    }

    var loadingIndicator: XCUIElement {
        app.activityIndicators["profile_loading_view"]
    }

    var retryButton: XCUIElement {
        app.buttons["profile_retry_button"]
    }

    var nameLabel: XCUIElement {
        app.staticTexts["profile_name_text"]
    }

    var emailLabel: XCUIElement {
        app.staticTexts["profile_email_text"]
    }

    // MARK: - Actions & Assertions
    @discardableResult
    func waitForProfileToLoad(timeout: TimeInterval = 5) -> Bool {
        return detailsList.waitForExistence(timeout: timeout)
    }

    func tapRetry() {
        retryButton.tap()
    }
}
