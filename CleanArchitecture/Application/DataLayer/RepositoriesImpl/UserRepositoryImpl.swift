//
//  UserRepositoryImpl.swift
//  CleanArchitecture
//
//  Created by Sophearath.chhan on 9/18/26.
//

import Foundation

final class UserRepositoryImpl: UserRepositoryProtocol {
    private let remoteDataSource: UserRemoteDataSourceProtocol
    private let localDataSource: UserLocalDataSourceProtocol

    init(
        remoteDataSource: UserRemoteDataSourceProtocol,
        localDataSource: UserLocalDataSourceProtocol
    ) {
        self.remoteDataSource = remoteDataSource
        self.localDataSource = localDataSource
    }

    func getUser(id: Int) async throws -> User {
        do {
            let dto = try await remoteDataSource.fetchUser(id: id)
            try? localDataSource.saveUser(dto)
            return UserMapper.mapToDomain(dto) ?? User(id: 1, name: "", email: "")
        } catch {
            if let cachedDTO = try? localDataSource.getCachedUser(id: id),
               let cachedUser = UserMapper.mapToDomain(cachedDTO) {
                return cachedUser
            }
            throw error
        }
    }
}
