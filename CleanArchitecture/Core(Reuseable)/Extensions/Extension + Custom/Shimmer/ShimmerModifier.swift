//
//  ShimmerModifier.swift
//  CleanArchitecture
//
//  Created by Sophearath.chhan on 10/6/26.
//

import SwiftUI

struct ShimmerModifier: ViewModifier {
    @State private var offset: CGFloat = -1
    
    func body(content: Content) -> some View {
        content
            .overlay(
                GeometryReader { geometry in
                    LinearGradient(
                        colors: [
                            .clear,
                            Color.white.opacity(0.35),
                            .clear
                        ],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                    .frame(width: geometry.size.width * 0.85)
                    .offset(x: geometry.size.width * offset)
                }
            )
            .mask(content)
            .clipped()
            .onAppear {
                withAnimation(
                    .linear(duration: 0.80)
                    .repeatForever(autoreverses: false)
                ) {
                    offset = 1
                }
            }
    }
}
