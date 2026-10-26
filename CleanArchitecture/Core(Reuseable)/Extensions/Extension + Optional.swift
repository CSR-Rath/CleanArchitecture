//
//  Extension + Optional.swift
//  CleanArchitecture
//
//  Created by Sophearath.chhan on 10/22/26.
//

import Foundation

extension Optional where Wrapped == String {
    var isNilOrEmpty: Bool {
        self?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true
    }
}

extension Optional where Wrapped == Int {
    var isNilOrZero: Bool {
        self == nil || self == 0
    }
}

extension Optional where Wrapped == Double {
    var isNilOrZero: Bool {
        self == nil || self == 0
    }
}
