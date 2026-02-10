import Foundation
import AVFoundation
import UIKit
import Combine

// MARK: - Camera Manager Delegate

protocol CameraManagerDelegate: AnyObject {
    func cameraManager(_ manager: CameraManager, didOutput sampleBuffer: CMSampleBuffer)
    func cameraManager(_ manager: CameraManager, didEncounterError error: Error)
}

// MARK: - Camera Manager

class CameraManager: NSObject, ObservableObject {
    
    // MARK: - Published Properties
    
    @Published var isSessionRunning = false
    @Published var isTorchOn = false
    @Published var previewLayer: AVCaptureVideoPreviewLayer?
    
    // MARK: - Properties
    
    weak var delegate: CameraManagerDelegate?
    
    private let captureSession = AVCaptureSession()
    private let sessionQueue = DispatchQueue(label: "com.stitchvision.camera")
    private var videoDeviceInput: AVCaptureDeviceInput?
    private let videoDataOutput = AVCaptureVideoDataOutput()
    private let videoDataOutputQueue = DispatchQueue(label: "com.stitchvision.videodata", qos: .userInitiated)
    
    // MARK: - Initialization
    
    override init() {
        super.init()
        setupCaptureSession()
    }
    
    // MARK: - Setup
    
    private func setupCaptureSession() {
        sessionQueue.async { [weak self] in
            guard let self = self else { return }
            
            self.captureSession.beginConfiguration()
            
            // Set session preset for optimal performance
            if self.captureSession.canSetSessionPreset(.high) {
                self.captureSession.sessionPreset = .high
            }
            
            // Setup video input
            self.setupVideoInput()
            
            // Setup video output
            self.setupVideoOutput()
            
            self.captureSession.commitConfiguration()
            
            // Create preview layer
            DispatchQueue.main.async {
                let preview = AVCaptureVideoPreviewLayer(session: self.captureSession)
                preview.videoGravity = .resizeAspectFill
                self.previewLayer = preview
            }
        }
    }
    
    private func setupVideoInput() {
        do {
            // Get back camera
            guard let videoDevice = AVCaptureDevice.default(
                .builtInWideAngleCamera,
                for: .video,
                position: .back
            ) else {
                print("Could not find back camera")
                return
            }
            
            // Configure device for optimal performance
            try videoDevice.lockForConfiguration()
            
            // Set frame rate to 30fps for balance between performance and accuracy
            if let format = selectOptimalFormat(for: videoDevice) {
                videoDevice.activeFormat = format
                videoDevice.activeVideoMinFrameDuration = CMTime(value: 1, timescale: 30)
                videoDevice.activeVideoMaxFrameDuration = CMTime(value: 1, timescale: 30)
            }
            
            // Enable auto focus and exposure
            if videoDevice.isFocusModeSupported(.continuousAutoFocus) {
                videoDevice.focusMode = .continuousAutoFocus
            }
            
            if videoDevice.isExposureModeSupported(.continuousAutoExposure) {
                videoDevice.exposureMode = .continuousAutoExposure
            }
            
            videoDevice.unlockForConfiguration()
            
            // Create input
            let videoDeviceInput = try AVCaptureDeviceInput(device: videoDevice)
            
            if captureSession.canAddInput(videoDeviceInput) {
                captureSession.addInput(videoDeviceInput)
                self.videoDeviceInput = videoDeviceInput
            }
            
        } catch {
            print("Could not create video device input: \(error)")
        }
    }
    
    private func setupVideoOutput() {
        // Configure video output
        videoDataOutput.videoSettings = [
            kCVPixelBufferPixelFormatTypeKey as String: Int(kCVPixelFormatType_420YpCbCr8BiPlanarFullRange)
        ]
        
        videoDataOutput.alwaysDiscardsLateVideoFrames = true
        videoDataOutput.setSampleBufferDelegate(self, queue: videoDataOutputQueue)
        
        if captureSession.canAddOutput(videoDataOutput) {
            captureSession.addOutput(videoDataOutput)
            
            // Set video orientation
            if let connection = videoDataOutput.connection(with: .video) {
                if connection.isVideoOrientationSupported {
                    connection.videoOrientation = .portrait
                }
            }
        }
    }
    
