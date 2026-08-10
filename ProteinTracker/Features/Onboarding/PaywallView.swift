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
                .font(.body.weight(.semibold))
                .padding(6)
        }
        .buttonStyle(.glass)
        .tint(AppTheme.emerald)
        .accessibilityLabel("Back to goals")
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Step 2 of 4")
                .font(.caption.weight(.semibold))
                .foregroundStyle(AppTheme.ink.opacity(0.45))

            Text("Go Pro and hit your target")
                .font(.system(size: 24, weight: .bold, design: .rounded))
                .foregroundStyle(AppTheme.ink)
                .lineLimit(1)
                .minimumScaleFactor(0.7)
                .frame(maxWidth: .infinity, alignment: .leading)

            if let goal = viewModel.selectedGoal {
                Text("Everything you need to \(goal.title.lowercased()).")
                    .font(.subheadline)
                    .foregroundStyle(AppTheme.ink.opacity(0.55))
            }
        }
    }

    private var benefitsGrid: some View {
        LazyVGrid(columns: columns, spacing: 12) {
            ForEach(benefits) { benefit in
                VStack(spacing: 12) {
                    Image(systemName: benefit.symbol)
                        .font(.title2.weight(.semibold))
                        .foregroundStyle(AppTheme.emerald)
                        .frame(width: 44, height: 44)
                        .background(AppTheme.mint.opacity(0.7), in: .circle)

                    Text(benefit.title)
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(AppTheme.ink)
                        .multilineTextAlignment(.center)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .frame(maxWidth: .infinity, minHeight: 120)
                .padding(16)
                .glassEffect(.regular, in: .rect(cornerRadius: 22))
            }
        }
    }

    private var plansSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Choose a plan")
                .font(.title3.weight(.bold))
                .foregroundStyle(AppTheme.ink)

            ForEach(viewModel.plans) { plan in
                PlanOptionCard(plan: plan, isSelected: viewModel.selectedPlan == plan) {
                    viewModel.select(plan)
                }
            }
        }
    }

    private var checkoutBar: some View {
        VStack(spacing: 10) {
            Text(viewModel.selectedPlan.checkoutNote)
                .font(.caption)
                .foregroundStyle(AppTheme.ink.opacity(0.55))
                .multilineTextAlignment(.center)

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
