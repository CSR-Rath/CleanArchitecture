//
//  APIEndpoint.swift
//  CleanArchitecture
//
//  Created by Sophearath.chhan on 9/21/26.
//

import Foundation

public enum APIEndpoint {
    case posts
    case users(id: String)

    var path: String {
        switch self {
        case .posts:
            return "/posts"
        case .users(let id):
            return "/users/\(id)"
        }
    }
}
