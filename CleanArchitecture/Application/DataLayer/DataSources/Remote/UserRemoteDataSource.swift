//
//  UserRemoteDataSource.swift
//  CleanArchitecture
//
//  Created by Sophearath.chhan on 9/18/26.
//

import Foundation

public protocol UserRemoteDataSourceProtocol {
    func fetchUser(id: Int) async throws -> UserDTO
}

public final class UserRemoteDataSource: UserRemoteDataSourceProtocol {
    private let networkClient: NetworkClientProtocol

    public init(networkClient: NetworkClientProtocol) {
        self.networkClient = networkClient
    }

    public func fetchUser(id: Int) async throws -> UserDTO {
        let request = try APIRequestBuilder.makeRequest(path: "/users/\(id)")
        return try await networkClient.request(request)
    }
}
