import SwiftUI

/// Soft check-in the calendar day after onboarding (also launchable from Settings).
struct Day1CheckInView: View {
    enum Phase {
        case ask
        case needHelp
    }

    var onAllGood: () -> Void
    var onReplayTutorial: () -> Void
    var onRequestFeature: () -> Void

    @State private var phase: Phase = .ask

    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                header
                content
                Spacer(minLength: 0)
            }
            .padding(.horizontal, 24)
            .padding(.top, 12)
            .padding(.bottom, 24)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .background(AppTheme.background)
            .navigationTitle("Check-in")
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    private var header: some View {
        VStack(spacing: 10) {
            Image(systemName: phase == .ask ? "hand.wave.fill" : "lifepreserver.fill")
                .font(.system(size: 36, weight: .semibold))
                .foregroundStyle(AppTheme.emerald)
                .padding(.top, 8)

            Text(phase == .ask ? "How’s day one going?" : "What would help?")
                .font(.title2.weight(.bold))
                .foregroundStyle(AppTheme.ink)
                .multilineTextAlignment(.center)

            Text(phase == .ask
                 ? "A quick check-in — all good, or want a hand?"
                 : "Replay the tour, or tell us what you’d like added.")
                .font(.subheadline)
                .foregroundStyle(AppTheme.ink.opacity(0.55))
                .multilineTextAlignment(.center)
        }
    }

    @ViewBuilder
    private var content: some View {
        switch phase {
        case .ask:
            VStack(spacing: 12) {
                primaryButton("All good", systemImage: "hand.thumbsup.fill") {
                    onAllGood()
                }

                secondaryButton("I need help", systemImage: "questionmark.circle") {
                    withAnimation(.smooth(duration: 0.25)) {
                        phase = .needHelp
                    }
                }
            }
        case .needHelp:
            VStack(spacing: 12) {
                primaryButton("Replay tutorial", systemImage: "sparkles") {
                    onReplayTutorial()
                }

                secondaryButton("Request a feature", systemImage: "lightbulb") {
                    onRequestFeature()
                }

                Button("Actually, I’m fine") {
                    onAllGood()
                }
                .font(.subheadline.weight(.medium))
                .foregroundStyle(AppTheme.ink.opacity(0.45))
                .padding(.top, 4)
            }
        }
    }

    private func primaryButton(_ title: String, systemImage: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Label(title, systemImage: systemImage)
                .font(.body.weight(.semibold))
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
        }
        .buttonStyle(.glassProminent)
        .tint(AppTheme.emerald)
    }

    private func secondaryButton(_ title: String, systemImage: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Label(title, systemImage: systemImage)
                .font(.body.weight(.semibold))
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
        }
        .buttonStyle(.glass)
        .tint(AppTheme.emerald)
    }
}

#Preview {
    Day1CheckInView(
        onAllGood: {},
        onReplayTutorial: {},
        onRequestFeature: {}
    )
}
