//
//  AccessibilityID.swift
//  CleanArchitecture
//
//  Created by Sophearath.chhan on 9/19/26.
//

import Foundation

public enum AccessibilityID {
    public enum Home {
        public static let loadingView = "home_loading_view"
        public static let errorText = "home_error_text"
        public static let retryButton = "home_retry_button"
        public static let feedList = "home_feed_list"
        
        public static func postTitle(id: Int) -> String {
            return "home_post_title_\(id)"
        }
    }

    public enum Profile {
        public static let loadingView = "profile_loading_view"
        public static let errorText = "profile_error_text"
        public static let retryButton = "profile_retry_button"
        public static let detailsList = "profile_details_list"
        public static let nameText = "profile_name_text"
        public static let emailText = "profile_email_text"
    }

    public enum Login {
        public static let emailTextField = "login_email_text_field"
        public static let passwordTextField = "login_password_text_field"
        public static let loginButton = "login_button"
    }
}
