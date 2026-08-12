import Foundation
import Observation
import StoreKit

/// Loads subscription products from App Store Connect via StoreKit 2 and tracks
/// the current entitlement. Display prices and offers always come from `Product`.
@Observable
@MainActor
final class SubscriptionStore {
    private(set) var products: [Product] = []
    private(set) var isLoading = false
    private(set) var loadError: String?
    private(set) var isPurchasing = false
    private(set) var purchaseError: String?
    private(set) var isSubscribed = false

    private var updatesTask: Task<Void, Never>?

    /// Yearly first, then monthly — matching App Store Connect display order.
    var orderedProducts: [Product] {
        SubscriptionPlan.allCases.compactMap { plan in
            products.first { $0.id == plan.productID }
        }
    }

    init() {
        updatesTask = Task { [weak self] in
            for await _ in Transaction.updates {
                await self?.refreshEntitlements()
            }
        }
        Task { await refreshEntitlements() }
    }

    deinit {
        updatesTask?.cancel()
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

    func product(for plan: SubscriptionPlan) -> Product? {
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

    // MARK: - Display helpers from StoreKit products

    func offer(for product: Product) -> SubscriptionOffer {
        SubscriptionOffer(
            product: product,
            savingsPercentVersusMonthly: savingsPercent(for: product),
            effectiveMonthlyPrice: effectiveMonthlyPrice(for: product)
        )
    }

    private func savingsPercent(for product: Product) -> Int? {
        guard product.id == SubscriptionPlan.yearly.productID,
              let monthly = product(for: .monthly),
              monthly.price > 0 else { return nil }

        let yearlyPerMonth = product.price / 12
        let ratio = NSDecimalNumber(decimal: yearlyPerMonth / monthly.price).doubleValue
        let percent = Int((1 - ratio) * 100)
        return percent > 0 ? percent : nil
    }

    private func effectiveMonthlyPrice(for product: Product) -> String? {
        guard product.id == SubscriptionPlan.yearly.productID else { return nil }
        let monthly = product.price / 12
        return "~ \(monthly.formatted(product.priceFormatStyle)) a month"
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

/// UI-facing fields derived from a StoreKit `Product`.
struct SubscriptionOffer: Identifiable {
    let product: Product
    let savingsPercentVersusMonthly: Int?
    let effectiveMonthlyPrice: String?

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
        "\(product.displayPrice) \(periodSuffix)"
    }

    var freeTrialDays: Int? {
        guard let offer = product.subscription?.introductoryOffer,
              offer.paymentMode == .freeTrial else { return nil }
        return days(in: offer.period)
    }

    var badge: String? {
        guard let savingsPercentVersusMonthly else { return nil }
        return "Save \(savingsPercentVersusMonthly)% vs monthly"
    }

    private var periodSuffix: String {
        guard let period = product.subscription?.subscriptionPeriod else {
            return ""
        }
        switch period.unit {
        case .day:
            return period.value == 1 ? "per day" : "per \(period.value) days"
        case .week:
            return period.value == 1 ? "per week" : "per \(period.value) weeks"
        case .month:
            return period.value == 1 ? "per month" : "per \(period.value) months"
        case .year:
            return period.value == 1 ? "per year" : "per \(period.value) years"
        @unknown default:
            return ""
        }
    }

    private func days(in period: Product.SubscriptionPeriod) -> Int {
        switch period.unit {
        case .day: period.value
        case .week: period.value * 7
        case .month: period.value * 30
        case .year: period.value * 365
        @unknown default: period.value
        }
    }
}
