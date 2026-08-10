import SwiftUI

struct RootView: View {
    private enum AppTab: Hashable {
        case today
        case stats
        case settings
    }

    @State private var homeViewModel: HomeViewModel
    @State private var statsViewModel: StatsViewModel
    @State private var settingsViewModel: SettingsViewModel
    @State private var selection: AppTab = .today

    init(store: ProteinStore) {
        _homeViewModel = State(initialValue: HomeViewModel(store: store))
        _statsViewModel = State(initialValue: StatsViewModel(store: store))
        _settingsViewModel = State(initialValue: SettingsViewModel(store: store))
    }

    var body: some View {
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
    RootView(store: .seeded)
}
