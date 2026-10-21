//
//  Extension + Binding.swift
//  CleanArchitecture
//
//  Created by Sophearath.chhan on 10/21/26.
//

import SwiftUI

extension Binding {
    /// Creates a read-only boolean binding comparing a value to a target case.
    static func isCase<T: Equatable>(_ binding: Binding<T>, matching target: T) -> Binding<Bool> {
        Binding<Bool>(
            get: { binding.wrappedValue == target },
            set: { _ in }
        )
    }
    
}
