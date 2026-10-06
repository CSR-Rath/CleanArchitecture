//
//  SheetModifier.swift
//  CleanArchitecture
//
//  Created by Sophearath.chhan on 10/6/26.
//

import SwiftUI

struct SheetModifier<SheetContent: View>: ViewModifier {

    @Binding private var isPresented: Bool

    private let sheetType: SheetType
    private let backgoundColor: Color
    private let dismissible: Bool

    private let isCloseButtonHidden: Bool
    private let isCapsuleHidden: Bool

    private let onDismissCompleted: (() -> Void)?
    private let builder: () -> SheetContent

    init(
        isPresented: Binding<Bool>,
        sheetType: SheetType,
        backgoundColor: Color,
        dismissible: Bool = true,
        isCloseButtonHidden: Bool = false,
        isCapsuleHidden: Bool = false,
        onDismissCompleted: (() -> Void)? = nil,
        @ViewBuilder builder: @escaping () -> SheetContent
    ) {
        self._isPresented = isPresented
        self.sheetType = sheetType
        self.backgoundColor = backgoundColor
        self.dismissible = dismissible
        self.isCloseButtonHidden = isCloseButtonHidden
        self.isCapsuleHidden = isCapsuleHidden
        self.onDismissCompleted = onDismissCompleted
        self.builder = builder
    }

    func body(content: Content) -> some View {
        ZStack {
            content

            if isPresented {
                BottomSheetPresenter(
                    fractions: sheetFractions,
                    isPresented: $isPresented,
                    backgoundColor: backgoundColor,
                    dismissible: dismissible,
                    isCloseButtonHidden: isCloseButtonHidden,
                    isCapsuleHidden: isCapsuleHidden,
                    onDismissCompleted: onDismissCompleted
                ) {
                    builder()
                }
            }
        }
    }

    private var sheetFractions: [CGFloat] {
        switch sheetType {
        case .fullScreen:
            return [1.0]

        case .fixed(let height):
            return [
                height / UIScreen.main.bounds.height
            ]

        case .fractions(let fractions):
            return fractions.sorted()

        case .present:
            return [0.5]

        case .auto:
            return [0]
        }
    }
}


