//
//  DefaultBackButton.swift
//  CleanArchitecture
//
//  Created by Sophearath.chhan on 10/21/26.
//

import SwiftUI

// MARK: - Default Back Button
struct DefaultBackButton: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        Button {
            dismiss()
        } label: {
            Image(systemName: "chevron.left")
        }
    }
}

// MARK: - Default Back Button Configuration
extension BaseView where LeadingItem == DefaultBackButton {
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
        @ViewBuilder trailingItem: @escaping () -> TrailingItem = { EmptyView() },
        @ViewBuilder header: @escaping () -> Header = { EmptyView() },
        @ViewBuilder content: @escaping () -> Content,
        @ViewBuilder footer: @escaping () -> Footer = { EmptyView() }
    ) {
        self.init(
            state: state,
            title: title,
            backgroundViewColor: backgroundViewColor,
            isShowNavigation: isShowNavigation,
            isKeyboardDismissEnabled: isKeyboardDismissEnabled,
            isContentScrollView: isContentScrollView,
            onViewDidload: onViewDidload,
            onViewWillAppear: onViewWillAppear,
            onViewDidAppear: onViewDidAppear,
            onViewWillDisappear: onViewWillDisappear,
            onViewDidDisappear: onViewDidDisappear,
            onRefresh: onRefresh,
            leadingItem: { DefaultBackButton() },
            trailingItem: trailingItem,
            header: header,
            content: content,
            footer: footer
        )
    }
}
