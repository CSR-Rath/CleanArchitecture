//
//  SessionTimeoutManager.swift
//  CleanArchitecture
//
//  Created by Sophearath.chhan on 10/21/26.
//

import UIKit

@MainActor
final class SessionTimeoutManager {
    
    static let shared = SessionTimeoutManager()
    
    /// Called when the session times out and PIN/Lock screen must be displayed.
    var onTimeout: (() -> Void)?
    
    private var expiryDate: Date?
    private var timer: Timer?
    
    private init() {}
    
    /// Automatically accounts for time elapsed while in background or locked.
    var remainingTime: Int {
        guard let expiryDate else { return 0 }
        return max(0, Int(expiryDate.timeIntervalSinceNow.rounded(.up)))
    }
    
    var isSessionAlive: Bool {
        remainingTime > 0
    }
    
    // MARK: - Lifecycle Controls
    
    /// Resets and starts the countdown timer (e.g., after login or active touch).
    func resetSession() {
        let timeout: TimeInterval = 30 // Can be fetched from UserDefaults
        expiryDate = Date().addingTimeInterval(timeout)
        startTimer()
    }
    
    /// Fully stops the session (e.g., on manual logout).
    func stopSession() {
        timer?.invalidate()
        timer = nil
        expiryDate = nil
    }
    
    /// Extends the session if it is still valid.
    func userDidInteract() {
        guard isSessionAlive else { return }
        resetSession()
    }
    
    /// Call this from SceneDelegate or AppDelegate when the app becomes active.
    func checkSessionOnForeground() {
        guard expiryDate != nil else { return }
        if !isSessionAlive {
            sessionTimeout()
        }
    }
    
    // MARK: - Timer Handling
    private func startTimer() {
        timer?.invalidate()
        
        let newTimer = Timer(timeInterval: 1.0, repeats: true) { [weak self] _ in
            Task { @MainActor [weak self] in
                guard let self else { return }
                if !self.isSessionAlive {
                    self.sessionTimeout()
                }
            }
        }
        RunLoop.main.add(newTimer, forMode: .common)
        self.timer = newTimer
    }
    
    // MARK: - Timeout Action
    private var shouldForcePIN: Bool {
        TopScreen.shared.isHomeScreen
    }
    
    private func sessionTimeout() {
        timer?.invalidate()
        timer = nil
        expiryDate = nil
        
        guard shouldForcePIN else { return }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) { [weak self] in
            self?.onTimeout?()
        }
    }
}
