//
//  ShimmerModifier.swift
//  CleanArchitecture
//
//  Created by Sophearath.chhan on 10/23/26.
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
                            Color.white.opacity(0.4),
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

extension Color{
    static let shimmerColor = Color.gray.opacity(0.5)
}

extension View {
    func shimmer() -> some View {
        modifier(ShimmerModifier())
    }
}

struct DemoShimmer: View {
    var body: some View {
        
        VStack(spacing: 20){
            TexFieldListShimmer()
            
            TextShimmer(height: 20)
            
            TextShimmer()
            
            TextFieldShimmer()
        }
        .padding(.horizontal)
    }
}

#Preview {
    ZStack{
        Color.backgroundColor
            .ignoresSafeArea()
        DemoShimmer()
    }
}

