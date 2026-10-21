//
//  CameraScreen.swift
//  CleanArchitecture
//
//  Created by Sophearath.chhan on 10/6/26.
//

import SwiftUI
import AVFoundation

struct CameraDemoView: View {
    @StateObject private var camera = CameraManager()
    @State private var photo: UIImage?

    var body: some View {
        ZStack {
            if camera.isAuthorized {
                CameraPreview(session: camera.session)
                    .ignoresSafeArea()
            } else {
                Color.black.ignoresSafeArea()
                VStack(spacing: 12) {
                    Text(camera.error?.errorDescription ?? "Camera needed")
                        .foregroundStyle(.white)
                    Button("Open Settings") {
                        if let url = URL(string: UIApplication.openSettingsURLString) {
                            UIApplication.shared.open(url)
                        }
                    }
                }
            }

            VStack {
                HStack {
                    Button { camera.toggleFlash() } label: {
                        Image(systemName: flashIcon)
                    }
                    Spacer()
                    Button { camera.switchCamera() } label: {
                        Image(systemName: "arrow.triangle.2.circlepath.camera")
                    }
                }
                .font(.title2)
                .foregroundStyle(.white)
                .padding()

                Spacer()

                HStack {
                    if let photo {
                        Image(uiImage: photo)
                            .resizable().scaledToFill()
                            .frame(width: 60, height: 60)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                    }
                    Spacer()
                    Button {
                        Task { photo = try? await camera.capturePhoto() }
                    } label: {
                        Circle().strokeBorder(.white, lineWidth: 4)
                            .background(Circle().fill(.white.opacity(0.3)))
                            .frame(width: 72, height: 72)
                    }
                    Spacer()
                    Color.clear.frame(width: 60, height: 60)
                }
                .padding()
            }
        }
        .task { await camera.start() }
        .onDisappear { camera.stop() }
    }

    private var flashIcon: String {
        switch camera.flashMode {
        case .on:   return "bolt.fill"
        case .auto: return "bolt.badge.automatic.fill"
        default:    return "bolt.slash.fill"
        }
    }
}


import UIKit

final class QRDemoViewController: UIViewController {

    private let scanButton = UIButton(type: .system)
    private let resultLabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "QR Demo"
        view.backgroundColor = .systemBackground

        scanButton.setTitle("Scan QR", for: .normal)
        scanButton.titleLabel?.font = .preferredFont(forTextStyle: .title2)
        scanButton.addTarget(self, action: #selector(scanTapped), for: .touchUpInside)

        resultLabel.text = "No result yet"
        resultLabel.numberOfLines = 0
        resultLabel.textAlignment = .center
        resultLabel.textColor = .secondaryLabel

        let stack = UIStackView(arrangedSubviews: [scanButton, resultLabel])
        stack.axis = .vertical
        stack.spacing = 24
        stack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stack)

        NSLayoutConstraint.activate([
            stack.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24)
        ])
    }

    @objc private func scanTapped() {
        CameraPermissionManager.shared.ensureAccess(from: self) { [weak self] in
            self?.presentScanner()
        }
    }

    private func presentScanner() {
        let scanner = QRScannerViewController()
        scanner.delegate = self
        scanner.modalPresentationStyle = .fullScreen
        present(scanner, animated: true)
    }
}

extension QRDemoViewController: QRScannerDelegate {
    func qrScanner(_ scanner: QRScannerViewController, didScan code: String) {
        scanner.dismiss(animated: true) { [weak self] in
            self?.resultLabel.text = code
            self?.resultLabel.textColor = .label
        }
    }

    func qrScannerDidCancel(_ scanner: QRScannerViewController) {
        scanner.dismiss(animated: true)
    }
}
