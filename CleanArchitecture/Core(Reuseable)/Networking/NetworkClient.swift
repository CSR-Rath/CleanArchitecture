//
//  NetworkClient.swift
//  CleanArchitecture
//
//  Created by Sophearath.chhan on 9/18/26.
//

import Foundation
import os

public protocol NetworkClientProtocol {
    func request<T: Decodable>(_ urlRequest: URLRequest) async throws -> T
}

public final class NetworkClient: NetworkClientProtocol {
    private let session: URLSession
    private let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "App", category: "Networking")

    public init(session: URLSession = .shared) {
        self.session = session
    }

    public func request<T: Decodable>(_ urlRequest: URLRequest) async throws -> T {
        logRequest(urlRequest)

        do {
            let (data, response) = try await session.data(for: urlRequest)

            guard let httpResponse = response as? HTTPURLResponse else {
                logger.error("❌ Invalid response type for: \(urlRequest.url?.absoluteString ?? "")")
                throw NetworkError.invalidResponse
            }

            logResponse(httpResponse, data: data)

            guard (200...299).contains(httpResponse.statusCode) else {
                logger.error("❌ HTTP Error [\(httpResponse.statusCode)] for: \(urlRequest.url?.absoluteString ?? "")")
                throw NetworkError.httpError(statusCode: httpResponse.statusCode)
            }

            do {
                let decodedObject = try JSONDecoder().decode(T.self, from: data)
                logger.debug("✅ Successfully decoded \(String(describing: T.self))")
                return decodedObject
            } catch {
                logger.error("❌ Decoding Error for \(String(describing: T.self)): \(error.localizedDescription)")
                throw NetworkError.decodingError
            }
        } catch let error as NetworkError {
            throw error
        } catch {
            logger.error("❌ Network Request Failed: \(error.localizedDescription)")
            throw error
        }
    }

    // MARK: - Logging Helpers

    private func logRequest(_ request: URLRequest) {
        let method = request.httpMethod ?? "UNKNOWN"
        let url = request.url?.absoluteString ?? "Invalid URL"

        logger.info("🚀 [REQUEST] \(method) -> \(url)")

        if let headers = request.allHTTPHeaderFields, !headers.isEmpty {
            logger.debug("   Headers: \(headers)")
        }

        if let body = request.httpBody, let formattedBody = prettyPrintJSON(body) {
            logger.debug("   Body:\n\(formattedBody)")
        }
    }

    private func logResponse(_ response: HTTPURLResponse, data: Data) {
        let statusCode = response.statusCode
        let url = response.url?.absoluteString ?? "Invalid URL"
        let symbol = (200...299).contains(statusCode) ? "📥" : "⚠️"

        logger.info("\(symbol) [RESPONSE \(statusCode)] <- \(url)")

        if let formattedJSON = prettyPrintJSON(data) {
            logger.debug("   Response JSON:\n\(formattedJSON)")
        }
    }

    private func prettyPrintJSON(_ data: Data) -> String? {
        guard let jsonObject = try? JSONSerialization.jsonObject(with: data, options: []),
              let prettyData = try? JSONSerialization.data(withJSONObject: jsonObject, options: [.prettyPrinted]),
              let prettyString = String(data: prettyData, encoding: .utf8) else {
            return String(data: data, encoding: .utf8)
        }
        return prettyString
    }
}
