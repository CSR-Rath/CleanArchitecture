//
//  Extension + Toast.swift
//  CleanArchitecture
//
//  Created by Sophearath.chhan on 10/22/26.
//

import SwiftUI

extension View {
    /// Shows a toast at the given edge whenever `toast` is non-nil.
    func toast(_ toast: Binding<Toast?>, position: ToastPosition = .bottom) -> some View {
        modifier(ToastModifier(toast: toast, position: position))
    }
}


// MARK: - Usage (top + bottom toasts)

struct ToastDemo: View {
    @State private var topToast: Toast?
    @State private var bottomToast: Toast?

    var body: some View {
        VStack(spacing: 16) {
            Button("Top toast") {
                topToast = Toast(message: "New message received", style: .info)
            }
            
            Button("Top toast") {
                topToast = Toast(message: "New message received", style: .error)
            }
            
            Button("Top toast") {
                topToast = Toast(message: "New message received", style: .warning)
            }
            
            Button("Top toast") {
                topToast = Toast(message: "New message received", style: .success)
            }
            
            
            
            Button("Bottom toast") {
                bottomToast = Toast(message: "Saved successfully", style: .success)
            }
            
            Button("Bottom toast") {
                bottomToast = Toast(message: "Saved successfully", style: .warning)
            }
            
            Button("Bottom toast") {
                bottomToast = Toast(message: "Saved successfully", style: .error)
            }
            
            Button("Bottom toast") {
                bottomToast = Toast(message: "Saved successfully", style: .info)
            }
        }
        .buttonStyle(.borderedProminent)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .toast($topToast, position: .top)
        .toast($bottomToast, position: .bottom)
    }
}



#Preview {
    ToastDemo()
}
