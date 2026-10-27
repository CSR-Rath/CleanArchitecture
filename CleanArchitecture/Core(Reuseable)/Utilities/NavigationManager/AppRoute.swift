//
//  Route.swift
//  CleanArchitecture
//
//  Created by Sophearath.chhan on 10/26/26.
//

import Foundation

enum AppRoute: Hashable {
    case detail(id: Int)
    case profile(userID: String)
    case orders
    case settings
    case tabBar
}
