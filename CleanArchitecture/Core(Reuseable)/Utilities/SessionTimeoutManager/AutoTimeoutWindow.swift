//
//  AutoTimeoutWindow.swift
//  CleanArchitecture
//
//  Created by Sophearath.chhan on 10/21/26.
//

import UIKit

final class AutoTimeoutWindow: UIWindow {
    
    
    override func sendEvent(_ event: UIEvent) {
        super.sendEvent(event)
        
        if let touches = event.allTouches, touches.contains(where: { $0.phase == .began }) {
            SessionTimeoutManager.shared.userDidInteract()
        }
    }
}
