//
//  UserLocalDataSource.swift
//  CleanArchitecture
//
//  Created by Sophearath.chhan on 9/18/26.
//

import Foundation

public protocol UserLocalDataSourceProtocol {
    func getCachedUser(id: Int) throws -> UserDTO?
    func saveUser(_ user: UserDTO) throws
}

public final class UserLocalDataSource: UserLocalDataSourceProtocol {
    private let userDefaults: UserDefaults

    public init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }

    public func getCachedUser(id: Int) throws -> UserDTO? {
        guard let data = userDefaults.data(forKey: "cached_user_\(id)") else { return nil }
        return try JSONDecoder().decode(UserDTO.self, from: data)
    }

    public func saveUser(_ user: UserDTO) throws {
        guard let id = user.id else { return }
        let data = try JSONEncoder().encode(user)
        userDefaults.set(data, forKey: "cached_user_\(id)")
    }
}
