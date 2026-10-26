//
//  Extension + CornerRadius.swift
//  CleanArchitecture
//
//  Created by Sophearath.chhan on 10/26/26.
//

import SwiftUI

struct RoundedCorner: Shape {
    var radius: CGFloat
    var corners: UIRectCorner

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )

        return Path(path.cgPath)
    }
}

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(
            RoundedCorner(radius: radius, corners: corners)
        )
    }
    
    func cornerRadiusTop(_ radius: CGFloat) -> some View {
        clipShape(
            RoundedCorner(radius: radius, corners: [.topLeft, .topRight])
        )
    }
    
}
