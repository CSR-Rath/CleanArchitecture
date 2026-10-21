//
//  Extension + ViewLifecycle.swift
//  CleanArchitecture
//
//  Created by Sophearath.chhan on 10/6/26.
//

import SwiftUI

extension View {

    func onViewDidLoad( _ action: @escaping () -> Void) -> some View {
        background(
            ViewLifecycleRepresentable(
                onViewDidLoad: action,
                onViewWillAppear: nil,
                onViewDidAppear: nil,
                onViewWillDisappear: nil,
                onViewDidDisappear: nil
            )
            .frame(width: 0, height: 0)
        )
    }

    func onViewWillAppear( _ action: @escaping () -> Void) -> some View {
        background(
            ViewLifecycleRepresentable(
                onViewDidLoad: nil,
                onViewWillAppear: action,
                onViewDidAppear: nil,
                onViewWillDisappear: nil,
                onViewDidDisappear: nil
            )
            .frame(width: 0, height: 0)
        )
    }

    func onViewDidAppear(_ action: @escaping () -> Void) -> some View {
        background(
            ViewLifecycleRepresentable(
                onViewDidLoad: nil,
                onViewWillAppear: nil,
                onViewDidAppear: action,
                onViewWillDisappear: nil,
                onViewDidDisappear: nil
            )
            .frame(width: 0, height: 0)
        )
    }

    func onViewWillDisappear( _ action: @escaping () -> Void) -> some View {
        background(
            ViewLifecycleRepresentable(
                onViewDidLoad: nil,
                onViewWillAppear: nil,
                onViewDidAppear: nil,
                onViewWillDisappear: action,
                onViewDidDisappear: nil
            )
            .frame(width: 0, height: 0)
        )
    }

    func onViewDidDisappear(_ action: @escaping () -> Void) -> some View {
        background(
            ViewLifecycleRepresentable(
                onViewDidLoad: nil,
                onViewWillAppear: nil,
                onViewDidAppear: nil,
                onViewWillDisappear: nil,
                onViewDidDisappear: action
            )
            .frame(width: 0, height: 0)
        )
    }
}


extension View {

    func viewLifecycle(
        onViewDidLoad: @escaping (() -> Void),
        onViewWillAppear: @escaping (() -> Void),
        onViewDidAppear: @escaping (() -> Void),
        onViewWillDisappear: @escaping (() -> Void),
        onViewDidDisappear: @escaping (() -> Void)
    ) -> some View {

        background(
            ViewLifecycleRepresentable(
                onViewDidLoad: onViewDidLoad,
                onViewWillAppear: onViewWillAppear,
                onViewDidAppear: onViewDidAppear,
                onViewWillDisappear: onViewWillDisappear,
                onViewDidDisappear: onViewDidDisappear
            )
            .frame(width: 0, height: 0)
        )
    }
}
