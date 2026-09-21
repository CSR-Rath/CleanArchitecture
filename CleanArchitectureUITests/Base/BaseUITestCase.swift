//
//  BaseUITestCase.swift
//  CleanArchitecture
//
//  Created by Sophearath.chhan on 9/19/26.
//

import XCTest

open class BaseUITestCase: XCTestCase {
    public var app: XCUIApplication!

    override open func setUp() {
        super.setUp()
        
        // Stops execution immediately when a failure occurs to save test run time
        continueAfterFailure = false
        
        app = XCUIApplication()
        
        // Pass launch arguments or environment variables if needed for mocking/testing
        app.launchArguments += ["-UI_TESTING"]
        
        app.launch()
    }

    override open func tearDown() {
        app = nil
        super.tearDown()
    }
}
