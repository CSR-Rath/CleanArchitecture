//
//  QRScannerViewController.swift
//  CleanArchitecture
//
//  Created by Sophearath.chhan on 10/9/26.
//

import AVFoundation
import PhotosUI
import UIKit
import Vision

protocol QRScannerDelegate: AnyObject {
    func qrScanner(_ scanner: QRScannerViewController, didScan code: String)
    func qrScannerDidCancel(_ scanner: QRScannerViewController)
}

final class QRScannerViewController: UIViewController {

    weak var delegate: QRScannerDelegate?

    private let session = AVCaptureSession()
    private let sessionQueue = DispatchQueue(label: "qr.scanner.session")
    private let metadataOutput = AVCaptureMetadataOutput()
    private var previewLayer: AVCaptureVideoPreviewLayer!
    private var hasScanned = false

    /// 1.0 = no zoom. A little zoom helps with small or distant QR codes.
    private let zoomFactor: CGFloat = 1

    private let frameView = UIView()
    private let hintLabel = UILabel()
    private let closeButton = UIButton(type: .system)
    private let uploadButton = UIButton(type: .system)
    
    var isScanBarCode: Bool = true

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        configureSession()
        configureUI()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        hasScanned = false
        sessionQueue.async { [weak self, session] in
            if !session.isRunning { session.startRunning() }
            // The coordinate conversion is only accurate once the session is running.
            DispatchQueue.main.async { self?.updateRectOfInterest() }
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sessionQueue.async { [session] in
            if session.isRunning { session.stopRunning() }
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        previewLayer?.frame = view.bounds
        updateRectOfInterest()
    }

    // MARK: - Scan area & zoom

    /// Only detect QR codes that are inside the green frame.
    private func updateRectOfInterest() {
        guard previewLayer != nil, !frameView.frame.isEmpty else { return }
        metadataOutput.rectOfInterest = previewLayer.metadataOutputRectConverted(
            fromLayerRect: frameView.frame
        )
    }

    private func applyZoom(to device: AVCaptureDevice) {
        let maxZoom = device.activeFormat.videoMaxZoomFactor
        let factor = min(max(zoomFactor, 1.0), maxZoom)
        do {
            try device.lockForConfiguration()
            device.videoZoomFactor = factor
            device.unlockForConfiguration()
        } catch {
            print("Could not set zoom: \(error)")
        }
    }

    // MARK: - Setup

    private func configureSession() {
        guard let device = AVCaptureDevice.default(for: .video),
              let input = try? AVCaptureDeviceInput(device: device),
              session.canAddInput(input) else { return }
        session.addInput(input)

        applyZoom(to: device)

        guard session.canAddOutput(metadataOutput) else { return }
        session.addOutput(metadataOutput)
        metadataOutput.setMetadataObjectsDelegate(self, queue: .main)
        
        if isScanBarCode{
            let supported: [AVMetadataObject.ObjectType] = [
                .qr, .ean13, .ean8, .upce,
                .code128, .code39, .code93,
                .itf14, .interleaved2of5,
                .pdf417, .aztec, .dataMatrix
            ]
            metadataOutput.metadataObjectTypes = supported.filter {
                metadataOutput.availableMetadataObjectTypes.contains($0)
            }
        }else{
            metadataOutput.metadataObjectTypes = [.qr]
        }
    
        previewLayer = AVCaptureVideoPreviewLayer(session: session)
        previewLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(previewLayer)
    }

    private func configureUI() {
        frameView.layer.borderColor = UIColor.systemGreen.cgColor
        frameView.layer.borderWidth = 3
        frameView.layer.cornerRadius = 16
        frameView.translatesAutoresizingMaskIntoConstraints = false

        hintLabel.text = "Point the camera at a QR code"
        hintLabel.textColor = .white
        hintLabel.font = .preferredFont(forTextStyle: .headline)
        hintLabel.translatesAutoresizingMaskIntoConstraints = false

        closeButton.setTitle("Cancel", for: .normal)
        closeButton.setTitleColor(.white, for: .normal)
        closeButton.addTarget(self, action: #selector(cancelTapped), for: .touchUpInside)
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        
        
        var config = UIButton.Configuration.filled()
        config.title = "Upload Image"
        config.image = UIImage(systemName: "photo")
        config.imagePadding = 8
        config.cornerStyle = .capsule
        config.baseBackgroundColor = .white.withAlphaComponent(0.2)
        config.baseForegroundColor = .white
        uploadButton.configuration = config
        uploadButton.addTarget(self, action: #selector(uploadTapped), for: .touchUpInside)
        uploadButton.translatesAutoresizingMaskIntoConstraints = false

        [frameView, hintLabel, closeButton, uploadButton].forEach(view.addSubview)


        NSLayoutConstraint.activate([
            frameView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            frameView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            frameView.widthAnchor.constraint(equalToConstant: 250),
            frameView.heightAnchor.constraint(equalToConstant: 250),

            hintLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            hintLabel.topAnchor.constraint(equalTo: frameView.bottomAnchor, constant: 24),

            closeButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            
            uploadButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            uploadButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -32),
            uploadButton.heightAnchor.constraint(equalToConstant: 48),
            uploadButton.widthAnchor.constraint(greaterThanOrEqualToConstant: 180)
        ])
    }

    @objc private func cancelTapped() {
        delegate?.qrScannerDidCancel(self)
    }
    
    
    // Inside QRScannerViewController
    @objc private func uploadTapped() {
        hasScanned = true // pause live scanning while the picker is open

        var config = PHPickerConfiguration()
        config.filter = .images
        config.selectionLimit = 1

        let picker = PHPickerViewController(configuration: config)
        picker.delegate = self
        present(picker, animated: true)
    }

    private func detectQR(in image: UIImage) {
        guard let cgImage = image.cgImage else {
            DispatchQueue.main.async { self.showNoQRFound() }
            return
        }

        let request = VNDetectBarcodesRequest()
        
        if !isScanBarCode{
            request.symbologies = [.qr]
        }
       

        let handler = VNImageRequestHandler(
            cgImage: cgImage,
            orientation: CGImagePropertyOrientation(image.imageOrientation),
            options: [:]
        )

        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            try? handler.perform([request])
            let value = request.results?.compactMap { $0.payloadStringValue }.first

            DispatchQueue.main.async {
                guard let self else { return }
                if let value {
                    UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                    self.delegate?.qrScanner(self, didScan: value)
                } else {
                    self.showNoQRFound()
                }
            }
        }
    }

    private func showNoQRFound() {
        let alert = UIAlertController(
            title: "No QR code found",
            message: "Please choose an image that contains a clear QR code.",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default) { [weak self] _ in
            self?.hasScanned = false // resume live scanning
        })
        present(alert, animated: true)
    }
    
}

