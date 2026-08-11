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
        Text("Why do you want to track your protein?")
            .font(.system(size: 34, weight: .bold, design: .rounded))
            .foregroundStyle(AppTheme.ink)
    }
}

#Preview {
    ZStack {
        AppTheme.background
        GoalSelectionView(viewModel: OnboardingViewModel(state: .preview, store: .seeded))
    }
}
