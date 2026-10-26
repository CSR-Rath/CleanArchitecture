//
//  Toast.swift
//  CleanArchitecture
//
//  Created by Sophearath.chhan on 10/22/26.
//

import SwiftUI

// MARK: - Model

struct Toast: Equatable {
    enum Style {
        case info, success, warning, error

        var icon: String {
            switch self {
            case .info: return "info.circle.fill"
            case .success: return "checkmark.circle.fill"
            case .warning: return "exclamationmark.triangle.fill"
            case .error: return "xmark.octagon.fill"
            }
        }

        var tint: Color {
            switch self {
            case .info: return .blue
            case .success: return .green
            case .warning: return .orange
            case .error: return .red
            }
        }
    }

    var message: String
    var style: Style = .info
    var duration: TimeInterval = 2.5
}

enum ToastPosition {
    case top, bottom

    var alignment: Alignment { self == .top ? .top : .bottom }
    var edge: Edge { self == .top ? .top : .bottom }
    var padEdge: Edge.Set { self == .top ? .top : .bottom }
}
