//
//  Extension + View.swift
//  CleanArchitecture
//
//  Created by Sophearath.chhan on 10/6/26.
//

import SwiftUI

private struct ViewSizePreferenceKey: PreferenceKey {

    static var defaultValue: CGSize = .zero
    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {
        value = nextValue()
    }
}

extension View {
    
    /*
     Measures the view's size and returns the value through the completion handler.
     The completion is called whenever the view's size changes.
    */

    func getSize(completion: @escaping (CGSize) -> Void) -> some View {
        self
            .background {
                GeometryReader { geometry in
                    Color.clear
                        .preference(
                            key: ViewSizePreferenceKey.self,
                            value: geometry.size
                        )
                }
            }
            .onPreferenceChange(ViewSizePreferenceKey.self) { size in
                completion(size)
            }
    }
}


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
