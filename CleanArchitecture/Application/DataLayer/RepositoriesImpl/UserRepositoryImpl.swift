//
//  UserRepositoryImpl.swift
//  CleanArchitecture
//
//  Created by Sophearath.chhan on 9/18/26.
//

import Foundation

public final class UserRepositoryImpl: UserRepositoryProtocol {
    private let remoteDataSource: UserRemoteDataSourceProtocol
    private let localDataSource: UserLocalDataSourceProtocol

    public init(
        remoteDataSource: UserRemoteDataSourceProtocol,
        localDataSource: UserLocalDataSourceProtocol
    ) {
        self.remoteDataSource = remoteDataSource
        self.localDataSource = localDataSource
    }

    public func getUser(id: Int) async throws -> User {
        do {
            let dto = try await remoteDataSource.fetchUser(id: id)
            try? localDataSource.saveUser(dto)
            guard let user = UserMapper.mapToDomain(dto) else {
                throw NetworkError.decodingError
            }
            return user
        } catch {
            if let cachedDTO = try? localDataSource.getCachedUser(id: id),
               let cachedUser = UserMapper.mapToDomain(cachedDTO) {
                return cachedUser
            }
            throw error
        }
    }
}
