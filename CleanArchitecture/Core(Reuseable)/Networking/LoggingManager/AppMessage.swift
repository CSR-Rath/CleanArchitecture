//
//  AppMessage.swift
//  CleanArchitecture
//
//  Created by Sophearath.chhan on 10/8/26.
//

public struct AppMessage: Error, Equatable {
    public let message: String
    
    public init(message: String) {
        self.message = message
    }
    
    public static func appError(reason: AppReason) -> AppMessage {
        switch reason {
        case .unownedError(let message):
            return AppMessage(message: message)
        }
    }
}

public enum AppReason {
    case unownedError(message: String)
}
