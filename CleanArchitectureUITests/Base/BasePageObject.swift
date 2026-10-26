//
//  BasePageObject.swift
//  CleanArchitecture
//
//  Created by Sophearath.chhan on 9/19/26.
//

import XCTest

open class BasePageObject {
    let app: XCUIApplication

    init(app: XCUIApplication) {
        self.app = app
    }
    
    // Shared helper for waiting on any XCUIElement across Page Objects
    @discardableResult
    func waitForElement(_ element: XCUIElement, timeout: TimeInterval = 5) -> Bool {
        return element.waitForExistence(timeout: timeout)
    }
}
