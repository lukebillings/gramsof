import Foundation

/// Product identifiers configured in App Store Connect.
/// Prices, trials, and localized titles come from StoreKit — not from this file.
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
