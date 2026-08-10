import SwiftUI

struct OnboardingFlowView: View {
    @State private var viewModel: OnboardingViewModel

    init(state: OnboardingState, store: ProteinStore) {
        _viewModel = State(initialValue: OnboardingViewModel(state: state, store: store))
    }

    var body: some View {
        ZStack {
            AppTheme.background

            switch viewModel.step {
            case .goal:
                GoalSelectionView(viewModel: viewModel)
                    .transition(.asymmetric(
                        insertion: .move(edge: .trailing).combined(with: .opacity),
                        removal: .move(edge: .leading).combined(with: .opacity)
                    ))
            case .paywall:
                PaywallView(viewModel: viewModel)
                    .transition(.asymmetric(
                        insertion: .move(edge: .trailing).combined(with: .opacity),
                        removal: .move(edge: .leading).combined(with: .opacity)
                    ))
            case .dailyTarget:
                DailyProteinTargetView(viewModel: viewModel)
                    .transition(.asymmetric(
                        insertion: .move(edge: .trailing).combined(with: .opacity),
                        removal: .move(edge: .leading).combined(with: .opacity)
                    ))
            case .notifications:
                NotificationsOptInView(viewModel: viewModel)
                    .transition(.asymmetric(
                        insertion: .move(edge: .trailing).combined(with: .opacity),
                        removal: .move(edge: .leading).combined(with: .opacity)
                    ))
            }
        }
        .animation(.smooth(duration: 0.3), value: viewModel.step)
    }
}

#Preview {
    OnboardingFlowView(state: .preview, store: .seeded)
}
