//
//  LifecycleViewController.swift
//  CleanArchitecture
//
//  Created by Sophearath.chhan on 10/6/26.
//
import SwiftUI

final class LifecycleViewController: UIViewController {

    var onViewDidLoad: (() -> Void)?
    var onViewWillAppear: (() -> Void)?
    var onViewDidAppear: (() -> Void)?
    var onViewWillDisappear: (() -> Void)?
    var onViewDidDisappear: (() -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear

        onViewDidLoad?()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        onViewWillAppear?()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        onViewDidAppear?()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        onViewWillDisappear?()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        onViewDidDisappear?()
    }
}
