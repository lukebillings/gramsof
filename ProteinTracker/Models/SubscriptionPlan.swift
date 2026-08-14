import Foundation

/// Product identifiers configured in App Store Connect.
/// Paywall display copy is hardcoded so plans render before StoreKit loads.
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

/// Hardcoded paywall rows. Purchase still resolves the matching StoreKit product.
struct SubscriptionOffer: Identifiable, Equatable {
    let plan: SubscriptionPlan

    var id: String { plan.productID }

    var title: String {
        switch plan {
        case .yearly: "Yearly"
        case .monthly: "Monthly"
        }
    }

    var priceSummary: String {
        switch plan {
        case .yearly: "£29.99 per year"
        case .monthly: "£9.99 per month"
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

    static let all: [SubscriptionOffer] = SubscriptionPlan.allCases.map(SubscriptionOffer.init)
}
