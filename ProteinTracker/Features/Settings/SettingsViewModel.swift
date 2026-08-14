import Foundation
import Observation

@Observable
final class SettingsViewModel {
    let store: ProteinStore
    let onboarding: OnboardingState
    let customFoods: CustomFoodDirectory
    let quickAdd: QuickAddDirectory
    let appearance: AppearanceSettings
    let haptics: HapticSettings
    let engagement: AppEngagement

    let goalRange = 60...300
    var exportErrorMessage: String?
    /// Set to `true` to ask `RootView` to present the day-1 check-in sheet.
    var presentsDay1CheckIn = false

    init(
        store: ProteinStore,
        onboarding: OnboardingState,
        customFoods: CustomFoodDirectory,
        quickAdd: QuickAddDirectory,
        appearance: AppearanceSettings,
        haptics: HapticSettings,
        engagement: AppEngagement
    ) {
        self.store = store
        self.onboarding = onboarding
        self.customFoods = customFoods
        self.quickAdd = quickAdd
        self.appearance = appearance
        self.haptics = haptics
        self.engagement = engagement
    }

    var dailyGoal: Int {
        get { store.dailyGoal }
        set { store.dailyGoal = min(max(newValue, goalRange.lowerBound), goalRange.upperBound) }
    }

    var showsRemainingOnRing: Bool {
        get { store.showsRemainingOnRing }
        set { store.showsRemainingOnRing = newValue }
    }

    var hapticsEnabled: Bool {
        get { haptics.isEnabled }
        set { haptics.isEnabled = newValue }
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
    var termsOfUseURL: URL { LegalLinks.termsOfUse }
    var featureRequestURL: URL { LegalLinks.featureRequest }

    func csvExportData() -> Data {
        Data(ProteinDataExport.csv(from: store.entries).utf8)
    }

    @MainActor
    func pdfExportData() -> Data {
        ProteinDataExport.pdfData(from: store.entries, dailyGoal: store.dailyGoal)
    }

    @MainActor
    func writeExportFile(csv: Bool) throws -> URL {
        let filename = csv ? "gramsof-log.csv" : "gramsof-log.pdf"
        let url = FileManager.default.temporaryDirectory.appendingPathComponent(filename)
        let data = csv ? csvExportData() : pdfExportData()
        try data.write(to: url, options: .atomic)
        return url
    }

    func resetToday() {
        store.removeToday()
        AppHaptics.notification(.warning)
    }

    func resetAllData() {
        store.removeAllEntries()
        store.dailyGoal = 150
        store.showsRemainingOnRing = true
        customFoods.removeAll()
        quickAdd.resetToDefaults()
        AppHaptics.notification(.warning)
    }

    func restartOnboarding() {
        engagement.resetForOnboardingRestart()
        onboarding.restart()
    }

    func launchDay1CheckIn() {
        presentsDay1CheckIn = true
    }

    func replayHomeTutorial() {
        engagement.startTutorialReplay()
    }
}
