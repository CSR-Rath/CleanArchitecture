//
//  Extension+LiquidGrass.swift
//  CleanArchitecture
//
//  Created by Sophearath.chhan on 10/6/26.
//

import SwiftUI

extension View {
    
    func liquidBackground<NormalBackground: View>(
        cornerRadius: CGFloat = 16,
        @ViewBuilder normalBackground: () -> NormalBackground
    ) -> some View {
        background (
            LiquidBackground(
                cornerRadius: cornerRadius,
                normalBackground: normalBackground()
            )
        )
        .clipShape(
            RoundedRectangle(
                cornerRadius: cornerRadius,
                style: .continuous
            )
        )
    }
    
    func liquidBackground(
        cornerRadius: CGFloat = 16,
        normalBackground: Color = Color.orange
        
    ) -> some View {
        background (
            LiquidBackground(
                cornerRadius: cornerRadius,
                normalBackground: normalBackground
            )
        )
        .clipShape(
            RoundedRectangle(
                cornerRadius: cornerRadius,
                style: .continuous
            )
        )
    }
}



struct LiquidGrassDemo: View {
    
    @State private var isPresented: Bool = false
    
    var body: some View {

        VStack(alignment: .leading, spacing: 20) {
            
           
            Button(isPresented ? "Close" :  "Liquid Grass") {
                isPresented.toggle()
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical)
            .liquidBackground()
           
            
            BaseButton("Testing", type: .outline, color: .white) {
                isPresented.toggle()
            }
            
            BaseButton("Testing", type: .plain, color: .white) {
                isPresented.toggle()
            }
            
            BaseButton("Testing", type: .custom, color: .white) {
                isPresented.toggle()
            }
//            .liquidBackground()
            
            BaseButton("Testing") {
                isPresented.toggle()
            }
            
            
            
            
        }
        .frame(maxWidth: .infinity)
        .frame(height: .infinity)
        
    }
}

#Preview {
    ZStack{
        Color.appBackground.ignoresSafeArea()
        VStack{
            LiquidGrassDemo()
                
        }
        
    }
   
}
