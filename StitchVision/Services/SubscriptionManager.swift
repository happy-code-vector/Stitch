import Foundation
import StoreKit
import Combine

/// Manages subscriptions using StoreKit 2
@MainActor
class SubscriptionManager: ObservableObject {

    // MARK: - Published Properties

    @Published var subscription: Subscription
    @Published var products: [Product] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    // MARK: - Product IDs

    static let monthlyProID = "com.stitchvision.pro.monthly"
    static let yearlyProID = "com.stitchvision.pro.yearly"

    // MARK: - Singleton

    static let shared = SubscriptionManager()

    private init() {
        self.subscription = Subscription()
        loadSubscription()
    }

    // MARK: - Public Methods

    /// Load products from App Store
    func loadProducts() async {
        isLoading = true
        errorMessage = nil

        do {
            let storeProducts = try await Product.products(for: [
                Self.monthlyProID,
                Self.yearlyProID
            ])
            products = Array(storeProducts)
            isLoading = false
        } catch {
            errorMessage = "Failed to load products: \(error.localizedDescription)"
            isLoading = false
        }
    }

    /// Purchase a subscription
    func purchase(_ product: Product) async -> Bool {
        isLoading = true
        errorMessage = nil

        do {
            let result = try await product.purchase()

            switch result {
            case .success(let verification):
                switch verification {
                case .verified(let transaction):
                    await updateSubscription(from: transaction)
                    await transaction.finish()
                    isLoading = false
                    return true
                case .unverified(_, _):
                    errorMessage = "Transaction verification failed"
                    isLoading = false
                    return false
                }

            case .userCancelled:
                isLoading = false
                return false

            case .pending:
                errorMessage = "Purchase is pending approval"
                isLoading = false
                return false

            @unknown default:
                errorMessage = "Unknown purchase result"
                isLoading = false
                return false
            }
        } catch {
            errorMessage = "Purchase failed: \(error.localizedDescription)"
            isLoading = false
            return false
        }
    }

    /// Restore previous purchases
    func restorePurchases() async {
        isLoading = true
        errorMessage = nil

        do {
            try await AppStore.sync()
            await checkSubscriptionStatus()
            isLoading = false
        } catch {
            errorMessage = "Restore failed: \(error.localizedDescription)"
            isLoading = false
        }
    }

    /// Check current subscription status
    func checkSubscriptionStatus() async {
        for await result in Transaction.currentEntitlements {
            switch result {
            case .verified(let transaction):
                if transaction.productID == Self.monthlyProID ||
                   transaction.productID == Self.yearlyProID {
                    await updateSubscription(from: transaction)
                    return
                }
            case .unverified(_, _):
                continue
            }
        }

        // No active subscription found
        subscription = Subscription(tier: .free, status: .inactive)
        saveSubscription()
    }

    // MARK: - Feature Gates

    /// Check if Pro features are available
    var isPro: Bool {
        return subscription.isPro
    }

    /// Check if AI Coach is available
    var canUseAICoach: Bool {
        return subscription.isPro
    }

    /// Check if cloud sync is available
    var canUseCloudSync: Bool {
        return subscription.isPro
    }

    /// Get maximum patterns allowed
    var maxPatterns: Int {
        return subscription.isPro ? Int.max : 3
    }

    /// Get maximum markers per session
    var maxMarkersPerSession: Int {
        return subscription.isPro ? Int.max : 5
    }

    // MARK: - Private Methods

    private func updateSubscription(from transaction: Transaction) async {
        let tier: SubscriptionTier = (transaction.productID == Self.monthlyProID ||
                                       transaction.productID == Self.yearlyProID) ? .pro : .free

        let status: SubscriptionStatus
        if let expiry = transaction.expirationDate {
            if expiry > Date() {
                status = .active
            } else {
                status = .expired
            }
        } else {
            status = .active
        }

        subscription = Subscription(
            tier: tier,
            status: status,
            startDate: transaction.purchaseDate,
            expiryDate: transaction.expirationDate,
            autoRenew: true, // Would need to check renewal status
            productId: transaction.productID
        )

        saveSubscription()
    }

    private func loadSubscription() {
        guard let data = UserDefaults.standard.data(forKey: "subscription"),
              let savedSubscription = try? JSONDecoder().decode(Subscription.self, from: data) else {
            subscription = Subscription()
            return
        }
        subscription = savedSubscription
    }

    private func saveSubscription() {
        guard let data = try? JSONEncoder().encode(subscription) else { return }
        UserDefaults.standard.set(data, forKey: "subscription")
    }
}
