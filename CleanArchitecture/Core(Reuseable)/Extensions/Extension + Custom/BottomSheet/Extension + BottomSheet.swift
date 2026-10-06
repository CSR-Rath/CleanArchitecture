//
//  Extension + BottomSheet.swift
//  CleanArchitecture
//
//  Created by Sophearath.chhan on 10/6/26.
//

import SwiftUI

extension View {

    func bottomSheet<Content: View>(
        isPresented: Binding<Bool>,
        type: SheetType = .present,
        backgoundColor: Color = .white,
        dismissible: Bool = true,
        isCloseButtonHidden: Bool = true,
        isCapsuleHidden: Bool = false,
        onDismissCompleted: (() -> Void)? = nil,
        @ViewBuilder content: @escaping () -> Content
    ) -> some View {

        modifier(
            SheetModifier(
                isPresented: isPresented,
                sheetType: type,
                backgoundColor: backgoundColor,
                dismissible: dismissible,
                isCloseButtonHidden: isCloseButtonHidden,
                isCapsuleHidden: isCapsuleHidden,
                onDismissCompleted: onDismissCompleted,
                builder: content
            )
        )
    }
}
