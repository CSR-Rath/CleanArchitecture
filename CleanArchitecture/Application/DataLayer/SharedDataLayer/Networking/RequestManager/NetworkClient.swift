//
//  NetworkClient.swift
//  CleanArchitecture
//
//  Created by Sophearath.chhan on 9/18/26.
//

import Foundation

protocol NetworkClientProtocol {
    func request<T: Decodable>(_ urlRequest: URLRequest) async throws -> T
}

final class NetworkClient: NetworkClientProtocol {
    private let session: URLSession

    init(session: URLSession = .shared) {
        self.session = session
    }

    func request<T: Decodable>(_ urlRequest: URLRequest) async throws -> T {

        LoggingAPIManager.logRequest(urlRequest)

        do {
            let (data, response) = try await session.data(for: urlRequest)

            guard let httpResponse = response as? HTTPURLResponse else {
                debugLog("❌ Invalid response type for: \(urlRequest.url?.absoluteString ?? "")")
                throw NetworkError.invalidResponse
            }

            LoggingAPIManager.logResponse(httpResponse, data: data)

            guard (200...299).contains(httpResponse.statusCode) else {
                debugLog("❌ HTTP Error [\(httpResponse.statusCode)] for: \(urlRequest.url?.absoluteString ?? "")")
                throw NetworkError.httpError(statusCode: httpResponse.statusCode)
            }

            do {
                let decodedObject = try JSONDecoder().decode(T.self, from: data)
                debugLog("✅ Successfully decoded \(String(describing: T.self))")
              
                return decodedObject
            } catch {
                debugLog("❌ Decoding Error for \(String(describing: T.self)): \(error.localizedDescription)")
                throw NetworkError.decodingError
            }
            
        } catch let error as NetworkError {
            throw error
        } catch {
            debugLog("""
            ❌ Network Request Failed
               URL: \(urlRequest.url?.absoluteString ?? "Unknown")
               Error: \(error.localizedDescription)
            """)
            throw error
        }
    }
}

func debugLog( _ items: Any..., separator: String = " ",terminator: String = "\n") {
    #if DEBUG
    Swift.print(items.map { String(describing: $0) }.joined(separator: separator),terminator: terminator)
    #endif
}
