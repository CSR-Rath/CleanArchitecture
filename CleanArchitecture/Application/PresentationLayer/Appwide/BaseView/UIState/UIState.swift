//
//  UIState.swift
//  CleanArchitecture
//
//  Created by Sophearath.chhan on 10/8/26.
//

import Foundation

// MARK: - UIState Enum
enum UIState: Equatable {
    case idle
    case loading
    case shimmerLoading
    case isScanQRCode
    case isTransaction(vm: Any? = nil)
    case info(message: String, leftBtn: ButtonInfo? = nil, rightBtn: ButtonInfo)
    case failed(message: String)
    case failedAction(message: String, leftBtn: ButtonInfo? = nil, rightBtn: ButtonInfo)

    static func == (lhs: UIState, rhs: UIState) -> Bool {
        switch (lhs, rhs) {
        case (.idle, .idle),
             (.loading, .loading),
             (.shimmerLoading, .shimmerLoading),
             (.isScanQRCode, .isScanQRCode),
             (.isTransaction, .isTransaction):
            return true
        case (.info(let m1, let l1, let r1), .info(let m2, let l2, let r2)):
            return m1 == m2 && l1 == l2 && r1 == r2
        case (.failed(let m1), .failed(let m2)):
            return m1 == m2
        case (.failedAction(let m1, let l1, let r1), .failedAction(let m2, let l2, let r2)):
            return m1 == m2 && l1 == l2 && r1 == r2
        default:
            return false
        }
    }
}

// MARK: - Convenience
extension UIState {
    /// Build a failed state straight from any Error.
    static func failed(_ error: Error) -> UIState {
        .failed(message: error.userMessage)
    }

    static func failedAction(error: Error, leftBtn: ButtonInfo? = nil, rightBtn: ButtonInfo) -> UIState {
        .failedAction(message: error.userMessage, leftBtn: leftBtn, rightBtn: rightBtn)
    }
}

// MARK: - Button Info Model
struct ButtonInfo: Equatable {
    let title: String
    let action: (() -> Void)?

    init(title: String, action: (() -> Void)? = nil) {
        self.title = title
        self.action = action
    }

    static func == (lhs: ButtonInfo, rhs: ButtonInfo) -> Bool {
        lhs.title == rhs.title
    }
}
