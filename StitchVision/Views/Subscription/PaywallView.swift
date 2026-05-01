import SwiftUI
import StoreKit

struct PaywallView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var appState: AppState
    @StateObject private var subscriptionManager = SubscriptionManager.shared

    @State private var selectedProduct: Product?
    @State private var isPurchasing = false

    let feature: String?

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    headerSection
                    featuresComparison
                    pricingSection
                    ctaButton
                    restoreButton
                }
                .padding()
            }
            .navigationTitle("Upgrade to Pro")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Close") {
                        dismiss()
                    }
                }
            }
            .task {
                await subscriptionManager.loadProducts()
            }
            .alert("Error", isPresented: .constant(subscriptionManager.errorMessage != nil)) {
                Button("OK") {
                    subscriptionManager.errorMessage = nil
                }
            } message: {
                if let error = subscriptionManager.errorMessage {
                    Text(error)
                }
            }
        }
    }

    private var headerSection: some View {
        VStack(spacing: 16) {
            Image(systemName: "crown.fill")
                .font(.system(size: 60))
                .foregroundColor(Color(red: 0.83, green: 0.69, blue: 0.22))

            Text("Unlock AI Coach")
                .font(.title)
                .fontWeight(.bold)

            if let feature = feature {
                Text("Get \(feature) and more with Pro")
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            } else {
                Text("Get the most out of StitchVision")
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
        }
    }

    private var featuresComparison: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Pro Features")
                .font(.headline)

            ForEach(SubscriptionTier.pro.features, id: \.self) { feature in
                HStack(spacing: 12) {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(Color(red: 0.561, green: 0.659, blue: 0.533))
                        .frame(width: 24)

                    Text(feature)
                        .font(.subheadline)

                    Spacer()
                }
            }
        }
        .padding()
        .background(Color(.secondarySystemGroupedBackground))
        .cornerRadius(12)
    }

    private var pricingSection: some View {
        VStack(spacing: 12) {
            ForEach(subscriptionManager.products, id: \.id) { product in
                PricingOptionView(
                    product: product,
                    isSelected: selectedProduct?.id == product.id,
                    onTap: {
                        selectedProduct = product
                    }
                )
            }

            if subscriptionManager.products.isEmpty && !subscriptionManager.isLoading {
                Text("Loading products...")
                    .foregroundColor(.secondary)
            }
        }
    }

    private var ctaButton: some View {
        Button(action: purchase) {
            if isPurchasing || subscriptionManager.isLoading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    .frame(maxWidth: .infinity)
                    .padding()
            } else {
                Text("Subscribe")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
            }
        }
        .background(Color(red: 0.561, green: 0.659, blue: 0.533))
        .foregroundColor(.white)
        .cornerRadius(12)
        .disabled(selectedProduct == nil || isPurchasing)
    }

    private var restoreButton: some View {
        Button("Restore Purchases") {
            Task {
                await subscriptionManager.restorePurchases()
                if subscriptionManager.isPro {
                    appState.syncProStatus()
                    dismiss()
                }
            }
        }
        .font(.subheadline)
        .foregroundColor(.secondary)
    }

    private func purchase() {
        guard let product = selectedProduct else { return }

        isPurchasing = true

        Task {
            let success = await subscriptionManager.purchase(product)
            isPurchasing = false

            if success {
                appState.syncProStatus()
                dismiss()
            }
        }
    }
}

struct PricingOptionView: View {
    let product: Product
    let isSelected: Bool
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(product.displayName)
                        .font(.headline)
                        .foregroundColor(.primary)

                    Text(product.description)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }

                Spacer()

                Text(product.displayPrice)
                    .font(.headline)
                    .foregroundColor(Color(red: 0.561, green: 0.659, blue: 0.533))
            }
            .padding()
            .background(isSelected ? Color(red: 0.561, green: 0.659, blue: 0.533).opacity(0.1) : Color(.secondarySystemGroupedBackground))
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isSelected ? Color(red: 0.561, green: 0.659, blue: 0.533) : Color.clear, lineWidth: 2)
            )
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    PaywallView(feature: "Test Feature")
        .environmentObject(AppState())
}
