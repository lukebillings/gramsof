import Foundation
import Observation

/// First-run tutorial, day-1 check-in, and StoreKit review prompt timing.
@Observable
final class AppEngagement {
    private enum Key {
        static let hasSeenHomeTutorial = "engagement.hasSeenHomeTutorial"
        static let hasCompletedDay1CheckIn = "engagement.hasCompletedDay1CheckIn"
        static let completedOnboardingAt = "engagement.completedOnboardingAt"
        static let hasPromptedFirstGoalReview = "engagement.hasPromptedFirstGoalReview"
        static let lastReviewPromptAt = "engagement.lastReviewPromptAt"
        static let lastReviewGoalHitDay = "engagement.lastReviewGoalHitDay"
    }

    private let defaults: UserDefaults
    private let calendar = Calendar.current

    var hasSeenHomeTutorial: Bool {
        didSet { defaults.set(hasSeenHomeTutorial, forKey: Key.hasSeenHomeTutorial) }
    }

    var hasCompletedDay1CheckIn: Bool {
        didSet { defaults.set(hasCompletedDay1CheckIn, forKey: Key.hasCompletedDay1CheckIn) }
    }

    var completedOnboardingAt: Date? {
        didSet {
            if let completedOnboardingAt {
                defaults.set(completedOnboardingAt, forKey: Key.completedOnboardingAt)
            } else {
                defaults.removeObject(forKey: Key.completedOnboardingAt)
            }
        }
    }

    private var hasPromptedFirstGoalReview: Bool {
        didSet { defaults.set(hasPromptedFirstGoalReview, forKey: Key.hasPromptedFirstGoalReview) }
    }

    private var lastReviewPromptAt: Date? {
        didSet {
            if let lastReviewPromptAt {
                defaults.set(lastReviewPromptAt, forKey: Key.lastReviewPromptAt)
            } else {
                defaults.removeObject(forKey: Key.lastReviewPromptAt)
            }
        }
    }

    private var lastReviewGoalHitDay: Date? {
        didSet {
            if let lastReviewGoalHitDay {
                defaults.set(lastReviewGoalHitDay, forKey: Key.lastReviewGoalHitDay)
            } else {
                defaults.removeObject(forKey: Key.lastReviewGoalHitDay)
            }
        }
    }

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
        hasSeenHomeTutorial = defaults.bool(forKey: Key.hasSeenHomeTutorial)
        hasCompletedDay1CheckIn = defaults.bool(forKey: Key.hasCompletedDay1CheckIn)
        completedOnboardingAt = defaults.object(forKey: Key.completedOnboardingAt) as? Date
        hasPromptedFirstGoalReview = defaults.bool(forKey: Key.hasPromptedFirstGoalReview)
        lastReviewPromptAt = defaults.object(forKey: Key.lastReviewPromptAt) as? Date
        lastReviewGoalHitDay = defaults.object(forKey: Key.lastReviewGoalHitDay) as? Date
    }

    var shouldShowHomeTutorial: Bool {
        !hasSeenHomeTutorial
    }

    /// Calendar day after onboarding completion, once tutorial is done.
    var shouldShowDay1CheckIn: Bool {
        guard !hasCompletedDay1CheckIn,
              hasSeenHomeTutorial,
              let completedOnboardingAt
        else { return false }

        let startOfCompletion = calendar.startOfDay(for: completedOnboardingAt)
        let startOfToday = calendar.startOfDay(for: .now)
        guard let dayAfter = calendar.date(byAdding: .day, value: 1, to: startOfCompletion) else {
            return false
        }
        return startOfToday >= dayAfter
    }

    func markOnboardingCompleted(at date: Date = .now) {
        if completedOnboardingAt == nil {
            completedOnboardingAt = date
        }
    }

    /// Existing installs that finished onboarding before engagement flags existed
    /// should not suddenly see the tutorial or day-1 check-in.
    func migrateLegacyUserIfNeeded(onboardingCompleted: Bool) {
        guard onboardingCompleted, completedOnboardingAt == nil else { return }
        hasSeenHomeTutorial = true
        hasCompletedDay1CheckIn = true
    }

    func markHomeTutorialSeen() {
        hasSeenHomeTutorial = true
    }

    func markDay1CheckInCompleted() {
        hasCompletedDay1CheckIn = true
    }

    /// Replay tutorial from Settings or day-1 “need help”.
    func startTutorialReplay() {
        hasSeenHomeTutorial = false
    }

    /// When onboarding is restarted, show tutorial and day-1 again after the next finish.
    func resetForOnboardingRestart() {
        hasSeenHomeTutorial = false
        hasCompletedDay1CheckIn = false
        completedOnboardingAt = nil
    }

    /// Call when today’s total first meets or exceeds the daily goal.
    /// Returns `true` if the app should invoke `requestReview()`.
    @discardableResult
    func noteGoalReached(on date: Date = .now) -> Bool {
        let today = calendar.startOfDay(for: date)

        if let lastReviewGoalHitDay, calendar.isDate(lastReviewGoalHitDay, inSameDayAs: today) {
            return false
        }

        if !hasPromptedFirstGoalReview {
            hasPromptedFirstGoalReview = true
            lastReviewPromptAt = date
            lastReviewGoalHitDay = today
            return true
        }

        guard let lastReviewPromptAt else { return false }
        let daysSincePrompt = calendar.dateComponents(
            [.day],
            from: calendar.startOfDay(for: lastReviewPromptAt),
            to: today
        ).day ?? 0

        guard daysSincePrompt >= 7 else { return false }

        self.lastReviewPromptAt = date
        lastReviewGoalHitDay = today
        return true
    }

    static var preview: AppEngagement {
        AppEngagement(defaults: UserDefaults(suiteName: "preview.engagement") ?? .standard)
    }
}
