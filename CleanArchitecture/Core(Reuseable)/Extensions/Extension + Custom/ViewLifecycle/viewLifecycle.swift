//
//  viewLifecycle.swift
//  CleanArchitecture
//
//  Created by Sophearath.chhan on 10/6/26.
//

import SwiftUI

extension View {

    func viewLifecycle(
        onViewDidLoad: (() -> Void)? = nil,
        onViewWillAppear: (() -> Void)? = nil,
        onViewDidAppear: (() -> Void)? = nil,
        onViewWillDisappear: (() -> Void)? = nil,
        onViewDidDisappear: (() -> Void)? = nil
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
