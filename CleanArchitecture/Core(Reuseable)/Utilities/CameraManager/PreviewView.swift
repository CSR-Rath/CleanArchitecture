//
//  PreviewView.swift
//  CleanArchitecture
//
//  Created by Sophearath.chhan on 10/6/26.
//

import UIKit
import AVFoundation

final class PreviewView: UIView {

    override class var layerClass: AnyClass {
        AVCaptureVideoPreviewLayer.self
    }

    var videoPreviewLayer: AVCaptureVideoPreviewLayer {
        layer as! AVCaptureVideoPreviewLayer
    }
}
