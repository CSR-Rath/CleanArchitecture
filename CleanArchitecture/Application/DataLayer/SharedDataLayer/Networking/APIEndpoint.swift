//
//  APIEndpoint.swift
//  CleanArchitecture
//
//  Created by Sophearath.chhan on 10/27/26.
//

import Foundation

//API = Application Programming Interface

enum APIEndpoint {
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
