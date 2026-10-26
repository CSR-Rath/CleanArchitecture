//
//  TextShimmer.swift
//  CleanArchitecture
//
//  Created by Sophearath.chhan on 10/23/26.
//

import SwiftUI

struct TextShimmer: View {
    
    let height: CGFloat
    
    init(height: CGFloat = 10) {
        self.height = height
    }
    
    var body: some View {
        RoundedRectangle(cornerRadius: .infinity)
            .fill(Color.shimmerColor)
            .frame(height: height)
            .shimmer()
    }
}
