//
//  UserRepository.swift
//  CleanArchitecture
//
//  Created by Sophearath.chhan on 9/18/26.
//

import Foundation

protocol UserRepositoryProtocol {
    func getUser(id: Int) async throws -> User
}
