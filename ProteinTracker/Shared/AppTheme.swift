import SwiftUI
import UIKit

enum AppearancePreference: String, CaseIterable, Identifiable {
    case system
    case light
    case dark

    var id: String { rawValue }

    var title: String {
        switch self {
        case .system: "System"
        case .light: "Light"
        case .dark: "Dark"
        }
    }

    var colorScheme: ColorScheme? {
        switch self {
        case .system: nil
        case .light: .light
        case .dark: .dark
        }
    }
}

@Observable
final class AppearanceSettings {
    private enum Key {
        static let preference = "settings.appearance"
    }

    private let defaults: UserDefaults

    var preference: AppearancePreference {
        didSet { defaults.set(preference.rawValue, forKey: Key.preference) }
    }

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
        if let raw = defaults.string(forKey: Key.preference),
           let value = AppearancePreference(rawValue: raw) {
            preference = value
        } else {
            preference = .system
        }
    }
}

enum AppTheme {
    static let ink = Color(
        light: Color(red: 0.07, green: 0.14, blue: 0.11),
        dark: Color(red: 0.90, green: 0.96, blue: 0.93)
    )
    static let forest = Color(
        light: Color(red: 0.10, green: 0.24, blue: 0.18),
        dark: Color(red: 0.55, green: 0.82, blue: 0.68)
    )
    static let emerald = Color(
        light: Color(red: 0.12, green: 0.56, blue: 0.37),
        dark: Color(red: 0.28, green: 0.72, blue: 0.50)
    )
    static let mint = Color(
        light: Color(red: 0.72, green: 0.94, blue: 0.82),
        dark: Color(red: 0.14, green: 0.28, blue: 0.22)
    )
    static let foam = Color(
        light: Color(red: 0.95, green: 0.98, blue: 0.96),
        dark: Color(red: 0.05, green: 0.09, blue: 0.07)
    )

    static var background: some View {
        LinearGradient(
            colors: [foam, mint.opacity(0.55), emerald.opacity(0.35)],
            startPoint: .top,
            endPoint: .bottom
        )
        .ignoresSafeArea()
    }

    /// Light at the ring start, deepening to forest green toward the leading tip.
    /// Uses shape-local angles (0° = right); `ProteinRingView` rotates -90° so fill starts at top.
    static func ringGradient(progress: Double) -> AngularGradient {
        let clamped = min(max(progress, 0.001), 1)
        return AngularGradient(
            colors: [
                Color(red: 0.72, green: 0.94, blue: 0.82),
                Color(red: 0.35, green: 0.78, blue: 0.52),
                Color(red: 0.12, green: 0.56, blue: 0.37),
                Color(red: 0.08, green: 0.32, blue: 0.22)
            ],
            center: .center,
            startAngle: .degrees(0),
            endAngle: .degrees(360 * clamped)
        )
    }

    static var ringGradient: AngularGradient {
        ringGradient(progress: 1)
    }

    static let barGradient = LinearGradient(
        colors: [mint, emerald],
        startPoint: .bottom,
        endPoint: .top
    )

    /// Shared progress greens for the month heatmap and week bars.
    static func progressFill(for progress: Double) -> Color {
        switch progress {
        case 0:
            return foam
        case ..<0.25:
            return mint
        case ..<0.5:
            return mint.mix(with: emerald, by: 0.45)
        case ..<0.75:
            return emerald.opacity(0.78)
        case ..<1:
            return emerald
        default:
            return forest
        }
    }

    static func progressFill(grams: Int, goal: Int) -> Color {
        guard goal > 0 else { return foam }
        return progressFill(for: min(Double(grams) / Double(goal), 1))
    }
}

private extension Color {
    init(light: Color, dark: Color) {
        self.init(uiColor: UIColor { traits in
            traits.userInterfaceStyle == .dark ? UIColor(dark) : UIColor(light)
        })
    }
}
