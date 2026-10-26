//
//  UserLocalDataSource.swift
//  CleanArchitecture
//
//  Created by Sophearath.chhan on 9/18/26.
//

import Foundation

protocol UserLocalDataSourceProtocol {
    func getCachedUser(id: Int) throws -> UserDTO?
    func saveUser(_ user: UserDTO) throws
}

final class UserLocalDataSource: UserLocalDataSourceProtocol {
    private let userDefaults: UserDefaults

    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }

    func getCachedUser(id: Int) throws -> UserDTO? {
        guard let data = userDefaults.data(forKey: "cached_user_\(id)") else { return nil }
        return try JSONDecoder().decode(UserDTO.self, from: data)
    }

    func saveUser(_ user: UserDTO) throws {
        guard let id = user.id else { return }
        let data = try JSONEncoder().encode(user)
        userDefaults.set(data, forKey: "cached_user_\(id)")
    }
}
