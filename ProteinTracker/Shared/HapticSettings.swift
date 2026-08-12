import Foundation
import Observation
import UIKit

@Observable
final class HapticSettings {
    private enum Key {
        static let enabled = "settings.hapticsEnabled"
    }

    private let defaults: UserDefaults

    var isEnabled: Bool {
        didSet { defaults.set(isEnabled, forKey: Key.enabled) }
    }

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
        if defaults.object(forKey: Key.enabled) == nil {
            isEnabled = true
        } else {
            isEnabled = defaults.bool(forKey: Key.enabled)
        }
    }
}

enum AppHaptics {
    private static var settings: HapticSettings?

    static func configure(_ settings: HapticSettings) {
        self.settings = settings
    }

    static func impact(_ style: UIImpactFeedbackGenerator.FeedbackStyle = .medium) {
        guard settings?.isEnabled != false else { return }
        UIImpactFeedbackGenerator(style: style).impactOccurred()
    }

    static func notification(_ type: UINotificationFeedbackGenerator.FeedbackType) {
        guard settings?.isEnabled != false else { return }
        UINotificationFeedbackGenerator().notificationOccurred(type)
    }

    static func selection() {
        guard settings?.isEnabled != false else { return }
        UISelectionFeedbackGenerator().selectionChanged()
    }
}
