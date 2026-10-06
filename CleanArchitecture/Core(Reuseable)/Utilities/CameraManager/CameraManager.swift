//
//  CameraManager.swift
//  CleanArchitecture
//
//  Created by Sophearath.chhan on 10/6/26.
//

import SwiftUI
import UIKit
import AVFoundation
import CoreImage
import PhotosUI
import Combine

// MARK: - Camera Manager

final class CameraManager: NSObject, ObservableObject {

    // MARK: Session

    let session = AVCaptureSession()

    // MARK: Outputs

    let photoOutput = AVCapturePhotoOutput()
    let metadataOutput = AVCaptureMetadataOutput()

    // MARK: Input

    var videoInput: AVCaptureDeviceInput?

    // MARK: State

    @Published var isRunning = false
    @Published var isConfigured = false

    @Published var isUsingFrontCamera = false
    @Published var isFlashOn = false

    @Published var zoom: CGFloat = 1.0

    @Published var capturedImage: UIImage?
    @Published var scannedQRCode: String?

    @Published var cameraPermissionDenied = false
    
    
    deinit{
        stop()
    }
    

    // MARK: Configuration

    func configure() {

        guard !isConfigured else {
            return
        }

        guard AVCaptureDevice.authorizationStatus(
            for: .video
        ) == .authorized else {
            requestPermission()
            return
        }

        session.beginConfiguration()

        session.sessionPreset = .photo

        setupCameraInput()
        setupPhotoOutput()
        setupQRCodeOutput()

        session.commitConfiguration()

        DispatchQueue.main.async {
            self.isConfigured = true
        }
    }
}


// MARK: - Permission

extension CameraManager {

    func requestPermission() {

        switch AVCaptureDevice.authorizationStatus(
            for: .video
        ) {

        case .authorized:

            configure()

        case .notDetermined:

            AVCaptureDevice.requestAccess(
                for: .video
            ) { [weak self] granted in

                DispatchQueue.main.async {

                    if granted {
                        self?.configure()
                    } else {
                        self?.cameraPermissionDenied = true
                    }
                }
            }

        case .denied, .restricted:

            cameraPermissionDenied = true

        @unknown default:
            break
        }
    }
}


// MARK: - Camera Input

extension CameraManager {

    func setupCameraInput(
        position: AVCaptureDevice.Position = .back
    ) {

        guard let device = AVCaptureDevice.default(
            .builtInWideAngleCamera,
            for: .video,
            position: position
        ) else {
            return
        }

        do {

            let input = try AVCaptureDeviceInput(
                device: device
            )

            guard session.canAddInput(input) else {
                return
            }

            session.addInput(input)

            videoInput = input

            isUsingFrontCamera =
                position == .front

        } catch {

            print(
                "Camera input error:",
                error.localizedDescription
            )
        }
    }
}


// MARK: - Photo Output

extension CameraManager {

    func setupPhotoOutput() {

        guard session.canAddOutput(
            photoOutput
        ) else {
            return
        }

        session.addOutput(photoOutput)

        photoOutput.isHighResolutionCaptureEnabled = true
    }

    func takePhoto() {

        let settings = AVCapturePhotoSettings()

        if let device = videoInput?.device,
           device.hasFlash {

            settings.flashMode =
                isFlashOn ? .on : .off
        }

        photoOutput.capturePhoto(
            with: settings,
            delegate: self
        )
    }
}


// MARK: - Photo Capture Delegate

extension CameraManager:
    AVCapturePhotoCaptureDelegate {

    func photoOutput(
        _ output: AVCapturePhotoOutput,
        didFinishProcessingPhoto photo: AVCapturePhoto,
        error: Error?
    ) {

        if let error {

            print(
                "Capture error:",
                error.localizedDescription
            )

            return
        }

        guard
            let data = photo.fileDataRepresentation(),
            let image = UIImage(data: data)
        else {
            return
        }

        DispatchQueue.main.async {

            self.capturedImage = image
        }
    }
}


// MARK: - QR Code

extension CameraManager {

    func setupQRCodeOutput() {

        guard session.canAddOutput(
            metadataOutput
        ) else {
            return
        }

        session.addOutput(metadataOutput)

        metadataOutput.setMetadataObjectsDelegate(
            self,
            queue: .main
        )

        metadataOutput.metadataObjectTypes = [
            .qr
        ]
    }

    func resetQRCode() {

        scannedQRCode = nil
    }
}


// MARK: - QR Metadata Delegate

