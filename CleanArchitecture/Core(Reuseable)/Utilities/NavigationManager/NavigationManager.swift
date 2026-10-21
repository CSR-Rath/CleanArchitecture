//
//  NavigationManager.swift
//  CleanArchitecture
//
//  Created by Sophearath.chhan on 10/21/26.
//

import SwiftUI
import Combine

class NavigationManager: ObservableObject {
    // Using a strongly-typed array instead of NavigationPath
    @Published var path: [Destination] = []
    
    func push(_ destination: Destination) {
        path.append(destination)
    }
    
    /// Pops a specific number of screens
    func pop(_ count: Int = 1) {
        guard path.count >= count else {
            popToRoot()
            return
        }
        path.removeLast(count)
    }
    
    /// Safely pops back until it finds a specific destination type
    func popToBefore(_ destinationCase: DestinationCase) {
        if let index = path.firstIndex(where: { $0.caseType == destinationCase }) {
            path = Array(path[...index])
        }
    }
    
    func popToRoot() {
        path.removeAll()
    }
}

// Help helper types for explicit popping
enum DestinationCase {
    case details, profile, settings
}

enum Destination: Hashable {
    case details(productId: String)
    case profile(username: String)
    case settings
    
    // Map destinations back to their base type for easier matching
    var caseType: DestinationCase {
        switch self {
        case .details: return .details
        case .profile: return .profile
        case .settings: return .settings
        }
    }
}
