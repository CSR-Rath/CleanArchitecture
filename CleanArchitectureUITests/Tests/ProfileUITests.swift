//
//  ProfileUITests.swift
//  CleanArchitecture
//
//  Created by Sophearath.chhan on 9/19/26.
//


import XCTest

final class ProfileUITests: BaseUITestCase {

    func testProfileDetailsDisplaySuccessfully() {
        // Navigate to Profile Tab if needed (e.g., app.tabBars.buttons["Profile"].tap())
        let profilePage = ProfilePageObject(app: app)

//        XCTAssertTrue(
//            profilePage.waitForProfileToLoad(timeout: 5),
//            "Expected profile details list to appear within 5 seconds"
//        )

        XCTAssertTrue(
            profilePage.nameLabel.exists,
            "Expected profile name label to be visible"
        )
        
        XCTAssertTrue(
            profilePage.emailLabel.exists,
            "Expected profile email label to be visible"
        )
    }
}
