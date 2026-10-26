//
//  AppMessage.swift
//  CleanArchitecture
//
//  Created by Sophearath.chhan on 10/8/26.
//

struct AppMessage: Error, Equatable {
    let message: String
    
    init(message: String) {
        self.message = message
    }
    
    static func appError(reason: AppReason) -> AppMessage {
        switch reason {
        case .unownedError(let message):
            return AppMessage(message: message)
        }
    }
}

enum AppReason {
    case unownedError(message: String)
}
