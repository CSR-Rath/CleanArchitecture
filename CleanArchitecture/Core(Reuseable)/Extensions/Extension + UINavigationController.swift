//
//  Extension + UINavigationController.swift
//  CleanArchitecture
//
//  Created by Sophearath.chhan on 10/6/26.
//

import UIKit

/*
 
 Handles the navigation controller's swipe-back gesture
 and provides a global way to enable or disable it.
 This also manages the interactive pop gesture delegate
 and hides the default back navigation behavior when needed.
 
*/

final class NavigationSwipeManager {
    static let shared = NavigationSwipeManager()
    
    var isEnabled: Bool = true
    
    private init() {}
    
}


extension UINavigationController: @retroactive UIGestureRecognizerDelegate {
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = self
        interactivePopGestureRecognizer?.isEnabled = true
    }
    
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return viewControllers.count > 1 && NavigationSwipeManager.shared.isEnabled
    }
    
    public func gestureRecognizer(
        _ gestureRecognizer: UIGestureRecognizer,
        shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer
    ) -> Bool {
        return false
    }
}
