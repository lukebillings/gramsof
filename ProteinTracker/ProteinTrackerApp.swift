import SwiftUI

@main
struct ProteinTrackerApp: App {
    @State private var store = ProteinStore.seeded
    @State private var onboarding = OnboardingState()
    @State private var customFoods = CustomFoodDirectory()
    @State private var quickAdd = QuickAddDirectory()
    @State private var appearance = AppearanceSettings()
    @State private var haptics = HapticSettings()
    @State private var subscriptions = SubscriptionStore()
    @State private var engagement = AppEngagement()
    @State private var showsSplash = true

    var body: some Scene {
        WindowGroup {
            ZStack {
                RootView(
                    store: store,
                    onboarding: onboarding,
                    customFoods: customFoods,
                    quickAdd: quickAdd,
                    appearance: appearance,
                    haptics: haptics,
                    subscriptions: subscriptions,
                    engagement: engagement
                )

                if showsSplash {
                    SplashView()
                        .transition(.opacity)
                        .zIndex(1)
                }
            }
            .onAppear {
                AppHaptics.configure(haptics)
                Task { @MainActor in
                    try? await Task.sleep(for: .milliseconds(1400))
                    withAnimation(.easeOut(duration: 0.35)) {
                        showsSplash = false
                    }
                }
            }
            .task {
                await subscriptions.loadProducts()
            }
        }
    }
}
