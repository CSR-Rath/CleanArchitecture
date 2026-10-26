//
//  Extension + Error.swift
//  CleanArchitecture
//
//  Created by Sophearath.chhan on 10/8/26.
//

import Foundation

// MARK: - Error Extension for Automatic Conversion
extension Error {
    var asError: AppMessage {
        if let mbError = self as? AppMessage {
            return mbError
        }

        if let networkError = self as? NetworkError {
            switch networkError {
            case .invalidURL:
                return AppMessage.appError(reason: .unownedError(message: "Invalid request URL."))
            case .invalidResponse:
                return AppMessage.appError(reason: .unownedError(message: "Invalid response from server."))
            case .invalidRequestBody:
                return AppMessage.appError(reason: .unownedError(message: "Failed to construct or encode the request body."))
            case .httpError(let statusCode):
                return AppMessage.appError(reason: .unownedError(message: messageForHTTPStatus(statusCode)))
            case .decodingError:
                return AppMessage.appError(reason: .unownedError(message: "Failed to process data from server."))
            case .noInternet:
                return AppMessage.appError(reason: .unownedError(message: "No internet connection. Please check your network."))
            }
        }

        if let urlError = self as? URLError {
            switch urlError.code {
            case .notConnectedToInternet:
                return AppMessage.appError(reason: .unownedError(message: "No internet connection. Please check your network."))
            case .timedOut:
                return AppMessage.appError(reason: .unownedError(message: "The connection timed out. Please try again."))
            default:
                return AppMessage.appError(reason: .unownedError(message: urlError.localizedDescription))
            }
        }

        if self is DecodingError {
            return AppMessage.appError(reason: .unownedError(message: "Data formatting error occurred."))
        }

        return AppMessage.appError(reason: .unownedError(message: localizedDescription))
    }

    private func messageForHTTPStatus(_ statusCode: Int) -> String {
        switch statusCode {
        case 400:
            return "Bad Request (400). Please check your input."
        case 401:
            return "Session expired (401). Please log in again."
        case 403:
            return "You do not have permission to perform this action (403)."
        case 404:
            return "Requested resource not found (404)."
        case 500...599:
            return "Server error (\(statusCode)). Please try again later."
        default:
            return "HTTP Error: Status code \(statusCode)."
        }
    }
}
