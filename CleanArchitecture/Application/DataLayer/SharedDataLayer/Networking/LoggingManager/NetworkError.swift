//
//  NetworkError.swift
//  CleanArchitecture
//
//  Created by Sophearath.chhan on 9/18/26.
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
