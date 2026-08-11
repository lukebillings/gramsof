import SwiftUI

struct RootView: View {
    private enum AppTab: Hashable {
        case today
        case stats
        case settings
    }

    private let store: ProteinStore
    private let onboarding: OnboardingState
    private let appearance: AppearanceSettings

    @State private var homeViewModel: HomeViewModel
    @State private var statsViewModel: StatsViewModel
    @State private var settingsViewModel: SettingsViewModel
    @State private var selection: AppTab = .today

    init(
        store: ProteinStore,
        onboarding: OnboardingState,
        customFoods: CustomFoodDirectory,
        appearance: AppearanceSettings
    ) {
        self.store = store
        self.onboarding = onboarding
        self.appearance = appearance
        _homeViewModel = State(initialValue: HomeViewModel(store: store, customFoods: customFoods))
        _statsViewModel = State(initialValue: StatsViewModel(store: store))
        _settingsViewModel = State(
            initialValue: SettingsViewModel(
                store: store,
                onboarding: onboarding,
                customFoods: customFoods,
                appearance: appearance
            )
        )
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
        .preferredColorScheme(appearance.preference.colorScheme)
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
    RootView(
        store: .seeded,
        onboarding: .preview,
        customFoods: .preview,
        appearance: AppearanceSettings()
    )
}
