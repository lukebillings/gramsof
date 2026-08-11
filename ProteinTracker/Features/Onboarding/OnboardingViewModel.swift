import Foundation
import Observation

@Observable
final class OnboardingViewModel {
    enum Step: Hashable {
        case goal
        case paywall
        case dailyTarget
        case notifications
    }

    private let state: OnboardingState
    private let store: ProteinStore

    var step: Step = .goal
    var selectedGoal: OnboardingGoal?
    var selectedPlan: SubscriptionPlan = .annual
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

    init(state: OnboardingState, store: ProteinStore) {
        self.state = state
        self.store = store
        selectedGoal = state.goal
        dailyGoal = nil
        remindersEnabled = state.remindersEnabled
    }

    var goals: [OnboardingGoal] { OnboardingGoal.allCases }
    var plans: [SubscriptionPlan] { SubscriptionPlan.allCases }

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
    }

    func select(_ plan: SubscriptionPlan) {
        selectedPlan = plan
    }

    func continueFromPaywall() {
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
    }

    func backToDailyTarget() {
        step = .dailyTarget
    }

    /// Purchases are not wired up yet, so this only records the choice and lets
    /// the user into the app.
    func finish() async {
        store.dailyGoal = dailyGoal ?? suggestedDailyGoal

        let effectivelyEnabled = await DailyReminderScheduler.sync(
            enabled: remindersEnabled,
            hour: state.reminderHour,
            minute: state.reminderMinute
        )
        remindersEnabled = effectivelyEnabled
        state.remindersEnabled = effectivelyEnabled

        state.complete(goal: selectedGoal)
    }
}
