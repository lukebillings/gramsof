import SwiftUI

struct PaywallView: View {
    @Bindable var viewModel: OnboardingViewModel

    private struct Benefit: Identifiable {
        let id = UUID()
        let title: String
        let symbol: String
    }

    private let benefits: [Benefit] = [
        Benefit(title: "Unlimited logging", symbol: "list.bullet.clipboard.fill"),
        Benefit(title: "Protein trends", symbol: "chart.bar.fill"),
        Benefit(title: "Quick-add favourites", symbol: "star.fill"),
        Benefit(title: "Daily reminders", symbol: "bell.badge.fill")
    ]

    private let columns = [
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12)
    ]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                backButton
                header
                benefitsGrid
                plansSection
            }
            .padding(.horizontal, 20)
            .padding(.top, 8)
            .padding(.bottom, 88)
        }
        .safeAreaInset(edge: .bottom) { checkoutBar }
    }

    private var backButton: some View {
        Button {
            viewModel.backToGoal()
        } label: {
            Image(systemName: "chevron.left")
                .font(.caption.weight(.semibold))
                .padding(4)
        }
        .buttonStyle(.glass)
        .tint(AppTheme.emerald)
        .accessibilityLabel("Back to goals")
        .controlSize(.small)
    }

    private var header: some View {
        Text("Help reach your protein goals with Gramsof: Track Protein Intake")
            .font(.system(size: 24, weight: .bold, design: .rounded))
            .foregroundStyle(AppTheme.ink)
            .fixedSize(horizontal: false, vertical: true)
            .frame(maxWidth: .infinity, alignment: .leading)
    }

    private var benefitsGrid: some View {
        LazyVGrid(columns: columns, spacing: 10) {
            ForEach(benefits) { benefit in
                VStack(spacing: 8) {
                    Image(systemName: benefit.symbol)
                        .font(.body.weight(.semibold))
                        .foregroundStyle(AppTheme.emerald)
                        .frame(width: 32, height: 32)
                        .background(AppTheme.mint.opacity(0.7), in: .circle)

                    Text(benefit.title)
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(AppTheme.ink)
                        .multilineTextAlignment(.center)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .frame(maxWidth: .infinity, minHeight: 84)
                .padding(.horizontal, 10)
                .padding(.vertical, 12)
                .glassEffect(.regular, in: .rect(cornerRadius: 18))
            }
        }
    }

    private var plansSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            ForEach(viewModel.plans) { plan in
                PlanOptionCard(plan: plan, isSelected: viewModel.selectedPlan == plan) {
                    viewModel.select(plan)
                }
            }
        }
    }

    private var checkoutBar: some View {
        VStack(spacing: 10) {
            HStack(spacing: 6) {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundStyle(AppTheme.emerald)
                Text("Cancel anytime in Settings")
                    .foregroundStyle(AppTheme.ink.opacity(0.55))
            }
            .font(.caption.weight(.medium))

            legalSmallPrint

            Button {
                viewModel.continueFromPaywall()
            } label: {
                Text("Continue")
                    .font(.body.weight(.semibold))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
            }
            .buttonStyle(.glassProminent)
            .tint(AppTheme.emerald)
        }
        .padding(.horizontal, 20)
        .padding(.top, 12)
        .padding(.bottom, 8)
    }

    private var legalSmallPrint: some View {
        VStack(spacing: 6) {
            Text("By continuing, you agree to our Terms and Conditions, Privacy Policy, and Terms of Service.")
                .font(.caption2)
                .foregroundStyle(AppTheme.ink.opacity(0.45))
                .multilineTextAlignment(.center)
                .fixedSize(horizontal: false, vertical: true)

            HStack(spacing: 6) {
                Link("Terms and Conditions", destination: LegalLinks.termsAndConditions)
                Text("·")
                    .foregroundStyle(AppTheme.ink.opacity(0.3))
                Link("Privacy Policy", destination: LegalLinks.privacyPolicy)
                Text("·")
                    .foregroundStyle(AppTheme.ink.opacity(0.3))
                Link("Terms of Service", destination: LegalLinks.termsOfService)
            }
            .font(.caption2.weight(.medium))
            .tint(AppTheme.emerald.opacity(0.85))
            .minimumScaleFactor(0.8)
            .lineLimit(1)

            Button("Restore purchases") {
                Task { await viewModel.restorePurchases() }
            }
            .font(.caption2.weight(.medium))
            .foregroundStyle(AppTheme.ink.opacity(0.45))
            .buttonStyle(.plain)
        }
        .padding(.bottom, 2)
    }
}

#Preview {
    ZStack {
        AppTheme.background

        PaywallView(viewModel: {
            let viewModel = OnboardingViewModel(state: .preview, store: .seeded)
            viewModel.selectedGoal = .buildMuscle
            return viewModel
        }())
    }
}
