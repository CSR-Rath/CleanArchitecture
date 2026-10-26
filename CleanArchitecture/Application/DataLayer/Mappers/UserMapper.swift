//
//  UserMapper.swift
//  CleanArchitecture
//
//  Created by Sophearath.chhan on 9/18/26.
//

import Foundation

enum UserMapper {
    static func mapToDomain(_ dto: UserDTO) -> User? {
        guard let id = dto.id else { return nil }

        return User(
            id: id,
            name: dto.name ?? "Anonymous",
            email: dto.email ?? ""
        )
    }
}
