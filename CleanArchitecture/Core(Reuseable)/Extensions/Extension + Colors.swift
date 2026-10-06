//
//  Extension + Colors.swift
//  CleanArchitecture
//
//  Created by Sophearath.chhan on 10/6/26.
//

import SwiftUI
import UIKit

extension Color {
    
    static let primaryColor = Color.dynamic(
        light: "#007AFF",
        dark: "#0A84FF"
    )
    
    static let textPrimary = Color.dynamic(
        light: "#222222",
        dark: "#FFFFFF"
    )
    
    static let textSecondary = Color.dynamic(
        light: "#777777",
        dark: "#A6A6A6"
    )
    
    static let appBackground = Color.gray
//    Color.dynamic(
//        light: "#F5F5F5",
//        dark: "#F5F5F5"
//    )
    
    static let cardBackground = Color.dynamic(
        light: "#F5F5F5",
        dark: "#1C1C1E"
    )
    
    static let divider = Color.dynamic(
        light: "#E5E5E5",
        dark: "#38383A"
    )
    
    static let success = Color.dynamic(
        light: "#34C759",
        dark: "#30D158"
    )
    
    static let error = Color.dynamic(
        light: "#FF3B30",
        dark: "#FF453A"
    )
}


extension Color{
    static let shimmerColor = Color.gray.opacity(1.0)
}




extension Color {

    static func dynamic(light: String, dark: String) -> Color {
        Color(
            UIColor { traitCollection in
                if traitCollection.userInterfaceStyle == .dark {
                    return UIColor(hex: dark)
                } else {
                    return UIColor(hex: light)
                }
            }
        )
    }
}

// MARK: - UIColor Hex

extension UIColor {

    convenience init(hex: String) {
        let hex = hex
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .replacingOccurrences(of: "#", with: "")

        var rgb: UInt64 = 0

        Scanner(string: hex).scanHexInt64(&rgb)

        self.init(
            red: CGFloat((rgb >> 16) & 0xFF) / 255.0,
            green: CGFloat((rgb >> 8) & 0xFF) / 255.0,
            blue: CGFloat(rgb & 0xFF) / 255.0,
            alpha: 1.0
        )
    }
}

// MARK: - Color Hex

extension Color {

    init(hex: String) {
        self.init(UIColor(hex: hex))
    }
}
