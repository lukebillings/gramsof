import Foundation
import Observation

@Observable
final class HomeViewModel {
    let store: ProteinStore
    var draft: String = ""

    let quickAmounts: [Int] = [20, 30, 40]
    let favourites: [QuickAddItem] = QuickAddItem.favourites

    init(store: ProteinStore) {
        self.store = store
    }

    var goal: Int { store.dailyGoal }
    var total: Int { store.todayTotal }
    var remaining: Int { max(store.dailyGoal - store.todayTotal, 0) }
    var todayEntries: [ProteinEntry] { store.todayEntries }
    var hasReachedGoal: Bool { store.todayTotal >= store.dailyGoal }
    var showsRemaining: Bool { store.showsRemainingOnRing }

    var progress: Double {
        guard store.dailyGoal > 0 else { return 0 }
        return Double(store.todayTotal) / Double(store.dailyGoal)
    }

    var canSubmitDraft: Bool {
        parse(draft) != nil
    }

    // MARK: - Logging

    func addAmount(_ grams: Int) {
        store.add(ProteinEntry(name: "Quick add", grams: grams))
    }

    func add(_ item: QuickAddItem) {
        store.add(ProteinEntry(name: item.name, grams: item.grams))
    }

    func submitDraft() {
        guard let parsed = parse(draft) else { return }
        store.add(ProteinEntry(name: parsed.name, grams: parsed.grams))
        draft = ""
    }

    func delete(_ entry: ProteinEntry) {
        store.remove(entry)
    }

    /// Accepts free text like "chicken 40", "40 chicken" or just "40".
    private func parse(_ text: String) -> (name: String, grams: Int)? {
        let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return nil }

        let words = trimmed.split(separator: " ").map(String.init)
        guard let numberIndex = words.firstIndex(where: { Int($0) != nil }),
              let grams = Int(words[numberIndex]), grams > 0
        else { return nil }

        var nameWords = words
        nameWords.remove(at: numberIndex)
        let name = nameWords.joined(separator: " ")

        return (name.isEmpty ? "Quick add" : name.capitalized, grams)
    }
}
