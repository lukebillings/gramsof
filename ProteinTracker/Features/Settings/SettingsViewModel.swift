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
            Task { await syncReminders(enabled: newValue) }
        }
    }

    /// Bound to the Settings time picker. Persists hour/minute and reschedules when reminders are on.
    var reminderTime: Date {
        get {
            Calendar.current.date(
                from: DateComponents(
                    hour: onboarding.reminderHour,
                    minute: onboarding.reminderMinute
                )
            ) ?? Date()
        }
        set {
            let components = Calendar.current.dateComponents([.hour, .minute], from: newValue)
            onboarding.reminderHour = components.hour ?? OnboardingState.defaultReminderHour
            onboarding.reminderMinute = components.minute ?? OnboardingState.defaultReminderMinute
            guard onboarding.remindersEnabled else { return }
            Task { await syncReminders(enabled: true) }
        }
    }

    private func syncReminders(enabled: Bool) async {
        let effectivelyEnabled = await DailyReminderScheduler.sync(
            enabled: enabled,
            hour: onboarding.reminderHour,
            minute: onboarding.reminderMinute
        )
        if onboarding.remindersEnabled != effectivelyEnabled {
            onboarding.remindersEnabled = effectivelyEnabled
        }
    }

    var appearancePreference: AppearancePreference {
        get { appearance.preference }
        set { appearance.preference = newValue }
    }

    var loggedEntryCount: Int { store.entries.count }

    /// App Store product URL — swap in the real `id…` link once the listing is live.
    var appStoreURL: URL {
        URL(string: "https://apps.apple.com/app/gramsof")!
    }

    var appShareMessage: String {
        "Track your daily protein with Gramsof."
    }

    var termsAndConditionsURL: URL { LegalLinks.termsAndConditions }
    var privacyPolicyURL: URL { LegalLinks.privacyPolicy }
    var termsOfServiceURL: URL { LegalLinks.termsOfService }

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
