import SwiftUI

enum ScreenType: CaseIterable {
    case splash
    case craft
    case skill
    case struggle
    case statsProblem
    case habit
    case goal
    case statsSolution
    case loading
    case result
    case howItWorks
    case stats
    case cameraPermissions
    case calibration
    case subscription
    case downsell
    case permissions
    case freeTierWelcome
    case dashboard
    case workMode
    case sessionSummary
    case settings
    case patternVerification
    case projectSetup
    case projectDetail
    case patternUpload
    case help
    case notifications
    case profile
}

class AppState: ObservableObject {
    @Published var currentScreen: ScreenType = .splash
    @Published var sessionData = SessionData(rowsKnit: 0, timeSpent: 0)
    @Published var isPro = false
    @Published var selectedProjectId: String?
    
    func navigateTo(_ screen: ScreenType) {
        currentScreen = screen
    }
    
    func updateSessionData(rowsKnit: Int, timeSpent: Int) {
        sessionData = SessionData(rowsKnit: rowsKnit, timeSpent: timeSpent)
    }
}

struct SessionData {
    let rowsKnit: Int
    let timeSpent: Int
}