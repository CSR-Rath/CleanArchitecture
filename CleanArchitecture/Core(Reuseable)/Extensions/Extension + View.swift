//
//  Extension + View.swift
//  CleanArchitecture
//
//  Created by Sophearath.chhan on 10/6/26.
//

import SwiftUI

// MARK: - Handle get size view
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


// MARK: Check condition Bool to use view
extension View {
    @ViewBuilder
    func `if`<Content: View>(_ condition: Bool, transform: (Self) -> Content) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
}


// MARK: Check should use dismissKeyboard or not
extension View {
    @ViewBuilder
    func dismissKeyboardOnTap(enabled: Bool = true) -> some View {
        if enabled {
            self
                .contentShape(Rectangle())
                .onTapGesture {
                    UIApplication.shared.sendAction(
                        #selector(UIResponder.resignFirstResponder),
                        to: nil,
                        from: nil,
                        for: nil
                    )
                }
        } else {
            self
        }
    }
}