extension CameraManager:
    AVCaptureMetadataOutputObjectsDelegate {

    func metadataOutput(
        _ output: AVCaptureMetadataOutput,
        didOutput metadataObjects: [AVMetadataObject],
        from connection: AVCaptureConnection
    ) {

        guard
            let object =
                metadataObjects.first
                as? AVMetadataMachineReadableCodeObject,
            let value = object.stringValue
        else {
            return
        }

        guard scannedQRCode == nil else {
            return
        }

        scannedQRCode = value

        print("QR Code:", value)
    }
}


// MARK: - Start / Stop

extension CameraManager {

    func start() {

        guard isConfigured else {
            configure()
            return
        }

        guard !session.isRunning else {
            return
        }

        DispatchQueue.global(
            qos: .userInitiated
        ).async {

            self.session.startRunning()

            DispatchQueue.main.async {
                self.isRunning = true
            }
        }
    }

    func stop() {

        guard session.isRunning else {
            return
        }

        DispatchQueue.global(
            qos: .userInitiated
        ).async {

            self.session.stopRunning()

            DispatchQueue.main.async {
                self.isRunning = false
            }
        }
    }
}


// MARK: - Camera Switch

extension CameraManager {

    func switchCamera() {

        guard let currentInput = videoInput else {
            return
        }

        let currentPosition =
            currentInput.device.position

        let newPosition:
            AVCaptureDevice.Position =
            currentPosition == .back
            ? .front
            : .back

        guard let device =
            AVCaptureDevice.default(
                .builtInWideAngleCamera,
                for: .video,
                position: newPosition
            )
        else {
            return
        }

        do {

            let newInput =
                try AVCaptureDeviceInput(
                    device: device
                )

            session.beginConfiguration()

            session.removeInput(currentInput)

            if session.canAddInput(newInput) {

                session.addInput(newInput)

                videoInput = newInput

                isUsingFrontCamera =
                    newPosition == .front
            } else {

                session.addInput(currentInput)
            }

            session.commitConfiguration()

        } catch {

            print(
                "Switch camera error:",
                error.localizedDescription
            )
        }
    }
}


// MARK: - Flash

extension CameraManager {

    func toggleFlash() {

        guard
            let device = videoInput?.device,
            device.hasTorch
        else {
            return
        }

        do {

            try device.lockForConfiguration()

            if device.torchMode == .on {

                device.torchMode = .off
                isFlashOn = false

            } else {

                device.torchMode = .on
                isFlashOn = true
            }

            device.unlockForConfiguration()

        } catch {

            print(
                "Flash error:",
                error.localizedDescription
            )
        }
    }
}


// MARK: - Zoom

extension CameraManager {

    func setZoom(
        _ value: CGFloat
    ) {

        guard let device = videoInput?.device else {
            return
        }

        let maxZoom =
            min(
                device.activeFormat.videoMaxZoomFactor,
                10.0
            )

        let newZoom =
            max(
                1.0,
                min(value, maxZoom)
            )

        do {

            try device.lockForConfiguration()

            device.videoZoomFactor = newZoom

            device.unlockForConfiguration()

            DispatchQueue.main.async {
                self.zoom = newZoom
            }

        } catch {

            print(
                "Zoom error:",
                error.localizedDescription
            )
        }
    }

    func zoomIn() {

        setZoom(
            zoom + 0.5
        )
    }

    func zoomOut() {

        setZoom(
            zoom - 0.5
        )

    }

    func resetZoom() {

        setZoom(1.0)
    }
}


// MARK: - Upload QR Image

extension CameraManager {

    func scanQRCode(
        from image: UIImage
    ) -> String? {

        guard
            let ciImage = CIImage(
                image: image
            )
        else {
            return nil
        }

        let detector = CIDetector(
            ofType: CIDetectorTypeQRCode,
            context: CIContext(),
            options: [
                CIDetectorAccuracy:
                    CIDetectorAccuracyHigh
            ]
        )

        let features =
            detector?.features(
                in: ciImage
            )

        return features?
            .compactMap {
                ($0 as? CIQRCodeFeature)?
                    .messageString
            }
            .first
    }

    func handleUploadedImage(
        _ image: UIImage
    ) {

        capturedImage = image

        guard let qrValue =
            scanQRCode(from: image)
        else {

            print("QR Code not found")

            return
        }

        scannedQRCode = qrValue

        print(
            "Uploaded QR:",
            qrValue
        )
    }
}


// MARK: - Cleanup

extension CameraManager {

    func cleanup() {

        stop()

        scannedQRCode = nil
        capturedImage = nil

        isFlashOn = false
        zoom = 1.0
    }

//    deinit {
//
//        stop()
//    }
}



