//
//  TextFieldShimmer.swift
//  CleanArchitecture
//
//  Created by Sophearath.chhan on 10/23/26.
//

import SwiftUI

struct TextFieldShimmer: View {
    
    let corner: CGFloat = 16
    
    var body: some View {
        ZStack{
            RoundedRectangle(cornerRadius: corner)
                .fill(.white)
                .overlay {
                    RoundedRectangle(cornerRadius: corner)
                        .stroke(Color.shimmerColor, lineWidth: 1.5)
                }
                .shimmer()
            
            VStack(spacing: 10){
                HStack{
                    TextShimmer()
                        .frame(width: 100)
                    Spacer()
                }
                
                HStack{
                    TextShimmer()
                        .frame(width: 180)
                    Spacer()
                }
  
            }
            .padding(.horizontal)
        }
        .frame(height: 60)
    }
}


struct TexFieldListShimmer: View {
    let count: Int
    
    init(count: Int = 3) {
        self.count = count
    }
    
    var body: some View {
        VStack(spacing: 16){
            ForEach(0..<count, id: \.self){_ in
                TextFieldShimmer()
            }
        }
        .padding(.vertical, 1)
    }
}
