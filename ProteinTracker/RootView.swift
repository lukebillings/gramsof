import SwiftUI
import UIKit

struct RootView: View {
    private enum AppTab: Hashable {
        case today
        case stats
        case settings
    }

    private let store: ProteinStore
    private let onboarding: OnboardingState
    private let appearance: AppearanceSettings
    private let subscriptions: SubscriptionStore
    private let engagement: AppEngagement

    @State private var homeViewModel: HomeViewModel
    @State private var statsViewModel: StatsViewModel
    @State private var settingsViewModel: SettingsViewModel
    @State private var selection: AppTab = .today
    @State private var showsDay1CheckIn = false

    init(
        store: ProteinStore,
        onboarding: OnboardingState,
        customFoods: CustomFoodDirectory,
        quickAdd: QuickAddDirectory,
        appearance: AppearanceSettings,
        haptics: HapticSettings,
        subscriptions: SubscriptionStore,
        engagement: AppEngagement
    ) {
        self.store = store
        self.onboarding = onboarding
        self.appearance = appearance
        self.subscriptions = subscriptions
        self.engagement = engagement
        _homeViewModel = State(initialValue: HomeViewModel(store: store, customFoods: customFoods, quickAdd: quickAdd))
        _statsViewModel = State(initialValue: StatsViewModel(store: store))
        _settingsViewModel = State(
            initialValue: SettingsViewModel(
                store: store,
                onboarding: onboarding,
                customFoods: customFoods,
                quickAdd: quickAdd,
                appearance: appearance,
                haptics: haptics,
                engagement: engagement
            )
        )
    }

    var body: some View {
        Group {
            if onboarding.hasCompleted {
                tabs
            } else {
                OnboardingFlowView(
                    state: onboarding,
                    store: store,
                    subscriptions: subscriptions,
                    engagement: engagement
                )
            }
        }
        .animation(.smooth(duration: 0.3), value: onboarding.hasCompleted)
        .preferredColorScheme(appearance.preference.colorScheme)
        .onAppear {
            engagement.migrateLegacyUserIfNeeded(onboardingCompleted: onboarding.hasCompleted)
            presentDay1CheckInIfNeeded()
        }
        .onChange(of: engagement.hasSeenHomeTutorial) { _, _ in
            presentDay1CheckInIfNeeded()
        }
        .onChange(of: settingsViewModel.presentsDay1CheckIn) { _, shouldPresent in
            if shouldPresent {
                showsDay1CheckIn = true
                settingsViewModel.presentsDay1CheckIn = false
            }
        }
        .sheet(isPresented: $showsDay1CheckIn) {
            Day1CheckInView(
                onAllGood: {
                    engagement.markDay1CheckInCompleted()
                    showsDay1CheckIn = false
                },
                onReplayTutorial: {
                    engagement.markDay1CheckInCompleted()
                    showsDay1CheckIn = false
                    engagement.startTutorialReplay()
                    selection = .today
                },
                onRequestFeature: {
                    engagement.markDay1CheckInCompleted()
                    showsDay1CheckIn = false
                    openFeatureRequest()
                }
            )
            .presentationDetents([.medium])
            .presentationDragIndicator(.visible)
        }
    }

    private var tabs: some View {
        TabView(selection: $selection) {
            Tab("Today", systemImage: "flame.fill", value: .today) {
                HomeView(viewModel: homeViewModel, engagement: engagement)
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
        .overlay {
            if engagement.shouldShowHomeTutorial {
                HomeTutorialView(
                    onStepChange: { step in
                        withAnimation(.smooth(duration: 0.3)) {
                            selection = tab(for: step)
                        }
                    },
                    onFinished: {
                        engagement.markHomeTutorialSeen()
                        withAnimation(.smooth(duration: 0.3)) {
                            selection = .today
                        }
                    }
                )
                .transition(.opacity)
                .zIndex(1)
            }
        }
        .animation(.smooth(duration: 0.3), value: engagement.shouldShowHomeTutorial)
    }

    private func tab(for step: HomeTutorialView.Step) -> AppTab {
        switch step {
        case .logProtein: .today
        case .pastLogs: .stats
        case .settings: .settings
        }
    }

    private func presentDay1CheckInIfNeeded() {
        guard engagement.shouldShowDay1CheckIn, !showsDay1CheckIn else { return }
        // Let the home UI settle after tutorial / onboarding.
        Task { @MainActor in
            try? await Task.sleep(for: .milliseconds(600))
            guard engagement.shouldShowDay1CheckIn else { return }
            showsDay1CheckIn = true
        }
    }

    private func openFeatureRequest() {
        UIApplication.shared.open(LegalLinks.featureRequest)
    }
}

#Preview {
    RootView(
        store: .seeded,
        onboarding: .preview,
        customFoods: .preview,
        quickAdd: .preview,
        appearance: AppearanceSettings(),
        haptics: HapticSettings(),
        subscriptions: SubscriptionStore(),
        engagement: .preview
    )
}
