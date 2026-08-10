import Foundation
import Observation

@Observable
final class HomeViewModel {
    let store: ProteinStore
    let customFoods: CustomFoodDirectory
    var draft: String = ""

    let favourites: [QuickAddItem] = QuickAddItem.favourites

    init(store: ProteinStore, customFoods: CustomFoodDirectory = CustomFoodDirectory()) {
        self.store = store
        self.customFoods = customFoods
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

    var suggestions: [FoodSuggestion] {
        FoodLookup.suggestions(for: draft, including: customFoods.foodItems)
    }

    /// Shown under search results so the user can save an unknown food.
    var customFoodCandidate: String? {
        guard let name = FoodLookup.customNameCandidate(in: draft) else { return nil }

        // Hide when the top suggestion is already an exact match for that name.
        if let top = suggestions.first, top.name.compare(name, options: .caseInsensitive) == .orderedSame {
            return nil
        }

        return name
    }

    var canSubmitDraft: Bool {
        !suggestions.isEmpty || parse(draft) != nil
    }

    // MARK: - Logging

    func add(_ item: QuickAddItem) {
        store.add(ProteinEntry(name: item.name, grams: item.grams))
    }

    func submitDraft() {
        if let suggestion = suggestions.first {
            log(suggestion)
            return
        }

        guard let parsed = parse(draft) else { return }
        store.add(ProteinEntry(name: parsed.name, grams: parsed.grams))
        draft = ""
    }

    func log(_ suggestion: FoodSuggestion) {
        store.add(ProteinEntry(name: suggestion.name, grams: suggestion.grams))
        draft = ""
    }

    func addCustomFood(named name: String, proteinGrams: Int) {
        let food = customFoods.upsert(name: name, proteinGrams: proteinGrams)
        store.add(ProteinEntry(name: food.name, grams: food.proteinGrams))
        draft = ""
    }

    func delete(_ entry: ProteinEntry) {
        store.remove(entry)
    }

    func updateGrams(for entry: ProteinEntry, to grams: Int) {
        store.updateGrams(for: entry, to: grams)
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
