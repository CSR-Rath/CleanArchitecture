//
//  BottomSheetView.swift
//  CleanArchitecture
//
//  Created by Sophearath.chhan on 10/6/26.
//

import SwiftUI

struct BottomSheetView<Content: View>: View {

    @Binding private var isPresented: Bool

    private let fractions: [CGFloat]
    private let backgoundColor: Color
    private let dismissible: Bool

    private let isCloseButtonHidden: Bool
    private let isCapsuleHidden: Bool

    private let onDismissCompleted: (() -> Void)?
    private let content: () -> Content

    @State private var currentFraction: CGFloat = 0.4
    @State private var dragOffset: CGFloat = 0
    @State private var isShown = false
    @State private var scale: CGFloat = 1
    @State private var contentHeight: CGFloat = 0
    @State private var isDismissing = false

    private let dismissThreshold: CGFloat = 180
    private let snapThreshold: CGFloat = 50

    init(
        isPresented: Binding<Bool>,
        fractions: [CGFloat],
        backgoundColor: Color,
        dismissible: Bool,
        isCloseButtonHidden: Bool,
        isCapsuleHidden: Bool,
        onDismissCompleted: (() -> Void)?,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self._isPresented = isPresented
        self.fractions = fractions
        self.backgoundColor = backgoundColor
        self.dismissible = dismissible
        self.isCloseButtonHidden = isCloseButtonHidden
        self.isCapsuleHidden = isCapsuleHidden
        self.onDismissCompleted = onDismissCompleted
        self.content = content
    }

    private var screenHeight: CGFloat {
        UIScreen.main.bounds.height
    }

    private var isAutoHeight: Bool {
        fractions.first == 0
    }

    private var isFullScreen: Bool {
        currentFraction >= 1
    }

    private var sheetHeight: CGFloat {
        if isAutoHeight {
            return min( contentHeight + 60,  screenHeight * 0.9)
        }

        return screenHeight * currentFraction
    }

    var body: some View {
        ZStack(alignment: .bottom) {

            // MARK: Background

                Color.black
                    .opacity(0.4)
                    .ignoresSafeArea()
                    .onTapGesture {
                        guard dismissible else { return}
                        dismiss()
                    }

            VStack(spacing: 0) {

                header

                content()
                    .frame(maxWidth: .infinity)
                    .background(
                        GeometryReader { geometry in
                            Color.clear
                                .onAppear {
                                    contentHeight =
                                        geometry.size.height
                                }
                                .onChange(of: geometry.size.height) {  height in
                                    contentHeight = height
                                }
                        }
                    )
                
                Spacer()
            }
            .frame(maxWidth: .infinity,  minHeight: sheetHeight, maxHeight: sheetHeight)
            .background(backgoundColor)
            .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
            .scaleEffect(isFullScreen ? scale : 1)
            .offset(y: isShown ? max(dragOffset, 0): screenHeight)
            .gesture(dragGesture)
        }
        .ignoresSafeArea()
        .onAppear {
            setup()
        }
        .onChange(of: isPresented) { newValue in
            guard !newValue else { return }

            dismissFromBinding()
        }
    }

  

    // MARK: Drag Gesture

    private var dragGesture: some Gesture {
        DragGesture()
            .onChanged { value in
                guard dismissible else {
                    return
                }

                let translation =
                    value.translation.height

                guard translation > 0 else {
                    return
                }

                dragOffset = translation

                if isFullScreen {
                    let progress = min( translation / 300, 1)

                    scale = 1 - (progress * 0.2)
                }
            }
            .onEnded { value in
                guard dismissible else {
                    resetDrag()
                    return
                }

                handleDragEnd(
                    value.translation.height
                )
            }
    }

    // MARK: Setup

    private func setup() {
        currentFraction = fractions.first ?? 0.4

        withAnimation( .spring( response: 0.35, dampingFraction: 0.85)) {
            isShown = true
        }
    }

    // MARK: Drag

    private func handleDragEnd(_ drag: CGFloat) {
        if drag > dismissThreshold {
            dismiss()
            return
        }

        withAnimation(.easeOut(duration: 0.25)) {
            if drag < -snapThreshold {
                currentFraction =
                    fractions.last ??
                    currentFraction

            } else if drag > snapThreshold {
                currentFraction =
                    fractions.first ??
                    currentFraction
            }

            resetDrag()
        }
    }

    private func resetDrag() {
        dragOffset = 0
        scale = 1
    }

    // MARK: Dismiss

    private func dismiss() {
        guard !isDismissing else {
            return
        }

        isDismissing = true
        animateDismiss()

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.22) {
            isPresented = false
            dismissViewController()
        }
    }

    private func dismissFromBinding() {
        guard !isDismissing else {
            return
        }

        isDismissing = true
        animateDismiss()

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.22) {
            dismissViewController()
        }
    }

    private func animateDismiss() {
        withAnimation( .easeIn(duration: 0.22)) {
            isShown = false
            dragOffset = screenHeight
            scale = isFullScreen ? 0.94 : 1
        }
    }

    private func dismissViewController() {
        UIApplication.shared.topMostViewController()?.dismiss(animated: false) {
            onDismissCompleted?()
        }
    }
}



// MARK: Header
extension BottomSheetView{
    
    private var header: some View {
        ZStack {

            // Capsule
            if !isCapsuleHidden {
                VStack{
                    Capsule()
                        .fill(Color.gray.opacity(0.4))
                        .frame( width: 40,  height: 5)
                        .padding(.top, 8)
                    Spacer()
                }
            }

            // Close Button
            if !isCloseButtonHidden {
                HStack {
                    Spacer()
                    VStack{
                        closeButton
                            .padding(.trailing)
                            .padding(.top)
                        Spacer()
                    }
                }
            }
        }
        .frame(height: 50)
    }

    // MARK: Close Button

    private var closeButton: some View {
        Button {
            dismiss()
        } label: {
            Image(systemName: "xmark")
                .font( .system( size: 14, weight: .bold))
                .foregroundStyle(.black)
                .frame(width: 32, height: 32)
                .background( Color.gray.opacity(0.15))
                .clipShape(Circle())
        }
    }
}
