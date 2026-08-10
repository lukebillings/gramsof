import SwiftUI

@main
struct ProteinTrackerApp: App {
    @State private var store = ProteinStore.seeded

    var body: some Scene {
        WindowGroup {
            RootView(store: store)
        }
    }
}
