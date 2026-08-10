import SwiftUI

enum AppTheme {
    static let ink = Color(red: 0.07, green: 0.14, blue: 0.11)
    static let forest = Color(red: 0.10, green: 0.24, blue: 0.18)
    static let emerald = Color(red: 0.12, green: 0.56, blue: 0.37)
    static let mint = Color(red: 0.72, green: 0.94, blue: 0.82)
    static let foam = Color(red: 0.95, green: 0.98, blue: 0.96)

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
