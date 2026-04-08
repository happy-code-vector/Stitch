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

    // Fix 1: Task handle for the Transaction.updates listener so it lives
    // for the full lifetime of the manager and can be cancelled in deinit.
    private var updatesListenerTask: Task<Void, Never>?

    private init() {
        // Fix 4: Read UserDefaults synchronously here before @MainActor
        // enforcement kicks in — this is safe because it's purely reading
        // a value type from UserDefaults, not touching any actor-isolated state.
        // We assign a temporary free subscription first, then overwrite below.
        self.subscription = Subscription()

        // Fix 4: Restore cached subscription on the main actor via a
        // detached task so init() itself doesn't violate actor isolation.
        Task { @MainActor in
            self.loadSubscription()
            // Fix 9: Load App Store products automatically on first init.
            await self.loadProducts()
            // Verify entitlements against StoreKit on every cold start.
            await self.checkSubscriptionStatus()
        }

        // Fix 1: Start listening for StoreKit transaction updates immediately.
        // This handles renewals, revocations, and purchases made outside the app.
        updatesListenerTask = Task(priority: .background) { [weak self] in
            for await result in Transaction.updates {
                guard let self else { break }
                switch result {
                case .verified(let transaction):
                    await self.updateSubscription(from: transaction)
                    await transaction.finish()
                case .unverified:
                    break
                }
            }
        }
    }

    deinit {
        updatesListenerTask?.cancel()
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
                    // Fix 8: Finish the transaction only after subscription
                    // state is persisted, so it isn't lost if the app crashes.
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
        var foundActiveSubscription = false

        for await result in Transaction.currentEntitlements {
            switch result {
            case .verified(let transaction):
                if transaction.productID == Self.monthlyProID ||
                   transaction.productID == Self.yearlyProID {
                    await updateSubscription(from: transaction)
                    foundActiveSubscription = true
                    return
                }
            case .unverified:
                continue
            }
        }

        // Fix 2: Only reset to free if we definitively found no active
        // entitlements. Don't reset if the loop simply yielded no results
        // due to a transient StoreKit issue.
        if !foundActiveSubscription {
            subscription = Subscription(tier: .free, status: .inactive)
            saveSubscription()
        }
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

    /// Get maximum StitchBot questions per month (Free: 10, Pro: unlimited)
    var maxStitchBotQuestionsPerMonth: Int {
        return subscription.isPro ? Int.max : 10
    }

    /// Check if StitchBot can be used
    var canUseStitchBot: Bool {
        return subscription.isPro || stitchBotQuestionsRemaining > 0
    }

    /// Get remaining StitchBot questions for free users
    var stitchBotQuestionsRemaining: Int {
        let used = stitchBotQuestionsUsedThisMonth
        return max(0, maxStitchBotQuestionsPerMonth - used)
    }

    /// Track StitchBot question usage
    func incrementStitchBotUsage() {
        let key = "stitchbot_questions_\(currentMonthKey)"
        let current = UserDefaults.standard.integer(forKey: key)
        UserDefaults.standard.set(current + 1, forKey: key)
    }

    // MARK: - StitchBot Usage Tracking

    private var currentMonthKey: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMM"
        return formatter.string(from: Date())
    }

    private var stitchBotQuestionsUsedThisMonth: Int {
        let key = "stitchbot_questions_\(currentMonthKey)"
        return UserDefaults.standard.integer(forKey: key)
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
            autoRenew: false, // Fix 3: StoreKit 2 doesn't expose renewal intent
            productId: transaction.productID       // directly on Transaction; use
        )                                          // Product.SubscriptionInfo if needed.

        saveSubscription()
    }

    private func loadSubscription() {
        // Fix 10: UserDefaults is only a last-known cache to avoid a blank
        // state on cold start. `checkSubscriptionStatus()` always re-validates
        // against StoreKit's Transaction.currentEntitlements as the real source
        // of truth, and will overwrite whatever is loaded here.
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
