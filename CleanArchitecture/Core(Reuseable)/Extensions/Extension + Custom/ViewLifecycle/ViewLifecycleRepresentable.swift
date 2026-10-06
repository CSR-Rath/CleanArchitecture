//
//  ViewLifecycleRepresentable.swift
//  CleanArchitecture
//
//  Created by Sophearath.chhan on 10/6/26.
//

import SwiftUI
import UIKit

struct ViewLifecycleRepresentable: UIViewControllerRepresentable {

    let onViewDidLoad: (() -> Void)?
    let onViewWillAppear: (() -> Void)?
    let onViewDidAppear: (() -> Void)?
    let onViewWillDisappear: (() -> Void)?
    let onViewDidDisappear: (() -> Void)?

    func makeUIViewController(
        context: Context
    ) -> LifecycleViewController {

        let viewController = LifecycleViewController()

        viewController.onViewDidLoad = onViewDidLoad
        viewController.onViewWillAppear = onViewWillAppear
        viewController.onViewDidAppear = onViewDidAppear
        viewController.onViewWillDisappear = onViewWillDisappear
        viewController.onViewDidDisappear = onViewDidDisappear

        return viewController
    }

    func updateUIViewController(
        _ uiViewController: LifecycleViewController,
        context: Context
    ) {
        uiViewController.onViewDidLoad = onViewDidLoad
        uiViewController.onViewWillAppear = onViewWillAppear
        uiViewController.onViewDidAppear = onViewDidAppear
        uiViewController.onViewWillDisappear = onViewWillDisappear
        uiViewController.onViewDidDisappear = onViewDidDisappear
    }
}
