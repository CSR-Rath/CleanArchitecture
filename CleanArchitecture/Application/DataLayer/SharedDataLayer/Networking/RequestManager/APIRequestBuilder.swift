//
//  APIRequestBuilder.swift
//  CleanArchitecture
//
//  Created by Sophearath.chhan on 9/18/26.
//

import Foundation

struct APIRequestBuilder {
    private static let baseURL = "https://jsonplaceholder.typicode.com"

    static func makeRequest(
        path: APIEndpoint,
        method: HTTPMethod = .get,
        query: QueryParameters? = nil,
        body: HTTPBody? = nil
    ) throws -> URLRequest {
        guard var components = URLComponents(string: baseURL + path.path) else {
            throw NetworkError.invalidURL
        }

        // Query parameters
        if let query {
            components.queryItems = query.map {
                URLQueryItem(name: $0.key, value: $0.value)
            }
        }

        guard let url = components.url else {
            throw NetworkError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue

        if let body = body {
            let (data, contentType) = try body.encode()
            request.httpBody = data
            request.setValue(contentType, forHTTPHeaderField: "Content-Type")
        }

        return request
    }
}
