//
//  User.swift
//  CleanArchitecture
//
//  Created by Sophearath.chhan on 9/18/26.
//

import Foundation

public struct User: Identifiable, Equatable {
    public let id: Int
    public let name: String
    public let email: String

    public init(id: Int, name: String, email: String) {
        self.id = id
        self.name = name
        self.email = email
    }
}
