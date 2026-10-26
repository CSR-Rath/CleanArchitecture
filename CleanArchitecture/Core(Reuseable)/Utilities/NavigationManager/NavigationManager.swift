//
//  NavigationManager.swift
//  CleanArchitecture
//
//  Created by Sophearath.chhan on 10/21/26.
//

import SwiftUI
import Combine

@MainActor
final class NavigationManager: ObservableObject {
    @Published var path = NavigationPath()

    func push(_ route: AppRoute) {
        path.append(route)
    }

    func pop() {
        guard !path.isEmpty else { return }
        path.removeLast()
    }

    func pop(_ count: Int) {
        guard count > 0, !path.isEmpty else { return }
        path.removeLast(min(count, path.count))
    }

    func popToRoot() {
        guard !path.isEmpty else { return }
        path = NavigationPath()
    }
}

