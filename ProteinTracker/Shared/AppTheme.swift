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

    static var ringGradient: AngularGradient {
        AngularGradient(
            colors: [emerald, mint, emerald],
            center: .center,
            startAngle: .degrees(0),
            endAngle: .degrees(360)
        )
    }

    static let barGradient = LinearGradient(
        colors: [mint, emerald],
        startPoint: .bottom,
        endPoint: .top
    )
}

private extension Color {
    init(light: Color, dark: Color) {
        self.init(uiColor: UIColor { traits in
            traits.userInterfaceStyle == .dark ? UIColor(dark) : UIColor(light)
        })
    }
}
