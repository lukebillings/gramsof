import SwiftUI

struct NotificationsOptInView: View {
    @Bindable var viewModel: OnboardingViewModel
    @State private var isFinishing = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 28) {
                backButton
                header
                choiceCard
            }
            .padding(.horizontal, 20)
            .padding(.top, 8)
            .padding(.bottom, 24)
        }
        .safeAreaInset(edge: .bottom) { continueBar }
    }

    private var backButton: some View {
        Button {
            viewModel.backToDailyTarget()
        } label: {
            Image(systemName: "chevron.left")
                .font(.body.weight(.semibold))
                .padding(6)
        }
        .buttonStyle(.glass)
        .tint(AppTheme.emerald)
        .accessibilityLabel("Back to daily target")
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Want a daily logging reminder?")
                .font(.system(size: 34, weight: .bold, design: .rounded))
                .foregroundStyle(AppTheme.ink)

            Text("We'll nudge you around 6pm by default. You can pick any time in Settings.")
                .font(.subheadline)
                .foregroundStyle(AppTheme.ink.opacity(0.55))
        }
    }

    private var choiceCard: some View {
        VStack(spacing: 12) {
            reminderOption(
                title: "Yes, remind me",
                detail: "Daily at 6pm — change the time in Settings",
                symbol: "bell.badge.fill",
                isSelected: viewModel.remindersEnabled
            ) {
                viewModel.remindersEnabled = true
            }

            reminderOption(
                title: "Not now",
                detail: "You can turn this on later in Settings",
                symbol: "bell.slash.fill",
                isSelected: !viewModel.remindersEnabled
            ) {
                viewModel.remindersEnabled = false
            }
        }
    }

    private func reminderOption(
        title: String,
        detail: String,
        symbol: String,
        isSelected: Bool,
        action: @escaping () -> Void
    ) -> some View {
        Button(action: action) {
            HStack(spacing: 14) {
                Image(systemName: symbol)
                    .font(.title3)
                    .foregroundStyle(isSelected ? AppTheme.emerald : AppTheme.ink.opacity(0.35))
                    .frame(width: 28)

                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.body.weight(.semibold))
                        .foregroundStyle(AppTheme.ink)

                    Text(detail)
                        .font(.caption)
                        .foregroundStyle(AppTheme.ink.opacity(0.55))
                }

                Spacer(minLength: 0)

                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .font(.title3)
                    .foregroundStyle(isSelected ? AppTheme.emerald : AppTheme.ink.opacity(0.25))
            }
            .padding(18)
            .frame(maxWidth: .infinity, alignment: .leading)
            .glassEffect(.regular, in: .rect(cornerRadius: 20))
            .overlay {
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .strokeBorder(isSelected ? AppTheme.emerald.opacity(0.55) : .clear, lineWidth: 2)
            }
        }
        .buttonStyle(.plain)
    }

    private var continueBar: some View {
        Button {
            guard !isFinishing else { return }
            isFinishing = true
            Task {
                await viewModel.finish()
                isFinishing = false
            }
        } label: {
            Text("Continue")
                .font(.body.weight(.semibold))
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
        }
        .buttonStyle(.glassProminent)
        .tint(AppTheme.emerald)
        .disabled(isFinishing)
        .padding(.horizontal, 20)
        .padding(.top, 12)
        .padding(.bottom, 8)
    }
}

#Preview {
    ZStack {
        AppTheme.background
        NotificationsOptInView(viewModel: OnboardingViewModel(state: .preview, store: .seeded, subscriptions: SubscriptionStore()))
    }
}
