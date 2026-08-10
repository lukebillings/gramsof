import Foundation
import Observation

@Observable
final class SettingsViewModel {
    let store: ProteinStore
    let onboarding: OnboardingState

    let goalRange = 60...300

    init(store: ProteinStore, onboarding: OnboardingState) {
        self.store = store
        self.onboarding = onboarding
    }

    var dailyGoal: Int {
        get { store.dailyGoal }
        set { store.dailyGoal = min(max(newValue, goalRange.lowerBound), goalRange.upperBound) }
    }

    var showsRemainingOnRing: Bool {
        get { store.showsRemainingOnRing }
        set { store.showsRemainingOnRing = newValue }
    }

    var remindersEnabled: Bool {
        get { onboarding.remindersEnabled }
        set {
            onboarding.remindersEnabled = newValue
            Task {
                let effectivelyEnabled = await DailyReminderScheduler.sync(enabled: newValue)
                if onboarding.remindersEnabled != effectivelyEnabled {
                    onboarding.remindersEnabled = effectivelyEnabled
                }
            }
        }
    }

    var loggedEntryCount: Int { store.entries.count }

    var onboardingGoalName: String { onboarding.goal?.title ?? "Not set" }

    func resetToday() {
        for entry in store.todayEntries {
            store.remove(entry)
        }
    }

    func restartOnboarding() {
        onboarding.restart()
    }
}
