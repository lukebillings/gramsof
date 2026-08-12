import SwiftUI

struct DailyProteinTargetView: View {
    @Bindable var viewModel: OnboardingViewModel
    @FocusState private var isTargetFocused: Bool

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 28) {
                backButton
                header
                targetCard
            }
            .padding(.horizontal, 20)
            .padding(.top, 8)
            .padding(.bottom, 24)
        }
        .scrollDismissesKeyboard(.interactively)
        .safeAreaInset(edge: .bottom) { continueBar }
        .onAppear { isTargetFocused = true }
    }

    private var backButton: some View {
        Button {
            viewModel.backToPaywall()
        } label: {
            Image(systemName: "chevron.left")
                .font(.body.weight(.semibold))
                .padding(6)
        }
        .buttonStyle(.glass)
        .tint(AppTheme.emerald)
        .accessibilityLabel("Back to plans")
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("What's your daily protein target?")
                .font(.system(size: 34, weight: .bold, design: .rounded))
                .foregroundStyle(AppTheme.ink)

            Text(viewModel.suggestedRangeLabel)
                .font(.subheadline)
                .foregroundStyle(AppTheme.ink.opacity(0.55))
        }
    }

    private var targetCard: some View {
        VStack(spacing: 12) {
            HStack(alignment: .firstTextBaseline, spacing: 4) {
                TextField("", value: $viewModel.dailyGoal, format: .number)
                    .font(.system(size: 64, weight: .bold, design: .rounded))
                    .foregroundStyle(AppTheme.ink)
                    .keyboardType(.numberPad)
                    .multilineTextAlignment(.center)
                    .focused($isTargetFocused)
                    .frame(minWidth: 120)

                Text("g")
                    .font(.system(size: 34, weight: .bold, design: .rounded))
                    .foregroundStyle(AppTheme.ink.opacity(0.45))
            }

            Text("Type your target · \(viewModel.goalRange.lowerBound)–\(viewModel.goalRange.upperBound)g")
                .font(.subheadline.weight(.medium))
                .foregroundStyle(AppTheme.ink.opacity(0.45))

            Text(LegalLinks.proteinTargetDisclaimer)
                .font(.caption)
                .foregroundStyle(AppTheme.ink.opacity(0.4))
                .multilineTextAlignment(.center)
                .fixedSize(horizontal: false, vertical: true)
                .padding(.top, 4)
        }
        .frame(maxWidth: .infinity)
        .padding(24)
        .glassEffect(.regular, in: .rect(cornerRadius: 24))
    }

    private var continueBar: some View {
        Button {
            isTargetFocused = false
            viewModel.continueFromDailyTarget()
        } label: {
            Text("Continue")
                .font(.body.weight(.semibold))
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
        }
        .buttonStyle(.glassProminent)
        .tint(AppTheme.emerald)
        .disabled(!viewModel.hasValidDailyGoal)
        .padding(.horizontal, 20)
        .padding(.top, 12)
        .padding(.bottom, 8)
    }
}

#Preview {
    ZStack {
        AppTheme.background
        DailyProteinTargetView(viewModel: OnboardingViewModel(
            state: .preview,
            store: .seeded,
            subscriptions: SubscriptionStore(),
            engagement: .preview
        ))
    }
}
