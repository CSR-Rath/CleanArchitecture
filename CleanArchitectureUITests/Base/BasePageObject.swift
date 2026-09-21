//
//  BasePageObject.swift
//  CleanArchitecture
//
//  Created by Sophearath.chhan on 9/19/26.
//

import XCTest

open class BasePageObject {
    public let app: XCUIApplication

    public init(app: XCUIApplication) {
        self.app = app
    }
    
    // Shared helper for waiting on any XCUIElement across Page Objects
    @discardableResult
    public func waitForElement(_ element: XCUIElement, timeout: TimeInterval = 5) -> Bool {
        return element.waitForExistence(timeout: timeout)
    }
}
