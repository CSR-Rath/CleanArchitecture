//
//  GetUserProfileUseCase.swift
//  CleanArchitecture
//
//  Created by Sophearath.chhan on 9/18/26.
//

import Foundation

public protocol GetUserProfileUseCaseProtocol {
    func execute(userId: Int) async throws -> User
}

public final class GetUserProfileUseCase: GetUserProfileUseCaseProtocol {
    private let repository: UserRepositoryProtocol

    public init(repository: UserRepositoryProtocol) {
        self.repository = repository
    }

    public func execute(userId: Int) async throws -> User {
        return try await repository.getUser(id: userId)
    }
}
