import Foundation
import Observation

/// Whether the user has been through onboarding, and what they said they want to
/// achieve. Backed by `UserDefaults` so the flow only appears once per install.
@Observable
final class OnboardingState {
    private enum Key {
        static let hasCompleted = "onboarding.hasCompleted"
        static let goal = "onboarding.goal"
        static let remindersEnabled = "onboarding.remindersEnabled"
    }

    private let defaults: UserDefaults

    var hasCompleted: Bool {
        didSet { defaults.set(hasCompleted, forKey: Key.hasCompleted) }
    }

    var goal: OnboardingGoal? {
        didSet { defaults.set(goal?.rawValue, forKey: Key.goal) }
    }

    var remindersEnabled: Bool {
        didSet { defaults.set(remindersEnabled, forKey: Key.remindersEnabled) }
    }

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
        hasCompleted = defaults.bool(forKey: Key.hasCompleted)
        goal = defaults.string(forKey: Key.goal).flatMap(OnboardingGoal.init(rawValue:))
        if defaults.object(forKey: Key.remindersEnabled) == nil {
            remindersEnabled = true
        } else {
            remindersEnabled = defaults.bool(forKey: Key.remindersEnabled)
        }
    }

    func complete(goal: OnboardingGoal?) {
        self.goal = goal
        hasCompleted = true
    }

    func restart() {
        hasCompleted = false
    }

    static var preview: OnboardingState {
        OnboardingState(defaults: UserDefaults(suiteName: "preview.onboarding") ?? .standard)
    }
}
