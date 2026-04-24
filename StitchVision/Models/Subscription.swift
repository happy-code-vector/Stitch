import Foundation

/// Centralized pricing constants — single source of truth for all screens.
enum SubscriptionPricing {
    static let yearlyPrice: Double = 79.99
    static let monthlyPrice: Double = 12.99

    static let yearlyDisplay = "$79.99/year"
    static let monthlyDisplay = "$12.99/mo"
    static let yearlyPerMonthDisplay = "$6.67/mo"
    static let yearlyPerMonthAmount = "$6.67"

    static let yearlySavingsText = "Save 49%"
}

/// Subscription tier
enum SubscriptionTier: String, Codable, CaseIterable {
    case free = "free"
    case pro = "pro"

    var displayName: String {
        switch self {
        case .free: return "Free"
        case .pro: return "Pro"
        }
    }

    var price: String {
        switch self {
        case .free: return "Free"
        case .pro: return SubscriptionPricing.monthlyDisplay
        }
    }

    var features: [String] {
        switch self {
        case .free:
            return [
                "AI Row Counting (unlimited)",
                "1 Active Project",
                "Basic Stitch Doctor (3 lifetime)",
                "1 Pattern Upload (lifetime)",
                "StitchBot (10 questions/month)"
            ]
        case .pro:
            return [
                "AI Row Counting (unlimited)",
                "Unlimited Projects",
                "Advanced Stitch Doctor (50/month)",
                "Pattern Uploads (5/month)",
                "Unlimited StitchBot",
                "Cloud Sync",
                "Pattern Library Access"
            ]
        }
    }
}

/// Subscription status
enum SubscriptionStatus: String, Codable {
    case inactive = "inactive"
    case active = "active"
    case expired = "expired"
    case inGracePeriod = "in_grace_period"
    case inBillingRetry = "in_billing_retry"
}

/// Represents user's subscription state
struct Subscription: Codable {
    let id: UUID
    var tier: SubscriptionTier
    var status: SubscriptionStatus
    var startDate: Date?
    var expiryDate: Date?
    var autoRenew: Bool
    var productId: String?

    init(
        id: UUID = UUID(),
        tier: SubscriptionTier = .free,
        status: SubscriptionStatus = .inactive,
        startDate: Date? = nil,
        expiryDate: Date? = nil,
        autoRenew: Bool = false,
        productId: String? = nil
    ) {
        self.id = id
        self.tier = tier
        self.status = status
        self.startDate = startDate
        self.expiryDate = expiryDate
        self.autoRenew = autoRenew
        self.productId = productId
    }

    var isActive: Bool {
        switch status {
        case .active, .inGracePeriod:
            return tier == .pro
        case .inactive, .expired, .inBillingRetry:
            return false
        }
    }

    var isPro: Bool {
        return tier == .pro && isActive
    }

    var daysUntilExpiry: Int? {
        guard let expiry = expiryDate else { return nil }
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day], from: Date(), to: expiry)
        return components.day
    }
}
