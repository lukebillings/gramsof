import SwiftUI

/// Walks through Today → Stats → Settings after onboarding, then lands on Today.
struct HomeTutorialView: View {
    enum Step: Int, CaseIterable {
        case logProtein
        case pastLogs
        case settings

        var title: String {
            switch self {
            case .logProtein: "Log protein here"
            case .pastLogs: "See past logs"
            case .settings: "Tweak your settings"
            }
        }

        var message: String {
            switch self {
            case .logProtein:
                "Use Quick add or search on Today to log what you eat. Your ring fills as you go."
            case .pastLogs:
                "Stats shows your week and month history. Tap a day on the heatmap for that day’s log."
            case .settings:
                "Change your daily goal, reminders, and more anytime in Settings."
            }
        }

        var systemImage: String {
            switch self {
            case .logProtein: "flame.fill"
            case .pastLogs: "chart.bar.fill"
            case .settings: "gearshape.fill"
            }
        }

        var tabHint: String {
            switch self {
            case .logProtein: "Today"
            case .pastLogs: "Stats"
            case .settings: "Settings"
            }
        }

        var isLast: Bool { self == .settings }

        var next: Step? {
            Step(rawValue: rawValue + 1)
        }
    }

    var onStepChange: (Step) -> Void
    var onFinished: () -> Void

    @State private var step: Step = .logProtein

    var body: some View {
        ZStack {
            Color.black.opacity(0.45)
                .ignoresSafeArea()
                .onTapGesture {}

            VStack {
                Spacer()
                card
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 28)
        }
        .onAppear {
            onStepChange(step)
        }
    }

    private var card: some View {
        VStack(alignment: .leading, spacing: 18) {
            HStack(spacing: 12) {
                Image(systemName: step.systemImage)
                    .font(.title2.weight(.semibold))
                    .foregroundStyle(AppTheme.emerald)
                    .frame(width: 44, height: 44)
                    .glassEffect(.regular, in: .circle)

                VStack(alignment: .leading, spacing: 2) {
                    Text(step.tabHint.uppercased())
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(AppTheme.emerald)
                    Text(step.title)
                        .font(.title3.weight(.bold))
                        .foregroundStyle(AppTheme.ink)
                }

                Spacer(minLength: 0)
            }

            Text(step.message)
                .font(.subheadline)
                .foregroundStyle(AppTheme.ink.opacity(0.65))
                .fixedSize(horizontal: false, vertical: true)

            progressDots

            Button {
                advance()
            } label: {
                Text(step.isLast ? "Go to Today" : "Next")
                    .font(.body.weight(.semibold))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
            }
            .buttonStyle(.glassProminent)
            .tint(AppTheme.emerald)
        }
        .padding(22)
        .glassEffect(.regular, in: .rect(cornerRadius: 28))
    }

    private var progressDots: some View {
        HStack(spacing: 8) {
            ForEach(Step.allCases, id: \.rawValue) { candidate in
                Capsule()
                    .fill(candidate == step ? AppTheme.emerald : AppTheme.ink.opacity(0.18))
                    .frame(width: candidate == step ? 22 : 8, height: 8)
                    .animation(.smooth(duration: 0.25), value: step)
            }
            Spacer(minLength: 0)
        }
    }

    private func advance() {
        if let next = step.next {
            withAnimation(.smooth(duration: 0.3)) {
                step = next
            }
            onStepChange(next)
        } else {
            onFinished()
        }
    }
}

#Preview {
    ZStack {
        AppTheme.background
        HomeTutorialView(onStepChange: { _ in }, onFinished: {})
    }
}
