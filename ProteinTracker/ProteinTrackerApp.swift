import SwiftUI

@main
struct ProteinTrackerApp: App {
    @State private var store = ProteinStore.seeded
    @State private var onboarding = OnboardingState()
    @State private var customFoods = CustomFoodDirectory()
    @State private var appearance = AppearanceSettings()

    var body: some Scene {
        WindowGroup {
            RootView(
                store: store,
                onboarding: onboarding,
                customFoods: customFoods,
                appearance: appearance
            )
        }
    }
}
