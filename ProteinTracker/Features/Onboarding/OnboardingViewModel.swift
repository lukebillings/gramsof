import Foundation
import Observation
import StoreKit

@Observable
@MainActor
final class OnboardingViewModel {
    enum Step: Hashable {
        case goal
        case paywall
        case dailyTarget
        case notifications
    }

    private let state: OnboardingState
    private let store: ProteinStore
    private let engagement: AppEngagement
    let subscriptions: SubscriptionStore

    var step: Step = .goal
    var selectedGoal: OnboardingGoal?
    var selectedProductID: String?
    /// Starts empty so the user types their own target on the daily goal step.
    var dailyGoal: Int? {
        didSet {
            guard let value = dailyGoal else { return }
            let clamped = min(max(value, goalRange.lowerBound), goalRange.upperBound)
            if value != clamped {
                dailyGoal = clamped
            }
        }
    }
    var remindersEnabled = true

    let goalRange = 60...300

    var hasValidDailyGoal: Bool {
        guard let dailyGoal else { return false }
        return goalRange.contains(dailyGoal)
    }

    var offers: [SubscriptionOffer] {
        SubscriptionOffer.all
    }

    var selectedPlan: SubscriptionPlan {
        SubscriptionPlan.plan(forProductID: selectedProductID ?? "") ?? .yearly
    }

    var selectedProduct: Product? {
        subscriptions.storeProduct(for: selectedPlan)
    }

    init(
        state: OnboardingState,
        store: ProteinStore,
        subscriptions: SubscriptionStore,
        engagement: AppEngagement
    ) {
        self.state = state
        self.store = store
        self.subscriptions = subscriptions
        self.engagement = engagement
        selectedGoal = state.goal
        selectedProductID = SubscriptionPlan.yearly.productID
        dailyGoal = nil
        remindersEnabled = state.remindersEnabled
    }

    var goals: [OnboardingGoal] { OnboardingGoal.allCases }

    var suggestedDailyGoal: Int {
        guard let selectedGoal else { return 150 }
        switch selectedGoal {
        case .buildMuscle: return 170
        case .loseFat: return 150
        case .maintain: return 150
        case .feelHealthier: return 130
        }
    }

    var suggestedRangeLabel: String {
        guard let selectedGoal else { return "60–300g" }
        switch selectedGoal {
        case .buildMuscle: return "Often 160–180g for building muscle"
        case .loseFat: return "Often 140–160g while losing fat"
        case .maintain: return "Around 150g works well to maintain"
        case .feelHealthier: return "Often 120–140g to eat healthier"
        }
    }

    /// Tapping a goal selects it and moves straight to the paywall.
    func select(_ goal: OnboardingGoal) {
        selectedGoal = goal
        step = .paywall
        Task { await loadSubscriptionsIfNeeded() }
    }

    func select(productID: String) {
        selectedProductID = productID
    }

    func loadSubscriptionsIfNeeded() async {
        if subscriptions.products.isEmpty {
            await subscriptions.loadProducts()
        }
    }

    func continueFromPaywall() async {
        if subscriptions.isSubscribed {
            step = .dailyTarget
            return
        }

        if selectedProduct == nil {
            await subscriptions.loadProducts()
        }

        guard let product = selectedProduct else { return }

        let success = await subscriptions.purchase(product)
        if success || subscriptions.isSubscribed {
            step = .dailyTarget
        }
    }

    /// Skip purchase and continue onboarding (e.g. during testing or soft paywall).
    func skipPaywall() {
        step = .dailyTarget
    }

    func continueFromDailyTarget() {
        step = .notifications
    }

    func backToGoal() {
        step = .goal
    }

    func backToPaywall() {
        step = .paywall
        Task { await loadSubscriptionsIfNeeded() }
    }

    func backToDailyTarget() {
        step = .dailyTarget
    }

    func restorePurchases() async {
        await subscriptions.restorePurchases()
        if subscriptions.isSubscribed {
            step = .dailyTarget
        }
    }

    func finish() async {
        store.dailyGoal = dailyGoal ?? suggestedDailyGoal

        let effectivelyEnabled = await DailyReminderScheduler.sync(
            enabled: remindersEnabled,
            hour: state.reminderHour,
            minute: state.reminderMinute
        )
        remindersEnabled = effectivelyEnabled
        state.remindersEnabled = effectivelyEnabled

        engagement.markOnboardingCompleted()
        state.complete(goal: selectedGoal)
    }
}
