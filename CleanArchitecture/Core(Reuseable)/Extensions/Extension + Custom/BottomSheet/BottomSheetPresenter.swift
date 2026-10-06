//
//  BottomSheetPresenter.swift
//  CleanArchitecture
//
//  Created by Sophearath.chhan on 10/6/26.
//

import SwiftUI

struct BottomSheetPresenter<SheetContent: View>: View {

    @Binding private var isPresented: Bool

    private let fractions: [CGFloat]
    private let backgoundColor: Color
    private let dismissible: Bool

    private let isCloseButtonHidden: Bool
    private let isCapsuleHidden: Bool

    private let onDismissCompleted: (() -> Void)?
    private let content: () -> SheetContent

    @State private var didPresent = false

    init(
        fractions: [CGFloat],
        isPresented: Binding<Bool>,
        backgoundColor: Color,
        dismissible: Bool,
        isCloseButtonHidden: Bool,
        isCapsuleHidden: Bool,
        onDismissCompleted: (() -> Void)?,
        @ViewBuilder content: @escaping () -> SheetContent
    ) {
        self.fractions = fractions
        self._isPresented = isPresented
        self.backgoundColor = backgoundColor
        self.dismissible = dismissible
        self.isCloseButtonHidden = isCloseButtonHidden
        self.isCapsuleHidden = isCapsuleHidden
        self.onDismissCompleted = onDismissCompleted
        self.content = content
    }

    var body: some View {
        Color.clear
            .onAppear {
                presentIfNeeded()
            }
    }

    private func presentIfNeeded() {
        guard !didPresent else {
            return
        }

        didPresent = true

        let sheet = BottomSheetView(
            isPresented: $isPresented,
            fractions: fractions,
            backgoundColor: backgoundColor,
            dismissible: dismissible,
            isCloseButtonHidden: isCloseButtonHidden,
            isCapsuleHidden: isCapsuleHidden,
            onDismissCompleted: onDismissCompleted
        ) {
            content()
        }

        let viewController = UIHostingController(
            rootView: sheet
        )

        viewController.view.backgroundColor = .clear
        viewController.modalPresentationStyle = .overFullScreen
        viewController.modalTransitionStyle = .crossDissolve
        UIApplication.shared.topMostViewController()?.present( viewController, animated: true)
    }
}
