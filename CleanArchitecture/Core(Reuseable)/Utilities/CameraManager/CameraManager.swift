//
//  CameraManager.swift
//  CleanArchitecture
//
//  Created by Sophearath.chhan on 10/6/26.
//


import UIKit
import Combine
import AVFoundation

final class CameraManager: NSObject, ObservableObject {

    enum CameraError: LocalizedError {
        case permissionDenied
        case configurationFailed
        case captureFailed

        var errorDescription: String? {
            switch self {
            case .permissionDenied:     return "Camera access is denied. Enable it in Settings."
            case .configurationFailed:  return "Unable to configure the camera."
            case .captureFailed:        return "Unable to capture the photo."
            }
        }
    }

    // MARK: - Published state (always updated on main)
    @Published private(set) var isAuthorized = false
    @Published private(set) var isRunning = false
    @Published private(set) var position: AVCaptureDevice.Position = .back
    @Published var flashMode: AVCaptureDevice.FlashMode = .off
    @Published var error: CameraError?

    // MARK: - Capture objects
    let session = AVCaptureSession()
    private let photoOutput = AVCapturePhotoOutput()
    private let sessionQueue = DispatchQueue(label: "camera.session.queue")
    private var isConfigured = false
    private var inFlight: [Int64: PhotoDelegate] = [:]   // accessed on sessionQueue only

    // MARK: - Permission
    @discardableResult
    func requestPermission() async -> Bool {
        let granted: Bool
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            granted = true
        case .notDetermined:
            granted = await AVCaptureDevice.requestAccess(for: .video)
        default:
            granted = false
        }
        await MainActor.run {
            isAuthorized = granted
            if !granted { error = .permissionDenied }
        }
        return granted
    }

    // MARK: - Start / Stop
    func start() async {
        guard await requestPermission() else { return }

        sessionQueue.async { [weak self] in
            guard let self else { return }
            if !self.isConfigured { self.configureSession() }
            guard self.isConfigured else { return }

            if !self.session.isRunning { self.session.startRunning() }
            let running = self.session.isRunning
            DispatchQueue.main.async { self.isRunning = running }
        }
    }

    func stop() {
        sessionQueue.async { [weak self] in
            guard let self, self.session.isRunning else { return }
            self.session.stopRunning()
            DispatchQueue.main.async { self.isRunning = false }
        }
    }

    // MARK: - Configure (sessionQueue)
    private func configureSession() {
        session.beginConfiguration()
        defer { session.commitConfiguration() }

        session.sessionPreset = .photo

        guard
            let device = Self.device(for: .back),
            let input = try? AVCaptureDeviceInput(device: device),
            session.canAddInput(input),
            session.canAddOutput(photoOutput)
        else {
            DispatchQueue.main.async { self.error = .configurationFailed }
            return
        }

        session.addInput(input)
        session.addOutput(photoOutput)
        isConfigured = true
    }

    private static func device(for position: AVCaptureDevice.Position) -> AVCaptureDevice? {
        AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: position)
    }

    // MARK: - Switch camera
    func switchCamera() {
        sessionQueue.async { [weak self] in
            guard let self, self.isConfigured else { return }

            let newPosition: AVCaptureDevice.Position = self.position == .back ? .front : .back
            guard
                let device = Self.device(for: newPosition),
                let newInput = try? AVCaptureDeviceInput(device: device)
            else { return }

            self.session.beginConfiguration()
            self.session.inputs.forEach { self.session.removeInput($0) }

            if self.session.canAddInput(newInput) {
                self.session.addInput(newInput)
                DispatchQueue.main.async {
                    self.position = newPosition
                    if newPosition == .front { self.flashMode = .off }
                }
            } else if let old = Self.device(for: self.position),
                      let oldInput = try? AVCaptureDeviceInput(device: old),
                      self.session.canAddInput(oldInput) {
                self.session.addInput(oldInput)   // roll back
            }
            self.session.commitConfiguration()
        }
    }

    // MARK: - Flash
    func toggleFlash() {
        switch flashMode {
        case .off:  flashMode = .on
        case .on:   flashMode = .auto
        default:    flashMode = .off
        }
    }

    // MARK: - Capture
    func capturePhoto() async throws -> UIImage {
        try await withCheckedThrowingContinuation { continuation in
            sessionQueue.async { [weak self] in
                guard let self, self.session.isRunning else {
                    continuation.resume(throwing: CameraError.captureFailed)
                    return
                }

                let settings = AVCapturePhotoSettings()
                if self.photoOutput.supportedFlashModes.contains(self.flashMode) {
                    settings.flashMode = self.flashMode
                }

                let id = settings.uniqueID
                let delegate = PhotoDelegate { [weak self] result in
                    self?.sessionQueue.async { self?.inFlight[id] = nil }
                    continuation.resume(with: result)
                }
                self.inFlight[id] = delegate    // keep the delegate alive until finished
                self.photoOutput.capturePhoto(with: settings, delegate: delegate)
            }
        }
    }
}

// MARK: - Photo delegate
private nonisolated final class PhotoDelegate: NSObject,
                                               AVCapturePhotoCaptureDelegate,
                                               @unchecked Sendable {
    private let completion: @Sendable (Result<UIImage, Error>) -> Void

    init(completion: @escaping @Sendable (Result<UIImage, Error>) -> Void) {
        self.completion = completion
    }

    func photoOutput(_ output: AVCapturePhotoOutput,
                     didFinishProcessingPhoto photo: AVCapturePhoto,
                     error: Error?) {
        if let error {
            completion(.failure(error))
        } else if let data = photo.fileDataRepresentation(),
                  let image = UIImage(data: data) {
            completion(.success(image))
        } else {
            completion(.failure(CameraManager.CameraError.captureFailed))
        }
    }
}
