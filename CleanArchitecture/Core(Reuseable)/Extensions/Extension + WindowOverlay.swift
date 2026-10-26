//
//  Extension + windowOverlay.swift
//  CleanArchitecture
//
//  Created by Sophearath.chhan on 10/26/26.
//

import SwiftUI

struct WindowOverlayModifier<Overlay: View>: ViewModifier {
    @Binding var isPresented: Bool
    @ViewBuilder let overlay: () -> Overlay
    
    @State private var hostingController: UIHostingController<Overlay>?
    
    func body(content: Content) -> some View {
        content
            .onChange(of: isPresented) { show in
                updateOverlay(show: show)
            }
            .onDisappear {
                removeOverlay()
            }
    }
    
    private func updateOverlay(show: Bool) {
        if show {
            guard hostingController == nil else { return }
            guard let window = getKeyWindow() else { return }
            
            let controller = UIHostingController(rootView: overlay())
            controller.view.backgroundColor = .clear
            controller.view.frame = window.bounds
            controller.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            controller.view.alpha = 0
            
            window.addSubview(controller.view)
            self.hostingController = controller
            
            UIView.animate(withDuration: 0.2) {
                controller.view.alpha = 1
            }
        } else {
            removeOverlay()
        }
    }
    
    private func removeOverlay() {
        guard let controller = hostingController else { return }
        UIView.animate(withDuration: 0.2) {
            controller.view.alpha = 0
        } completion: { _ in
            controller.view.removeFromSuperview()
            self.hostingController = nil
        }
    }
    
    private func getKeyWindow() -> UIWindow? {
        UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .first { $0.isKeyWindow }
    }
}

extension View {
    func windowOverlay<Content: View>(
        isPresented: Binding<Bool>,
        @ViewBuilder content: @escaping () -> Content
    ) -> some View {
        self.modifier(WindowOverlayModifier(isPresented: isPresented, overlay: content))
    }
}
