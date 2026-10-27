//
//  NetworkError.swift
//  CleanArchitecture
//
//  Created by Sophearath.chhan on 10/27/26.
//

import Foundation

enum NetworkError: Error, Equatable {
    case noInternet
    case invalidURL
    case invalidResponse
    case invalidRequestBody
    case httpError(statusCode: Int)
    case decodingError
}

extension NetworkError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid request URL."
        case .invalidResponse:
            return "Invalid response from server."
        case .invalidRequestBody:
            return "Failed to construct or encode the request body."
        case .httpError(let statusCode):
            return Self.message(forHTTPStatus: statusCode)
        case .decodingError:
            return "Failed to process data from server."
        case .noInternet:
            return "No internet connection. Please check your network."
        }
    }

    private static func message(forHTTPStatus statusCode: Int) -> String {
        switch statusCode {
        case 400: return "Bad Request (400). Please check your input."
        case 401: return "Session expired (401). Please log in again."
        case 403: return "You do not have permission to perform this action (403)."
        case 404: return "Requested resource not found (404)."
        case 500...599: return "Server error (\(statusCode)). Please try again later."
        default: return "HTTP Error: Status code \(statusCode)."
        }
    }
}

extension Error {
    /// A user-facing message for any error.
    var userMessage: String {
        if let networkError = self as? NetworkError {
            return networkError.errorDescription ?? localizedDescription
        }

        if let urlError = self as? URLError {
            switch urlError.code {
            case .notConnectedToInternet:
                return "No internet connection. Please check your network."
            case .timedOut:
                return "The connection timed out. Please try again."
            default:
                return urlError.localizedDescription
            }
        }

        if self is DecodingError {
            return "Data formatting error occurred."
        }

        return localizedDescription
    }
}
