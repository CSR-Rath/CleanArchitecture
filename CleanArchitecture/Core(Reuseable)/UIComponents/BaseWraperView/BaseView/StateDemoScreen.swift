//
//  StateDemoScreen.swift
//  CleanArchitecture
//
//  Created by Sophearath.chhan on 10/8/26.
//


import SwiftUI
import Combine

struct StateDemoScreen: View {
    @StateObject private var viewModel = DemoViewModel()

    var body: some View {
        BaseView(
            state: $viewModel.uiState,
            title: "UIState Demo",
            isShowNavigation: true,
            isContentScrollView: true,
            onViewDidload: {
                
            },
            trailingItem: {
                HStack(spacing: 12) {
                    Button {
                        print("Search tapped")
                    } label: {
                        Image(systemName: "magnifyingglass")
                    }
                    
                    Button {
                        print("Notifications tapped")
                    } label: {
                        Image(systemName: "bell")
                    }
                }
            },
            content: {
                VStack(spacing: 12) {
                    Text("Tap a button to trigger UIStateView:")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .padding(.bottom, 10)
                    
                    
                    BaseButton {
                        viewModel.showLoading()
                    } customContent: {_ in 
                        Text("Text")
                    }
                    .background(Color.red)


                    // 1. Trigger Loading State
                    DemoButton(title: "Show Loading Overlay", color: .blue) {
                        viewModel.showLoading()
                    }

                    // 2. Trigger Info Alert
                    DemoButton(title: "Show Info Alert", color: .orange) {
                        viewModel.showInfoAlert()
                    }

                    // 3. Trigger Simple Failure Alert
                    DemoButton(title: "Show Failed Alert", color: .red) {
                        viewModel.showFailedAlert()
                    }

                    // 4. Trigger Failure with Action
                    DemoButton(title: "Show Failed Action Alert", color: .purple) {
                        viewModel.showFailedActionAlert()
                    }
                    
                    // 5. Reset State
                    DemoButton(title: "Reset to Idle", color: .gray) {
                        viewModel.resetState()
                    }
                    
                    // 1. Trigger Loading State
                    DemoButton(title: "Show Loading Overlay", color: .blue) {
                        viewModel.showLoading()
                    }

                    // 2. Trigger Info Alert
                    DemoButton(title: "Show Info Alert", color: .orange) {
                        viewModel.showInfoAlert()
                    }

                    // 3. Trigger Simple Failure Alert
                    DemoButton(title: "Show Failed Alert", color: .red) {
                        viewModel.showFailedAlert()
                    }

                    // 4. Trigger Failure with Action
                    DemoButton(title: "Show Failed Action Alert", color: .purple) {
                        viewModel.showFailedActionAlert()
                    }
                    
                    // 5. Reset State
                    DemoButton(title: "Reset to Idle", color: .gray) {
                        viewModel.resetState()
                    }
                    
                    
                    // 1. Trigger Loading State
                    DemoButton(title: "Show Loading Overlay", color: .blue) {
                        viewModel.showLoading()
                    }

                    // 2. Trigger Info Alert
                    DemoButton(title: "Show Info Alert", color: .orange) {
                        viewModel.showInfoAlert()
                    }

                    // 3. Trigger Simple Failure Alert
                    DemoButton(title: "Show Failed Alert", color: .red) {
                        viewModel.showFailedAlert()
                    }

                    // 4. Trigger Failure with Action
                    DemoButton(title: "Show Failed Action Alert", color: .purple) {
                        viewModel.showFailedActionAlert()
                    }
                    
                    // 5. Reset State
                    DemoButton(title: "Reset to Idle", color: .gray) {
                        viewModel.resetState()
                    }
                }
                .padding(.top, 20)
            }
        )
    }
    
    struct DemoButton: View {
        let title: String
        let color: Color
        let action: () -> Void

        var body: some View {
            Button(action: action) {
                Text(title)
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(color)
                    .cornerRadius(10)
            }
        }
    }
}

// MARK: - Reusable Demo Button


// MARK: - Demo ViewModel
@MainActor
final class DemoViewModel: ObservableObject {
    @Published var uiState: UIStateView = .idle

    func showLoading() {
        uiState = .loading
        
        // Auto dismiss loading after 2 seconds
        Task {
            try? await Task.sleep(nanoseconds: 2_000_000_000)
            uiState = .idle
        }
    }

    func showInfoAlert() {
        uiState = .info(
            AppMessage(message: "Your profile details have been updated successfully."),
//            leftBtn: ButtonInfo(title: "Close"),
            rightBtn: ButtonInfo(title: "Ok", action: {
               debugLog("Clicked View Profile")
            })
        )
    }

    func showFailedAlert() {
        // Automatically converts NetworkError to MbError via error.asError
        let error = NetworkError.invalidResponse
        uiState = .failed(error.asError)
    }

    func showFailedActionAlert() {
        let error = NetworkError.httpError(statusCode: 401)
        
        uiState = .failedAction(
            error: error.asError,
            leftBtn: ButtonInfo(title: "Dismiss"),
            rightBtn: ButtonInfo(title: "Log In", action: {
               debugLog("Redirecting to Login...")
            })
        )
    }

    func resetState() {
        uiState = .idle
    }
}


#Preview(body: {
    
    NavigationStack{
        StateDemoScreen()
    }
   
})
