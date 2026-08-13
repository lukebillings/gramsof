import Foundation
import Observation
import StoreKit

/// Loads subscription products from App Store Connect via StoreKit 2 and tracks
/// the current entitlement. Paywall copy is hardcoded in `SubscriptionOffer`.
@Observable
@MainActor
final class SubscriptionStore {
    private(set) var products: [Product] = []
    private(set) var isLoading = false
    private(set) var loadError: String?
    private(set) var isPurchasing = false
    private(set) var purchaseError: String?
    private(set) var isSubscribed = false

    /// Yearly first, then monthly — matching App Store Connect display order.
    var orderedProducts: [Product] {
        SubscriptionPlan.allCases.compactMap { plan in
            products.first { $0.id == plan.productID }
        }
    }

    init() {
        // App-lifetime store: listen for StoreKit updates without retaining a
        // cancellable task (avoids MainActor `deinit` isolation issues).
        Task { [weak self] in
            for await _ in Transaction.updates {
                await self?.refreshEntitlements()
            }
        }
        Task { await refreshEntitlements() }
    }

    func loadProducts() async {
        isLoading = true
        loadError = nil
        defer { isLoading = false }

        do {
            let loaded = try await Product.products(for: SubscriptionPlan.productIDs)
            products = loaded.sorted { lhs, rhs in
                rank(for: lhs.id) < rank(for: rhs.id)
            }
            if products.isEmpty {
                loadError = "Subscriptions aren’t available right now. Try again later."
            }
        } catch {
            loadError = error.localizedDescription
            products = []
        }
    }

    func storeProduct(for plan: SubscriptionPlan) -> Product? {
        products.first { $0.id == plan.productID }
    }

    @discardableResult
    func purchase(_ product: Product) async -> Bool {
        isPurchasing = true
        purchaseError = nil
        defer { isPurchasing = false }

        do {
            let result = try await product.purchase()
            switch result {
            case .success(let verification):
                let transaction = try checkVerified(verification)
                await transaction.finish()
                await refreshEntitlements()
                return isSubscribed
            case .userCancelled, .pending:
                return false
            @unknown default:
                return false
            }
        } catch {
            purchaseError = error.localizedDescription
            return false
        }
    }

    func restorePurchases() async {
        purchaseError = nil
        do {
            try await AppStore.sync()
            await refreshEntitlements()
            if !isSubscribed {
                purchaseError = "No active subscription found."
            }
        } catch {
            purchaseError = error.localizedDescription
        }
    }

    func refreshEntitlements() async {
        var active = false
        for await result in Transaction.currentEntitlements {
            guard let transaction = try? checkVerified(result) else { continue }
            if SubscriptionPlan.plan(forProductID: transaction.productID) != nil {
                active = true
                break
            }
        }
        isSubscribed = active
    }

    func offer(for product: Product) -> SubscriptionOffer {
        SubscriptionOffer(product: product)
    }

    private func rank(for productID: String) -> Int {
        SubscriptionPlan.allCases.firstIndex { $0.productID == productID } ?? .max
    }

    private func checkVerified<T>(_ result: VerificationResult<T>) throws -> T {
        switch result {
        case .unverified(_, let error):
            throw error
        case .verified(let value):
            return value
        }
    }
}

/// UI-facing fields for a StoreKit `Product`. Display copy is hardcoded so the
/// paywall stays consistent regardless of StoreKit localization timing.
struct SubscriptionOffer: Identifiable {
    let product: Product

    var id: String { product.id }

    var plan: SubscriptionPlan? {
        SubscriptionPlan.plan(forProductID: product.id)
    }

    var title: String {
        switch plan {
        case .yearly: "Yearly"
        case .monthly: "Monthly"
        case nil: product.displayName
        }
    }

    var priceSummary: String {
        switch plan {
        case .yearly: "£29.99 per year"
        case .monthly: "£9.99 per month"
        case nil: product.displayPrice
        }
    }

    var freeTrialDays: Int? {
        plan == .yearly ? 3 : nil
    }

    var effectiveMonthlyPrice: String? {
        plan == .yearly ? "~ £2.50 a month" : nil
    }

    var badge: String? {
        plan == .yearly ? "Save 75% vs monthly" : nil
    }
}
