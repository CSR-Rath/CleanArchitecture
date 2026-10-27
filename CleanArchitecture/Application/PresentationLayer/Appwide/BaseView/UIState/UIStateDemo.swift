//
//  UIStateDemo.swift
//  CleanArchitecture
//
//  Created by Sophearath.chhan on 10/26/26.
//

import SwiftUI

struct UIStateDemo: View {
    
    @State private var uiState: UIState = .idle
    
    var body: some View {
        BaseView(state: $uiState){
            VStack{
                stateButtonGrid
            }
        }
    }
    
    // MARK: - All Enum State Buttons
    private var stateButtonGrid: some View {
        ScrollView {
            VStack(spacing: 10) {
                // 1. Loading States
                HStack(spacing: 10) {
                    demoButton(title: ".loading", icon: "progress.indicator", color: .indigo) {
                        uiState = .loading
                        // Auto-dismiss after 2 seconds for testing
                        dismissAfterDelay()
                    }
                    
                    demoButton(title: ".shimmerLoading", icon: "sparkles", color: .indigo) {
                        uiState = .shimmerLoading
                        dismissAfterDelay()
                    }
                }
                
                // 2. Specialized Flow States
                // 3. Info Dialog State
                demoButton(title: ".info (Dialog)", icon: "info.circle.fill", color: .blue) {
                    uiState = .info(message: "A new version of the app is ready to install.",
                        leftBtn: ButtonInfo(title: "Later", action: {
                            uiState = .idle
                        }),
                        rightBtn: ButtonInfo(title: "Update", action: {
                            uiState = .idle
                        })
                    )
                }
                
                // 4. Failed States (Non-Actionable vs Actionable)
                HStack(spacing: 10) {
                    demoButton(title: ".failed (Full Screen)", icon: "xmark.octagon.fill", color: .orange) {
                        uiState = .failed(message: "A new version of the app is ready to install.")
                    }
                    
                    demoButton(title: ".failedAction (Modal)", icon: "exclamationmark.arrow.triangle.2.circlepath", color: .red) {
                        uiState = .failedAction(message: "The destination account is currently unreachable (Code: 503).",
                            leftBtn: ButtonInfo(title: "Cancel", action: {
                                uiState = .idle
                            }),
                            rightBtn: ButtonInfo(title: "Retry Transfer", action: {
                                uiState = .loading
                                dismissAfterDelay(seconds: 1.5)
                            })
                        )
                    }
                }
            }
            .padding()
        }
        .frame(maxHeight: 260)
        .background(.ultraThinMaterial)
    }
    
    // Helper for styled action buttons
    private func demoButton(title: String, icon: String, color: Color, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Label(title, systemImage: icon)
                .font(.footnote.weight(.semibold))
                .frame(maxWidth: .infinity)
                .padding(.vertical, 10)
        }
        .buttonStyle(.borderedProminent)
        .tint(color)
    }
    
    private func dismissAfterDelay(seconds: Double = 2.0) {
        Task {
            try? await Task.sleep(nanoseconds: UInt64(seconds * 1_000_000_000))
            if !Task.isCancelled {
                uiState = .idle
            }
        }
    }
}

#Preview {
    UIStateDemo()
}
