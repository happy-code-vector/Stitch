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
    case enhancedSubscription
    case authentication
    case freeVsProComparison
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
    @Published var currentScreen: ScreenType
    @Published var sessionData = SessionData(rowsKnit: 0, timeSpent: 0)
    @Published var isPro = false
    @Published var selectedProjectId: Int?
    
    // Onboarding data
    @Published var selectedCraft: String?
    @Published var skillLevel: String?
    @Published var struggles: [String] = []
    @Published var habitFrequency: String?
    @Published var goal: String?
    @Published var hasCameraPermission: Bool = false
    @Published var userName: String?
    @Published var userEmail: String?
    
    private let db = DatabaseManager.shared
    
    init() {
        // Initialize currentScreen first
        self.currentScreen = .splash
        
        // Migrate from UserDefaults to SQLite if needed
        migrateFromUserDefaults()
        
        // Load user data from database
        if let user = db.getUser() {
            self.currentScreen = user.hasCompletedOnboarding ? .dashboard : .splash
            self.isPro = user.isPro
            self.selectedCraft = user.craftType.isEmpty ? nil : user.craftType
            self.skillLevel = user.skillLevel.isEmpty ? nil : user.skillLevel
            self.struggles = user.struggles
            self.habitFrequency = user.habitFrequency.isEmpty ? nil : user.habitFrequency
            self.goal = user.goal.isEmpty ? nil : user.goal
            self.userName = user.name.isEmpty ? nil : user.name
            self.userEmail = user.email.isEmpty ? nil : user.email
        }
    }
    
    private func migrateFromUserDefaults() {
        let storage = UserDefaultsManager.shared
        
        // Check if we need to migrate
        if storage.hasCompletedOnboarding && db.getUser() == nil {
            let user = UserProfile(
                name: storage.userName ?? "",
                email: storage.userEmail ?? "",
                craftType: storage.selectedCraft ?? "",
                skillLevel: storage.skillLevel ?? "",
                struggles: storage.struggles,
                habitFrequency: storage.habitFrequency ?? "",
                goal: storage.goal ?? "",
                isPro: storage.isPro,
                hasCompletedOnboarding: storage.hasCompletedOnboarding
            )
            _ = db.saveUser(user)
        }
    }
    
    func navigateTo(_ screen: ScreenType) {
        currentScreen = screen
    }
    
    func updateSessionData(rowsKnit: Int, timeSpent: Int) {
        sessionData = SessionData(rowsKnit: rowsKnit, timeSpent: timeSpent)
    }
    
    // MARK: - Onboarding Methods
    
    func saveOnboardingData(craft: String?, skill: String?, struggles: [String], frequency: String?, goal: String?) {
        self.selectedCraft = craft
        self.skillLevel = skill
        self.struggles = struggles
        self.habitFrequency = frequency
        self.goal = goal
        
        // Save to database
        let user = UserProfile(
            name: userName ?? "",
            email: userEmail ?? "",
            craftType: craft ?? "",
            skillLevel: skill ?? "",
            struggles: struggles,
            habitFrequency: frequency ?? "",
            goal: goal ?? "",
            isPro: isPro,
            hasCompletedOnboarding: false
        )
        _ = db.saveUser(user)
    }
    
    func completeOnboarding() {
        _ = db.updateOnboardingStatus(completed: true)
        navigateTo(.dashboard)
    }
    
    func resetOnboarding() {
        _ = db.updateOnboardingStatus(completed: false)
        selectedCraft = nil
        skillLevel = nil
        struggles = []
        habitFrequency = nil
        goal = nil
        navigateTo(.splash)
    }
    
    // MARK: - Pro Status
    
    func updateProStatus(_ isPro: Bool) {
        self.isPro = isPro
        if var user = db.getUser() {
            user.isPro = isPro
            _ = db.saveUser(user)
        }
    }
    
    // MARK: - User Profile
    
    func updateUserProfile(name: String?, email: String?) {
        self.userName = name
        self.userEmail = email
        
        if var user = db.getUser() {
            user.name = name ?? ""
            user.email = email ?? ""
            _ = db.saveUser(user)
        } else {
            let user = UserProfile(
                name: name ?? "",
                email: email ?? "",
                craftType: selectedCraft ?? "",
                skillLevel: skillLevel ?? "",
                struggles: struggles,
                habitFrequency: habitFrequency ?? "",
                goal: goal ?? "",
                isPro: isPro,
                hasCompletedOnboarding: false
            )
            _ = db.saveUser(user)
        }
    }
    
    // MARK: - Camera Permission
    
    func checkCameraPermission() {
        let manager = CameraPermissionManager.shared
        manager.checkPermissionStatus()
        hasCameraPermission = manager.isPermissionGranted
    }
}

struct SessionData {
    let rowsKnit: Int
    let timeSpent: Int
}
