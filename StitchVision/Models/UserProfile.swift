import Foundation

struct UserProfile {
    var id: Int?
    var name: String
    var email: String
    var craftType: String
    var skillLevel: String
    var struggles: [String]
    var habitFrequency: String
    var goal: String
    var isPro: Bool
    var hasCompletedOnboarding: Bool
    
    init(
        id: Int? = nil,
        name: String = "",
        email: String = "",
        craftType: String = "",
        skillLevel: String = "",
        struggles: [String] = [],
        habitFrequency: String = "",
        goal: String = "",
        isPro: Bool = false,
        hasCompletedOnboarding: Bool = false
    ) {
        self.id = id
        self.name = name
        self.email = email
        self.craftType = craftType
        self.skillLevel = skillLevel
        self.struggles = struggles
        self.habitFrequency = habitFrequency
        self.goal = goal
        self.isPro = isPro
        self.hasCompletedOnboarding = hasCompletedOnboarding
    }
}
