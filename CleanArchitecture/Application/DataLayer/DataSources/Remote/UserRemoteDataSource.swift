//
//  UserRemoteDataSource.swift
//  CleanArchitecture
//
//  Created by Sophearath.chhan on 9/18/26.
//

import Foundation

protocol UserRemoteDataSourceProtocol {
    func fetchUser(id: Int) async throws -> UserDTO
}

final class UserRemoteDataSource: UserRemoteDataSourceProtocol {
    private let networkClient: NetworkClientProtocol

    init(networkClient: NetworkClientProtocol) {
        self.networkClient = networkClient
    }

    func fetchUser(id: Int) async throws -> UserDTO {
        let request = try BuildRequest.makeRequest(path: .users(id: "\(id)"))
        return try await networkClient.request(request)
    }
}
