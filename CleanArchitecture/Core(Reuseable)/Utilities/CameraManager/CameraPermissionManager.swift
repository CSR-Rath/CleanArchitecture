//
//  CameraPermissionManager.swift
//  CleanArchitecture
//
//  Created by Sophearath.chhan on 10/9/26.
//

import AVFoundation
import UIKit

enum CameraPermissionStatus {
    case authorized
    case notDetermined
    case denied      // user said no
    case restricted  // parental controls / MDM
    case unavailable // no camera (e.g. Simulator)
}

final class CameraPermissionManager {

    static let shared = CameraPermissionManager()
    private init() {}

    var status: CameraPermissionStatus {
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else { return .unavailable }
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:    return .authorized
        case .notDetermined: return .notDetermined
        case .denied:        return .denied
        case .restricted:    return .restricted
        @unknown default:    return .denied
        }
    }

    /// Requests access if needed. Completion is always called on the main thread.
    func requestAccess(completion: @escaping (CameraPermissionStatus) -> Void) {
        switch status {
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { [weak self] _ in
                DispatchQueue.main.async {
                    completion(self?.status ?? .denied)
                }
            }
        default:
            DispatchQueue.main.async { completion(self.status) }
        }
    }

    /// Convenience: runs `onAuthorized` if allowed, otherwise shows an alert
    /// with a shortcut to Settings when the user previously denied.
    func ensureAccess(from viewController: UIViewController,
                      onAuthorized: @escaping () -> Void) {
        requestAccess { status in
            switch status {
            case .authorized:
                onAuthorized()
            case .denied:
                self.presentSettingsAlert(on: viewController)
            case .restricted:
                self.presentSimpleAlert(on: viewController,
                                        title: "Camera Restricted",
                                        message: "Camera access is restricted on this device.")
            case .unavailable:
                self.presentSimpleAlert(on: viewController,
                                        title: "Camera Unavailable",
                                        message: "This device doesn't have a camera.")
            case .notDetermined:
                break
            }
        }
    }

    private func presentSettingsAlert(on vc: UIViewController) {
        let alert = UIAlertController(
            title: "Camera Access Needed",
            message: "Please enable camera access in Settings to scan QR codes.",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Open Settings", style: .default) { _ in
            if let url = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(url)
            }
        })
        vc.present(alert, animated: true)
    }

    private func presentSimpleAlert(on vc: UIViewController, title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        vc.present(alert, animated: true)
    }
}

