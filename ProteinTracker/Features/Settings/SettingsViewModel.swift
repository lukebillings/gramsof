import Foundation
import Observation

@Observable
final class SettingsViewModel {
    let store: ProteinStore

    var remindersEnabled = true

    let goalRange = 60...300

    init(store: ProteinStore) {
        self.store = store
    }

    var dailyGoal: Int {
        get { store.dailyGoal }
        set { store.dailyGoal = min(max(newValue, goalRange.lowerBound), goalRange.upperBound) }
    }

    var showsRemainingOnRing: Bool {
        get { store.showsRemainingOnRing }
        set { store.showsRemainingOnRing = newValue }
    }

    var loggedEntryCount: Int { store.entries.count }

    func resetToday() {
        for entry in store.todayEntries {
            store.remove(entry)
        }
    }
}
