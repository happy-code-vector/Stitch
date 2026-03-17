import Foundation

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
        case .pro: return "$4.99/mo"
        }
    }

    var features: [String] {
        switch self {
        case .free:
            return [
                "On-device row counting",
                "Voice commands",
                "Pattern import (3 patterns)",
                "Basic progress tracking"
            ]
        case .pro:
            return [
                "AI Coach with tension analysis",
                "Mistake detection",
                "Unlimited patterns",
                "Cloud sync",
                "Advanced analytics",
                "Priority support"
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
