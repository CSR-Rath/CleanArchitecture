//
//  ToastModifier.swift
//  CleanArchitecture
//
//  Created by Sophearath.chhan on 10/22/26.
//

import SwiftUI

struct ToastModifier: ViewModifier {
    @Binding var toast: Toast?
    let position: ToastPosition
    @State private var dismissTask: Task<Void, Never>?

    func body(content: Content) -> some View {
        content
            .overlay(alignment: position.alignment) {
                if let toast {
                    ToastView(toast: toast)
                        .transition(.move(edge: position.edge).combined(with: .opacity))
                        .onTapGesture { dismiss() }
                        .padding(position.padEdge, 8)
                }
            }
            .animation(.spring(response: 0.4, dampingFraction: 0.8), value: toast)
            .onChange(of: toast) { newValue in
                guard let newValue else { return }
                UIAccessibility.post(notification: .announcement,
                                     argument: newValue.message)
                dismissTask?.cancel()
                dismissTask = Task {
                    try? await Task.sleep(nanoseconds: UInt64(newValue.duration * 1_000_000_000))
                    if !Task.isCancelled { await MainActor.run { dismiss() } }
                }
            }
    }

    private func dismiss() {
        dismissTask?.cancel()
        toast = nil
    }
}

struct ToastView: View {
   let toast: Toast

   var body: some View {
       HStack(spacing: 10) {
           Image(systemName: toast.style.icon)
               .foregroundStyle(toast.style.tint)
           Text(toast.message)
               .font(.subheadline.weight(.medium))
               .foregroundStyle(.primary)
               .multilineTextAlignment(.leading)
       }
       .padding(.horizontal, 16)
       .padding(.vertical, 12)
       .background(.regularMaterial, in: Capsule())
       .overlay(Capsule().strokeBorder(toast.style.tint.opacity(0.25), lineWidth: 1))
       .shadow(color: .black.opacity(0.12), radius: 10, y: 4)
       .padding(.horizontal, 20)
       .accessibilityElement(children: .combine)
   }
}
