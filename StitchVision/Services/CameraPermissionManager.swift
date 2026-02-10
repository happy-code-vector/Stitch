import AVFoundation
import UIKit

class CameraPermissionManager: ObservableObject {
    static let shared = CameraPermissionManager()
    
    @Published var permissionStatus: PermissionStatus = .notDetermined
    
    enum PermissionStatus {
        case notDetermined
        case granted
        case denied
        case restricted
    }
    
    init() {
        checkPermissionStatus()
    }
    
    // MARK: - Check Current Status
    
    func checkPermissionStatus() {
        let status = AVCaptureDevice.authorizationStatus(for: .video)
        
        switch status {
        case .authorized:
            permissionStatus = .granted
        case .denied:
            permissionStatus = .denied
        case .restricted:
            permissionStatus = .restricted
        case .notDetermined:
            permissionStatus = .notDetermined
        @unknown default:
            permissionStatus = .notDetermined
        }
    }
    
    // MARK: - Request Permission
    
    func requestCameraPermission(completion: @escaping (Bool) -> Void) {
        AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
            DispatchQueue.main.async {
                if granted {
                    self?.permissionStatus = .granted
                } else {
                    self?.permissionStatus = .denied
                }
                completion(granted)
            }
        }
    }
    
    // MARK: - Open Settings
    
    func openAppSettings() {
        guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
            return
        }
        
        if UIApplication.shared.canOpenURL(settingsUrl) {
            UIApplication.shared.open(settingsUrl)
        }
    }
    
    // MARK: - Helper Methods
    
    var isPermissionGranted: Bool {
        return permissionStatus == .granted
    }
    
    var canRequestPermission: Bool {
        return permissionStatus == .notDetermined
    }
    
    var shouldShowSettingsPrompt: Bool {
        return permissionStatus == .denied
    }
}
