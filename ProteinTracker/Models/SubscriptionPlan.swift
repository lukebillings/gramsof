import Foundation
import StoreKit

/// Product identifiers configured in App Store Connect.
enum SubscriptionPlan: String, CaseIterable, Identifiable {
    case yearly
    case monthly

    var id: String { rawValue }

    var productID: String {
        switch self {
        case .yearly: "com.gramsof.pro.yearly"
        case .monthly: "com.gramsof.pro.monthly"
        }
    }

    static var productIDs: [String] {
        allCases.map(\.productID)
    }

    static func plan(forProductID id: String) -> SubscriptionPlan? {
        allCases.first { $0.productID == id }
    }
}

/// A paywall row backed by a StoreKit product, so prices, renewal periods, and
/// trials all come from App Store Connect rather than being hardcoded here.
struct SubscriptionOffer: Identifiable, Equatable {
    let plan: SubscriptionPlan
    let product: Product
    /// Discount against paying monthly, when both plans have loaded.
    let savingsPercentage: Int?

    var id: String { product.id }

    var title: String {
        switch plan {
        case .yearly: "Yearly"
        case .monthly: "Monthly"
        }
    }

    var priceSummary: String {
        guard let period = product.subscription?.subscriptionPeriod else {
            return product.displayPrice
        }
        return "\(product.displayPrice) per \(period.unitLabel)"
    }

    var freeTrialDays: Int? {
        guard let offer = product.subscription?.introductoryOffer,
              offer.paymentMode == .freeTrial
        else { return nil }
        return offer.period.dayCount
    }

    var effectiveMonthlyPrice: String? {
        guard let months = product.subscription?.subscriptionPeriod.monthCount, months > 1 else {
            return nil
        }
        let perMonth = product.price / Decimal(months)
        return "~ \(perMonth.formatted(product.priceFormatStyle)) a month"
    }

    var badge: String? {
        savingsPercentage.map { "Save \($0)% vs monthly" }
    }

    /// Orders the loaded products by plan and skips any that App Store Connect
    /// has not returned yet.
    static func offers(from products: [Product]) -> [SubscriptionOffer] {
        let monthlyPrice = products.first { $0.id == SubscriptionPlan.monthly.productID }?.price

        return SubscriptionPlan.allCases.compactMap { plan in
            guard let product = products.first(where: { $0.id == plan.productID }) else { return nil }
            return SubscriptionOffer(
                plan: plan,
                product: product,
                savingsPercentage: savingsPercentage(for: product, comparedToMonthly: monthlyPrice)
            )
        }
    }

    private static func savingsPercentage(
        for product: Product,
        comparedToMonthly monthlyPrice: Decimal?
    ) -> Int? {
        guard let monthlyPrice, monthlyPrice > 0,
              let months = product.subscription?.subscriptionPeriod.monthCount, months > 1
        else { return nil }

        let fullPrice = monthlyPrice * Decimal(months)
        let saved = (fullPrice - product.price) / fullPrice * 100
        let rounded = Int(NSDecimalNumber(decimal: saved).doubleValue.rounded())
        return rounded > 0 ? rounded : nil
    }
}

private extension Product.SubscriptionPeriod {
    /// "year", "month", or "3 months" for multi-unit periods.
    var unitLabel: String {
        let name: String
        switch unit {
        case .day: name = "day"
        case .week: name = "week"
        case .month: name = "month"
        case .year: name = "year"
        @unknown default: name = "period"
        }
        return value == 1 ? name : "\(value) \(name)s"
    }

    var dayCount: Int {
        switch unit {
        case .day: value
        case .week: value * 7
        case .month: value * 30
        case .year: value * 365
        @unknown default: value
        }
    }

    var monthCount: Int? {
        switch unit {
        case .month: value
        case .year: value * 12
        case .day, .week: nil
        @unknown default: nil
        }
    }
}
