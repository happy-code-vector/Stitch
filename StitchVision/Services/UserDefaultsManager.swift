import Foundation

class UserDefaultsManager {
    static let shared = UserDefaultsManager()
    
    private let defaults = UserDefaults.standard
    
    // Keys
    private enum Keys {
        static let hasCompletedOnboarding = "hasCompletedOnboarding"
        static let selectedCraft = "selectedCraft"
        static let skillLevel = "skillLevel"
        static let struggles = "struggles"
        static let habitFrequency = "habitFrequency"
        static let goal = "goal"
        static let isPro = "isPro"
        static let userEmail = "userEmail"
        static let userName = "userName"
    }
    
    // MARK: - Onboarding
    
    var hasCompletedOnboarding: Bool {
        get { defaults.bool(forKey: Keys.hasCompletedOnboarding) }
        set { defaults.set(newValue, forKey: Keys.hasCompletedOnboarding) }
    }
    
    var selectedCraft: String? {
        get { defaults.string(forKey: Keys.selectedCraft) }
        set { defaults.set(newValue, forKey: Keys.selectedCraft) }
    }
    
    var skillLevel: String? {
        get { defaults.string(forKey: Keys.skillLevel) }
        set { defaults.set(newValue, forKey: Keys.skillLevel) }
    }
    
    var struggles: [String] {
        get { defaults.stringArray(forKey: Keys.struggles) ?? [] }
        set { defaults.set(newValue, forKey: Keys.struggles) }
    }
    
    var habitFrequency: String? {
        get { defaults.string(forKey: Keys.habitFrequency) }
        set { defaults.set(newValue, forKey: Keys.habitFrequency) }
    }
    
    var goal: String? {
        get { defaults.string(forKey: Keys.goal) }
        set { defaults.set(newValue, forKey: Keys.goal) }
    }
    
    // MARK: - User Data
    
    var isPro: Bool {
        get { defaults.bool(forKey: Keys.isPro) }
        set { defaults.set(newValue, forKey: Keys.isPro) }
    }
    
    var userEmail: String? {
        get { defaults.string(forKey: Keys.userEmail) }
        set { defaults.set(newValue, forKey: Keys.userEmail) }
    }
    
    var userName: String? {
        get { defaults.string(forKey: Keys.userName) }
        set { defaults.set(newValue, forKey: Keys.userName) }
    }
    
    // MARK: - Methods
    
    func completeOnboarding(craft: String?, skill: String?, struggles: [String], frequency: String?, goal: String?) {
        self.selectedCraft = craft
        self.skillLevel = skill
        self.struggles = struggles
        self.habitFrequency = frequency
        self.goal = goal
        self.hasCompletedOnboarding = true
    }
    
    func resetOnboarding() {
        hasCompletedOnboarding = false
        selectedCraft = nil
        skillLevel = nil
        struggles = []
        habitFrequency = nil
        goal = nil
    }
    
    func clearAllData() {
        if let bundleID = Bundle.main.bundleIdentifier {
            defaults.removePersistentDomain(forName: bundleID)
        }
    }
}
