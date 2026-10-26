//
//  AppRoot.swift
//  CleanArchitecture
//
//  Created by Sophearath.chhan on 10/26/26.
//

import SwiftUI
import Combine

enum AppRoot: String {
    case splash
    case login
    case main
}

@MainActor
final class AppState: ObservableObject {
    private let rootKey = "app_root"

    @Published private(set) var root: AppRoot

    init() {
        let savedRoot = UserDefaults.standard.string(forKey: rootKey)
        root = savedRoot.flatMap(AppRoot.init(rawValue:)) ?? .splash
    }

    func setRoot(_ newRoot: AppRoot) {
        guard root != newRoot else { return }

        withAnimation(.easeInOut) {
            root = newRoot
        }

        UserDefaults.standard.set(newRoot.rawValue, forKey: rootKey)
    }
}