    private func selectOptimalFormat(for device: AVCaptureDevice) -> AVCaptureDevice.Format? {
        // Select format with 1280x720 resolution for optimal performance
        let formats = device.formats.filter { format in
            let dimensions = CMVideoFormatDescriptionGetDimensions(format.formatDescription)
            return dimensions.width == 1280 && dimensions.height == 720
        }
        
        return formats.first ?? device.activeFormat
    }
    
    // MARK: - Session Control
    
    func startSession() {
        sessionQueue.async { [weak self] in
            guard let self = self else { return }
            
            if !self.captureSession.isRunning {
                self.captureSession.startRunning()
                
                DispatchQueue.main.async {
                    self.isSessionRunning = true
                }
            }
        }
    }
    
    func stopSession() {
        sessionQueue.async { [weak self] in
            guard let self = self else { return }
            
            if self.captureSession.isRunning {
                self.captureSession.stopRunning()
                
                DispatchQueue.main.async {
                    self.isSessionRunning = false
                }
            }
        }
    }
    
    // MARK: - Torch Control
    
    func toggleTorch() {
        sessionQueue.async { [weak self] in
            guard let self = self,
                  let device = self.videoDeviceInput?.device,
                  device.hasTorch else {
                return
            }
            
            do {
                try device.lockForConfiguration()
                
                if device.torchMode == .off {
                    try device.setTorchModeOn(level: 1.0)
                    DispatchQueue.main.async {
                        self.isTorchOn = true
                    }
                } else {
                    device.torchMode = .off
                    DispatchQueue.main.async {
                        self.isTorchOn = false
                    }
                }
                
                device.unlockForConfiguration()
            } catch {
                print("Torch error: \(error)")
            }
        }
    }
    
    func setTorch(on: Bool) {
        sessionQueue.async { [weak self] in
            guard let self = self,
                  let device = self.videoDeviceInput?.device,
                  device.hasTorch else {
                return
            }
            
            do {
                try device.lockForConfiguration()
                
                if on {
                    try device.setTorchModeOn(level: 1.0)
                } else {
                    device.torchMode = .off
                }
                
                device.unlockForConfiguration()
                
                DispatchQueue.main.async {
                    self.isTorchOn = on
                }
            } catch {
                print("Torch error: \(error)")
            }
        }
    }
    
    // MARK: - Focus Control
    
    func focus(at point: CGPoint) {
        sessionQueue.async { [weak self] in
            guard let self = self,
                  let device = self.videoDeviceInput?.device else {
                return
            }
            
            do {
                try device.lockForConfiguration()
                
                if device.isFocusPointOfInterestSupported {
                    device.focusPointOfInterest = point
                    device.focusMode = .autoFocus
                }
                
                if device.isExposurePointOfInterestSupported {
                    device.exposurePointOfInterest = point
                    device.exposureMode = .autoExpose
                }
                
                device.unlockForConfiguration()
            } catch {
                print("Focus error: \(error)")
            }
        }
    }
}

// MARK: - AVCaptureVideoDataOutputSampleBufferDelegate

extension CameraManager: AVCaptureVideoDataOutputSampleBufferDelegate {
    
    func captureOutput(
        _ output: AVCaptureOutput,
        didOutput sampleBuffer: CMSampleBuffer,
        from connection: AVCaptureConnection
    ) {
        // Forward sample buffer to delegate
        delegate?.cameraManager(self, didOutput: sampleBuffer)
    }
    
    func captureOutput(
        _ output: AVCaptureOutput,
        didDrop sampleBuffer: CMSampleBuffer,
        from connection: AVCaptureConnection
    ) {
        // Handle dropped frames if needed
        print("Dropped frame")
    }
}
