//
//  UIState.swift
//  CleanArchitecture
//
//  Created by Sophearath.chhan on 10/8/26.
//

// MARK: - UIState Enum
enum UIState: Equatable {
    case idle
    case loading
    case shimmerLoading
    case isScanQRCode
    case isTransaction(vm: Any? = nil)
    case info(AppMessage, leftBtn: ButtonInfo? = nil , rightBtn: ButtonInfo)
    case failed(AppMessage)
    case failedAction(error: AppMessage, leftBtn: ButtonInfo? = nil, rightBtn: ButtonInfo)
    
    static func == (lhs: UIState, rhs: UIState) -> Bool {
        switch (lhs, rhs) {
        case (.idle, .idle), (.loading, .loading), (.shimmerLoading, .shimmerLoading), (.isScanQRCode, .isScanQRCode):
            return true
        case (.isTransaction, .isTransaction):
            return true
        case (.info(let e1, let l1, let r1), .info(let e2, let l2, let r2)):
            return e1 == e2 && l1 == l2 && r1 == r2
        case (.failed(let e1), .failed(let e2)):
            return e1 == e2
        case (.failedAction(let e1, let l1, let r1), .failedAction(let e2, let l2, let r2)):
            return e1 == e2 && l1 == l2 && r1 == r2
        default:
            return false
        }
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
        return lhs.title == rhs.title
    }
}
