import SwiftUI

struct GoalSelectionView: View {
    @Bindable var viewModel: OnboardingViewModel

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 28) {
                header

                VStack(spacing: 10) {
                    ForEach(viewModel.goals) { goal in
                        GoalOptionRow(goal: goal, isSelected: viewModel.selectedGoal == goal) {
                            viewModel.select(goal)
                        }
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 40)
            .padding(.bottom, 32)
        }
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Step 1 of 4")
                .font(.caption.weight(.semibold))
                .foregroundStyle(AppTheme.ink.opacity(0.45))

            Text("What do you want to achieve?")
                .font(.system(size: 34, weight: .bold, design: .rounded))
                .foregroundStyle(AppTheme.ink)

            Text("Tap the one that fits best. You can change it later in Settings.")
                .font(.subheadline)
                .foregroundStyle(AppTheme.ink.opacity(0.55))
        }
    }
}

#Preview {
    ZStack {
        AppTheme.background
        GoalSelectionView(viewModel: OnboardingViewModel(state: .preview, store: .seeded))
    }
}
