import SwiftUI

struct RootView: View {
    private enum AppTab: Hashable {
        case today
        case stats
        case settings
    }

    private let store: ProteinStore
    private let onboarding: OnboardingState

    @State private var homeViewModel: HomeViewModel
    @State private var statsViewModel: StatsViewModel
    @State private var settingsViewModel: SettingsViewModel
    @State private var selection: AppTab = .today

    init(store: ProteinStore, onboarding: OnboardingState) {
        self.store = store
        self.onboarding = onboarding
        _homeViewModel = State(initialValue: HomeViewModel(store: store))
        _statsViewModel = State(initialValue: StatsViewModel(store: store))
        _settingsViewModel = State(initialValue: SettingsViewModel(store: store, onboarding: onboarding))
    }

    var body: some View {
        Group {
            if onboarding.hasCompleted {
                tabs
            } else {
                OnboardingFlowView(state: onboarding, store: store)
            }
        }
        .animation(.smooth(duration: 0.3), value: onboarding.hasCompleted)
    }

    private var tabs: some View {
        TabView(selection: $selection) {
            Tab("Today", systemImage: "flame.fill", value: .today) {
                HomeView(viewModel: homeViewModel)
            }

            Tab("Stats", systemImage: "chart.bar.fill", value: .stats) {
                StatsView(viewModel: statsViewModel)
            }

            Tab("Settings", systemImage: "gearshape.fill", value: .settings) {
                SettingsView(viewModel: settingsViewModel)
            }
        }
        .tabBarMinimizeBehavior(.onScrollDown)
        .tint(AppTheme.emerald)
    }
}

#Preview {
    RootView(store: .seeded, onboarding: .preview)
}
