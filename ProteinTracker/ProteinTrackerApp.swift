import SwiftUI

@main
struct ProteinTrackerApp: App {
    @State private var store = ProteinStore.seeded
    @State private var onboarding = OnboardingState()

    var body: some Scene {
        WindowGroup {
            RootView(store: store, onboarding: onboarding)
        }
    }
}
