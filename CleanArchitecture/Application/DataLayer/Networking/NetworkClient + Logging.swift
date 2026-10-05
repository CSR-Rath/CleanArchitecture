//
//  NetworkClient + Logging.swift
//  CleanArchitecture
//
//  Created by Sophearath.chhan on 9/22/26.
//

import Foundation

// MARK: - Logging Helpers
extension NetworkClient{
    
    func logRequest(_ request: URLRequest) {
        let method = request.httpMethod ?? "UNKNOWN"
        let url = request.url?.absoluteString ?? "Invalid URL"
        
        print("🚀 [REQUEST] \(method) -> \(url)")
        
        if let headers = request.allHTTPHeaderFields, !headers.isEmpty {
            print("   Headers: \(headers)")
        }
        
        if let body = request.httpBody, let formattedBody = prettyPrintJSON(body) {
            print("   Body:\n\(formattedBody)")
        }
    }
    
    func logResponse(_ response: HTTPURLResponse, data: Data) {
        let statusCode = response.statusCode
        let url = response.url?.absoluteString ?? "Invalid URL"
        let symbol = (200...299).contains(statusCode) ? "📥" : "⚠️"
        
        print("\(symbol) [RESPONSE \(statusCode)] <- \(url)")
        
        if let formattedJSON = prettyPrintJSON(data) {
            print("   Response JSON:\n\(formattedJSON)")
        }
    }
    
    func prettyPrintJSON(_ data: Data) -> String? {
        guard let jsonObject = try? JSONSerialization.jsonObject(with: data, options: []),
              let prettyData = try? JSONSerialization.data(withJSONObject: jsonObject, options: [.prettyPrinted]),
              let prettyString = String(data: prettyData, encoding: .utf8) else {
            return String(data: data, encoding: .utf8)
        }
        return prettyString
    }
    
}
