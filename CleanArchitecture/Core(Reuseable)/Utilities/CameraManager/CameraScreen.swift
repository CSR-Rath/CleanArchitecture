//
//  CameraScreen.swift
//  CleanArchitecture
//
//  Created by Sophearath.chhan on 10/6/26.
//

import SwiftUI

struct CameraScreen: View {

    @StateObject private var camera = CameraManager()

    var body: some View {

        ZStack {
            
            Color.orange.ignoresSafeArea()

            CameraPreview(
                session: camera.session
            )
            .ignoresSafeArea()

            VStack {

                Spacer()

                HStack(spacing: 30) {

                    Button {
                        camera.switchCamera()
                    } label: {
                        Image(
                            systemName:
                                "camera.rotate"
                        )
                    }

                    Button {
                        camera.toggleFlash()
                    } label: {
                        Image(
                            systemName:
                                camera.isFlashOn
                                ? "bolt.fill"
                                : "bolt.slash"
                        )
                    }

                    Button {
                        camera.takePhoto()
                    } label: {
                        Image(
                            systemName:
                                "circle.fill"
                        )
                        .font(.system(size: 60))
                    }
                }
                .foregroundColor(.white)
                .padding()
            }
        }
        .onAppear {

            camera.requestPermission()
            camera.start()
        }
        .onDisappear {

            camera.stop()
        }
        .onChange(
            of: camera.scannedQRCode
        ) { value in

            guard let value else {
                return
            }

            handleQRCode(value)
        }
    }

    private func handleQRCode(
        _ value: String
    ) {

        print("QR RESULT:", value)

        // Your QR business logic
    }
}
