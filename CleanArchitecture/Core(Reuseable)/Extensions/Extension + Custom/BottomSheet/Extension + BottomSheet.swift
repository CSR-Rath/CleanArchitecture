//
//  Extension + BottomSheet.swift
//  CleanArchitecture
//
//  Created by Sophearath.chhan on 10/6/26.
//

import SwiftUI

extension View {

    func customSheet<Content: View>(
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

struct BottomSheetDemoView: View {

    @State private var selectedType: SheetType?
    @State private var isPresented = false

    var body: some View {
//        NavigationStack {
            List {

                // MARK: Present

                Button {
                    show(.present)
                } label: {
                    demoRow(
                        title: ".present",
                        subtitle: "50% screen height"
                    )
                }

                // MARK: Fixed

                Button {
                    show(.fixed(500))
                } label: {
                    demoRow(
                        title: ".fixed(300)",
                        subtitle: "Fixed 300pt height"
                    )
                }

                // MARK: Fractions

                Button {
                    show(.fractions([0.5, 0.9])
                    )
                } label: {
                    demoRow(
                        title: ".fractions",
                        subtitle: "30% → 60% → 90%"
                    )
                }

                // MARK: Full Screen

                Button {
                    show(.fullScreen)
                } label: {
                    demoRow(
                        title: ".fullScreen",
                        subtitle: "100% screen height"
                    )
                }

                // MARK: Auto

                Button {
                    show(.auto)
                } label: {
                    demoRow(
                        title: ".auto",
                        subtitle: "Height based on content"
                    )
                }
            }
            .navigationTitle("Bottom Sheet")
//        }
        .customSheet(
            isPresented: $isPresented,
            type: selectedType ?? .present,
            dismissible: true
        ) {
            sheetContent
        }
    }

    // MARK: - Show

    private func show(_ type: SheetType) {
        selectedType = type
        isPresented = true
    }

    // MARK: - Row

    private func demoRow(
        title: String,
        subtitle: String
    ) -> some View {

        VStack(
            alignment: .leading,
            spacing: 6
        ) {
            Text(title)
                .font(.headline)

            Text(subtitle)
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .padding(.vertical, 8)
    }

    // MARK: - Sheet Content

    private var sheetContent: some View {
        VStack(spacing: 20) {

            Text("Bottom Sheet")
                .font(.title2.bold())

            Text(
                descriptionForSelectedType
            )
            .multilineTextAlignment(.center)
            .foregroundStyle(.secondary)

            Divider()

            Button("Action 1") {
               debugLog("Action 1")
            }
            .buttonStyle(.borderedProminent)

            Button("Action 2") {
               debugLog("Action 2")
            }
            .buttonStyle(.bordered)

            Button("Close") {
                isPresented = false
            }
            .foregroundStyle(.red)

            if isFullScreen {
                Spacer()
            }
        }
        .padding(24)
        .frame(maxWidth: .infinity)
    }

    // MARK: - Description

    private var descriptionForSelectedType: String {
        guard let selectedType else {
            return ""
        }

        switch selectedType {

        case .present:
            return """
            This sheet uses 50% of the screen height.
            """

        case .fixed(let height):
            return """
            This sheet has a fixed height of \(Int(height))pt.
            """

        case .fractions(let fractions):
            return """
            This sheet supports multiple snap points:

            \(fractions
                .map {
                    "\(Int($0 * 100))%"
                }
                .joined(separator: " → "))
            """

        case .fullScreen:
            return """
            This sheet uses the full screen.
            """

        case .auto:
            return """
            This sheet automatically calculates
            its height from the content.
            """
        }
    }

    private var isFullScreen: Bool {
        if case .fullScreen = selectedType {
            return true
        }

        return false
    }
}
