//
//  LoggingAPIManager.swift
//  CleanArchitecture
//
//  Created by Sophearath.chhan on 9/22/26.
//

import Foundation

// MARK: - Logging Helpers
enum LoggingAPIManager {
    
    static func logRequest(_ request: URLRequest) {
        let method = request.httpMethod ?? "UNKNOWN"
        let url = request.url?.absoluteString ?? "Invalid URL"
        
        debugLog("🚀 [REQUEST] \(method) -> \(url)")
        
        if let headers = request.allHTTPHeaderFields, !headers.isEmpty {
            let sanitizedHeaders = sanitizeHeaders(headers)
            debugLog("   Headers: \(sanitizedHeaders)")
        }
        
        if let body = request.httpBody, let formattedBody = prettyPrintJSON(body) {
            debugLog("   Body:\n\(formattedBody)")
        }
    }
    
    static func logResponse(_ response: HTTPURLResponse, data: Data) {
        let statusCode = response.statusCode
        let url = response.url?.absoluteString ?? "Invalid URL"
        let symbol = (200...299).contains(statusCode) ? "📥" : "⚠️"
        
        debugLog("\(symbol) [RESPONSE \(statusCode)] <- \(url)")
        
        if let formattedJSON = prettyPrintJSON(data) {
            debugLog("   Response JSON:\n\(formattedJSON)")
        }
    }
    
    // MARK: - Private Helpers
    
    /// Converted to `static` so it can be called from static logging methods.
    private static func prettyPrintJSON(_ data: Data) -> String? {
        guard let jsonObject = try? JSONSerialization.jsonObject(with: data, options: []),
              let prettyData = try? JSONSerialization.data(withJSONObject: jsonObject, options: [.prettyPrinted, .sortedKeys]),
              let prettyString = String(data: prettyData, encoding: .utf8) else {
            return String(data: data, encoding: .utf8)
        }
        return prettyString
    }
    
    /// Redacts sensitive headers to avoid leaking credentials in debug logs.
    private static func sanitizeHeaders(_ headers: [String: String]) -> [String: String] {
        let sensitiveKeys = ["authorization", "token", "x-api-key", "cookie"]
        var sanitized = headers
        
        for key in headers.keys {
            if sensitiveKeys.contains(key.lowercased()) {
                sanitized[key] = "[REDACTED]"
            }
        }
        return sanitized
    }
}