// MARK: - AVCaptureMetadataOutputObjectsDelegate
extension QRScannerViewController: AVCaptureMetadataOutputObjectsDelegate {
    func metadataOutput(_ output: AVCaptureMetadataOutput,
                        didOutput metadataObjects: [AVMetadataObject],
                        from connection: AVCaptureConnection) {
        guard !hasScanned,
              let object = metadataObjects.first as? AVMetadataMachineReadableCodeObject,
              let value = object.stringValue else { return }

        hasScanned = true
        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        delegate?.qrScanner(self, didScan: value)
    }
}


// MARK: - PHPickerViewControllerDelegate
extension QRScannerViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)

        guard let provider = results.first?.itemProvider,
              provider.canLoadObject(ofClass: UIImage.self) else {
            hasScanned = false // user cancelled, resume camera
            return
        }

        provider.loadObject(ofClass: UIImage.self) { [weak self] object, _ in
            guard let image = object as? UIImage else {
                DispatchQueue.main.async { self?.hasScanned = false }
                return
            }
            self?.detectQR(in: image)
        }
    }
}


extension CGImagePropertyOrientation {
    init(_ uiOrientation: UIImage.Orientation) {
        switch uiOrientation {
        case .up: self = .up
        case .upMirrored: self = .upMirrored
        case .down: self = .down
        case .downMirrored: self = .downMirrored
        case .left: self = .left
        case .leftMirrored: self = .leftMirrored
        case .right: self = .right
        case .rightMirrored: self = .rightMirrored
        @unknown default: self = .up
        }
    }
}


import SwiftUI

struct QRScannerView: UIViewControllerRepresentable {
    var isScanBarCode: Bool = true
    var onScan: (String) -> Void
    var onCancel: () -> Void

    func makeUIViewController(context: Context) -> QRScannerViewController {
        let vc = QRScannerViewController()
        vc.isScanBarCode = isScanBarCode   // set before viewDidLoad runs
        vc.delegate = context.coordinator
        return vc
    }

    func updateUIViewController(_ uiViewController: QRScannerViewController, context: Context) {
        // Keep the coordinator's closures fresh
        context.coordinator.parent = self
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    final class Coordinator: NSObject, QRScannerDelegate {
        var parent: QRScannerView

        init(_ parent: QRScannerView) {
            self.parent = parent
        }

        func qrScanner(_ scanner: QRScannerViewController, didScan code: String) {
            parent.onScan(code)
        }

        func qrScannerDidCancel(_ scanner: QRScannerViewController) {
            parent.onCancel()
        }
    }
}


struct QRScannerSwiftUIView: View {
    @State private var showScanner = false
    @State private var scannedCode: String?

    var body: some View {
        VStack(spacing: 20) {
            Text(scannedCode ?? "Nothing scanned yet")

            Button("Scan QR") {
                showScanner = true
            }
        }
        .fullScreenCover(isPresented: $showScanner) {
            QRScannerView(
                isScanBarCode: false,          // QR only
                onScan: { code in
                    print("code: \(code)")
                    scannedCode = code
                    showScanner = false        // dismiss
                },
                onCancel: {
                    showScanner = false
                }
            )
            .ignoresSafeArea()
        }
    }
}
