//
//  LiquidBackground.swift
//  CleanArchitecture
//
//  Created by Sophearath.chhan on 10/6/26.
//

import SwiftUI
import UIKit

//MARK: - Generic background support
struct LiquidBackground<NormalBackground: View>: View {
    
    let cornerRadius: CGFloat
    let normalBackground: NormalBackground
    var isGlassTheme: Bool = false
    
    private let lineWidth: CGFloat = 1
    
    
    private var shape: RoundedRectangle {
        RoundedRectangle(
            cornerRadius: cornerRadius,
            style: .continuous
        )
    }
    
    var body: some View {
        Group {
            if isGlassTheme {
                liquidContent
            } else {
                normalBackground
            }
        }
        .clipShape(shape)
    }
    
    @ViewBuilder
    private var liquidContent: some View {
        if #available(iOS 26.0, *) {
            Color.clear.opacity(0)
                .glassEffect(.clear, in: shape)
                .overlay {
                    shape.stroke(
                        borderGradient,
                        lineWidth: lineWidth
                    )
                }
        } else {
            customLiquidBackground
        }
    }
    
    private var customLiquidBackground: some View {
        LiquidBlurView(style: blurStyle)
            .opacity(0.9)
            .overlay (
                shape.stroke(
                    borderGradient,
                    lineWidth: lineWidth
                )
            )
    }
    
    private var blurStyle: UIBlurEffect.Style {
        .systemUltraThinMaterialLight
    }
    
    
    private var borderGradient: LinearGradient {
        LinearGradient(
            colors: [
                Color.white.opacity(1),
                Color.white.opacity(0.8)
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
}

