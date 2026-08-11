import Foundation
import UserNotifications

enum DailyReminderScheduler {
    static let requestIdentifier = "protein.daily.logging.reminder"

    /// Requests notification permission if needed and schedules (or clears) the daily reminder.
    /// Returns whether reminders are effectively enabled after the attempt.
    @discardableResult
    static func sync(
        enabled: Bool,
        hour: Int = OnboardingState.defaultReminderHour,
        minute: Int = OnboardingState.defaultReminderMinute
    ) async -> Bool {
        let center = UNUserNotificationCenter.current()

        guard enabled else {
            center.removePendingNotificationRequests(withIdentifiers: [requestIdentifier])
            return false
        }

        do {
            let granted = try await center.requestAuthorization(options: [.alert, .sound, .badge])
            guard granted else {
                center.removePendingNotificationRequests(withIdentifiers: [requestIdentifier])
                return false
            }
        } catch {
            center.removePendingNotificationRequests(withIdentifiers: [requestIdentifier])
            return false
        }

        center.removePendingNotificationRequests(withIdentifiers: [requestIdentifier])

        var dateComponents = DateComponents()
        dateComponents.hour = min(max(hour, 0), 23)
        dateComponents.minute = min(max(minute, 0), 59)

        let content = UNMutableNotificationContent()
        content.title = "Log today's protein"
        content.body = "A quick check-in keeps your streak alive."
        content.sound = .default

        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let request = UNNotificationRequest(
            identifier: requestIdentifier,
            content: content,
            trigger: trigger
        )

        do {
            try await center.add(request)
            return true
        } catch {
            return false
        }
    }
}
