//
//  Extension+Shimmer.swift
//  CleanArchitecture
//
//  Created by Sophearath.chhan on 10/6/26.
//

import SwiftUI

extension View {
    func shimmer() -> some View {
        modifier(ShimmerModifier())
    }
}

struct ShimmerDemo: View {
    var body: some View {
        ScrollView{
            VStack(alignment: .leading, spacing: 20) {
                
                ForEach(0..<30, id: \.self) { index in
                    
                        RoundedRectangle(cornerRadius: 12)
                        .fill(Color.shimmerColor)
                            .frame(height: 60)
                            .shadow(color: Color.black ,radius: .infinity)
                            .shimmer()
                }
                
            }
            .padding()
        }
    }
}

#Preview {
    ZStack{
        Color.appBackground
            .ignoresSafeArea()
        ShimmerDemo()
    }
}
