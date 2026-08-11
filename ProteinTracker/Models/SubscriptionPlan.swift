import Foundation

enum SubscriptionPlan: String, CaseIterable, Identifiable {
    case annual
    case monthly

    var id: String { rawValue }

    /// Must match the product identifiers set up in App Store Connect.
    var productID: String {
        switch self {
        case .annual: "com.lukebillings.ProteinTracker.pro.annual"
        case .monthly: "com.lukebillings.ProteinTracker.pro.monthly"
        }
    }

    var title: String {
        switch self {
        case .annual: "Yearly"
        case .monthly: "Monthly"
        }
    }

    var priceSummary: String {
        switch self {
        case .annual: "£49.99 per year"
        case .monthly: "£9.99 per month"
        }
    }

    /// Short price shown on the trailing edge of the plan card.
    var priceLabel: String {
        switch self {
        case .annual: "£49.99"
        case .monthly: "£9.99"
        }
    }

    var pricePeriod: String {
        switch self {
        case .annual: "per year"
        case .monthly: "per month"
        }
    }

    /// Effective monthly figure, shown under the main price with a leading wave.
    var effectiveMonthlyLabel: String? {
        switch self {
        case .annual: "~ £4.17 a month"
        case .monthly: nil
        }
    }

    var detail: String? {
        switch self {
        case .annual: "Works out at £4.17 a month"
        case .monthly: nil
        }
    }

    var badge: String? {
        switch self {
        case .annual: "Save 58% vs monthly"
        case .monthly: nil
        }
    }

    var freeTrialDays: Int? {
        switch self {
        case .annual: 7
        case .monthly: nil
        }
    }
}
