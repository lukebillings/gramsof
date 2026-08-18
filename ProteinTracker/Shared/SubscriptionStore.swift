import Foundation
import Observation
import StoreKit

/// Loads subscription products from App Store Connect via StoreKit 2 and tracks
/// the current entitlement. Paywall rows are built from these products by
/// `SubscriptionOffer.offers(from:)`.
@Observable
@MainActor
final class SubscriptionStore {
    private(set) var products: [Product] = []
    private(set) var isLoading = false
    private(set) var loadError: String?
    private(set) var isPurchasing = false
    private(set) var purchaseError: String?
    private(set) var isSubscribed = false

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
