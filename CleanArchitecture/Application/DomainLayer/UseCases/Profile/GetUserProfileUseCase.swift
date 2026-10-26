//
//  GetUserProfileUseCase.swift
//  CleanArchitecture
//
//  Created by Sophearath.chhan on 9/18/26.
//

import Foundation

protocol GetUserProfileUseCaseProtocol {
    func execute(userId: Int) async throws -> User
}

final class GetUserProfileUseCase: GetUserProfileUseCaseProtocol {
    private let repository: UserRepositoryProtocol

    init(repository: UserRepositoryProtocol) {
        self.repository = repository
    }

    func execute(userId: Int) async throws -> User {
        return try await repository.getUser(id: userId)
    }
}
