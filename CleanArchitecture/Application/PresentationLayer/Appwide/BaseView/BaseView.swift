//
//  BaseView.swift
//  CleanArchitecture
//
//  Created by Sophearath.chhan on 10/7/26.
//

import SwiftUI
import Combine

struct BaseView<
    Header: View,
    Content: View,
    Footer: View,
    LeadingItem: View,
    TrailingItem: View
>: View {
    
    private let title: String
    private let isTooBarLeading: Bool
    private let isContentScrollView: Bool
    private let isKeyboardDismissEnabled: Bool
    private let backgroundViewColor: Color
    private let onRefresh: (() async -> Void)?
    
    // MARK: - View Lifecycle
    private let onViewDidload: (() -> Void)?
    private let onViewWillAppear: (() -> Void)?
    private let onViewDidAppear: (() -> Void)?
    private let onViewWillDisappear: (() -> Void)?
    private let onViewDidDisappear: (() -> Void)?
    
    // MARK: - Builder layout views
    @ViewBuilder private let headerView: () -> Header
    @ViewBuilder private let contentView: () -> Content
    @ViewBuilder private let footerView: () -> Footer
    @ViewBuilder private let leadingItem: () -> LeadingItem
    @ViewBuilder private let trailingItem: () -> TrailingItem
    
    // MARK: - Binding state view
    @Binding private var state: UIState
    @State private var alertData: AlertData?
    
    // MARK: - For pop screen
    @Environment(\.dismiss) private var dismiss
    
    init(
        state: Binding<UIState> = .constant(.idle),
        title: String = "",
        backgroundViewColor: Color = Color.white,
        isShowNavigation: Bool = false,
        isKeyboardDismissEnabled: Bool = false,
        isContentScrollView: Bool = true,
        onViewDidload: (() -> Void)? = nil,
        onViewWillAppear: (() -> Void)? = nil,
        onViewDidAppear: (() -> Void)? = nil,
        onViewWillDisappear: (() -> Void)? = nil,
        onViewDidDisappear: (() -> Void)? = nil,
        onRefresh: (() async -> Void)? = nil,
        @ViewBuilder leadingItem: @escaping () -> LeadingItem,
        @ViewBuilder trailingItem: @escaping () -> TrailingItem = { EmptyView() },
        @ViewBuilder header: @escaping () -> Header = { EmptyView() },
        @ViewBuilder content: @escaping () -> Content,
        @ViewBuilder footer: @escaping () -> Footer = { EmptyView() }
    ) {
        self.title = title
        self._state = state
        self.backgroundViewColor = backgroundViewColor
        self.isTooBarLeading = isShowNavigation
        self.isKeyboardDismissEnabled = isKeyboardDismissEnabled
        self.isContentScrollView = isContentScrollView
        self.onRefresh = onRefresh
        self.onViewDidload = onViewDidload
        self.onViewWillAppear = onViewWillAppear
        self.onViewDidAppear = onViewDidAppear
        self.onViewWillDisappear = onViewWillDisappear
        self.onViewDidDisappear = onViewDidDisappear
        self.leadingItem = leadingItem
        self.trailingItem = trailingItem
        self.headerView = header
        self.contentView = content
        self.footerView = footer
    }
    
    var body: some View {
        ZStack {
            backgroundViewColor
                .ignoresSafeArea()
            VStack(spacing: 0) {
                handleheaderView()
                handleContentView()
                handleFooterView()
            }
        }
        .windowOverlay(isPresented: isLoading) {
            handleUIStateOverlay()
        }
        .windowOverlay(isPresented: .isCase($state, matching: .shimmerLoading)) {
            handleUIStateOverlay()
        }
        .onChange(of: state) { newState in
            checkForAlerts(from: newState)
        }
        .alert(item: $alertData) { alert in
            if let leftBtn = alert.leftBtn {
                return Alert(
                    title: Text(alert.title),
                    message: Text(alert.message),
                    primaryButton: .default(Text(alert.rightBtn?.title ?? ""),
                                            action: alert.rightBtn?.action),
                    secondaryButton: .cancel(Text(leftBtn.title), action: leftBtn.action)
                )
            } else {
                return Alert(
                    title: Text(alert.title),
                    message: Text(alert.message),
                    dismissButton: .default(Text(alert.rightBtn?.title ?? ""),
                                            action: alert.rightBtn?.action)
                )
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("")
        .navigationBarHidden(false) // Display navigation bar
        .navigationBarBackButtonHidden(true) // Hide default back button
        .toolbar {
            
            if isTooBarLeading {
                ToolbarItem(placement: .topBarLeading) {
                    leadingItem()
                }
            }
            
            ToolbarItem(placement: .topBarTrailing) {
                trailingItem()
            }
            
            if !title.isEmpty {
                ToolbarItem(placement: .principal) {
                    BaseText(  "test",
                             textType: .custom(type: .subtitle, size: 17),
                             textColor: .red)
                }
            }
        }
        .viewLifecycle(
            onViewDidLoad: {
                onViewDidload?()
            },
            onViewWillAppear: {
                onViewWillAppear?()
            },
            onViewDidAppear: {
                onViewDidAppear?()
            },
            onViewWillDisappear: {
                onViewWillDisappear?()
            },
            onViewDidDisappear: {
                onViewDidDisappear?()
            }
        )
        .configureNavigationBarAppearance()
        .dismissKeyboardOnTap(enabled: isKeyboardDismissEnabled)
    }
}

// MARK: - UIState Handling & Alerts
private extension BaseView {
    
    @ViewBuilder
    func handleUIStateOverlay() -> some View {
        if state == .loading {
            ZStack {
                Color.black.opacity(0.5)
                    .ignoresSafeArea()
                
                ProgressView()
                    .padding(20)
                    .background(Color(UIColor.systemBackground))
                    .cornerRadius(10)
                    .shadow(radius: 5)
            }
        } else{
            EmptyView()
        }
    }
    
    func checkForAlerts(from state: UIState) {
        switch state {
        case .info(let message, let leftBtn, let rightBtn):
            alertData = AlertData(
                title: "Notice",
                message: message,
                leftBtn: leftBtn == nil ? nil : ButtonInfo(
                    title: leftBtn?.title ?? "",
                    action: {
                        clearAlert()
                        leftBtn?.action?()
                    }
                ),
                rightBtn: ButtonInfo(
                    title: rightBtn.title,
                    action: {
                        clearAlert()
                        rightBtn.action?()
                    }
                )
            )
            
        case .failed(let message):
            alertData = AlertData(
                title: "Error",
                message: message,
                leftBtn: nil,
                rightBtn: ButtonInfo(
                    title: "OK",
                    action: {
                        clearAlert()
                    }
                )
            )
            
        case .failedAction(let message, let leftBtn, let rightBtn):
            alertData = AlertData(
                title: "Action Required",
                message: message,
                leftBtn: leftBtn.map { button in
                    ButtonInfo(
                        title: button.title,
                        action: {
                            clearAlert()
                            button.action?()
                        }
                    )
                },
                rightBtn: ButtonInfo(
                    title: rightBtn.title,
                    action: {
                        clearAlert()
                        rightBtn.action?()
                    }
                )
            )
            
        default:
            alertData = nil
        }
    }
    
    func clearAlert() {
        alertData = nil
        state = .idle
    }
}

// MARK: - Builder layout views
private extension BaseView {
    
    @ViewBuilder
    func handleContentView() -> some View {
        if isContentScrollView {
            GeometryReader { proxy in
                ScrollView(showsIndicators: false) {
                    contentView()
                        .padding(.top, 0)
                        .padding(.horizontal)
                        .frame(width: proxy.size.width, alignment: .topLeading)
                }
                .safeAreaInset(edge: .bottom) {
                    Color.clear.frame(height: 50)
                }
                .refreshable {
                    await onRefresh?()
                }
            }
        } else {
            contentView()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
    
    @ViewBuilder
    func handleFooterView() -> some View {
        footerView()
            .padding(.vertical, 10)
            .padding(.horizontal)
    }
    
    @ViewBuilder
    func handleheaderView() -> some View {
        headerView()
    }
}

// MARK: - Model alert
private struct AlertData: Identifiable {
    let id = UUID()
    let title: String
    let message: String
    let leftBtn: ButtonInfo?
    let rightBtn: ButtonInfo?
}



// MARK: - Show Overlay view
extension BaseView {
    var isLoading: Binding<Bool> {
        Binding(
            get: { state == .loading},
            set: { _ in }
        )
    }
}
