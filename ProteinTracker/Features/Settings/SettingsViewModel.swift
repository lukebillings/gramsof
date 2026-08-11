import Foundation
import Observation

@Observable
final class SettingsViewModel {
    let store: ProteinStore
    let onboarding: OnboardingState
    let customFoods: CustomFoodDirectory
    let appearance: AppearanceSettings

    let goalRange = 60...300

    init(
        store: ProteinStore,
        onboarding: OnboardingState,
        customFoods: CustomFoodDirectory,
        appearance: AppearanceSettings
    ) {
        self.store = store
        self.onboarding = onboarding
        self.customFoods = customFoods
        self.appearance = appearance
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

    var appearancePreference: AppearancePreference {
        get { appearance.preference }
        set { appearance.preference = newValue }
    }

    var loggedEntryCount: Int { store.entries.count }

    var onboardingGoalName: String { onboarding.goal?.title ?? "Not set" }

    var shareText: String {
        let total = store.todayTotal
        let goal = store.dailyGoal
        if total >= goal {
            return "I hit my \(goal)g protein goal today on Protein Tracker — \(total)g logged."
        }
        return "I've logged \(total)g of \(goal)g protein today on Protein Tracker."
    }

    func resetToday() {
        store.removeToday()
    }

    func resetAllData() {
        store.removeAllEntries()
        store.dailyGoal = 150
        store.showsRemainingOnRing = true
        customFoods.removeAll()
    }

    func restartOnboarding() {
        onboarding.restart()
    }
}
