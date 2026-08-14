import Foundation

struct ProteinEntry: Identifiable, Hashable {
    let id: UUID
    var name: String
    var grams: Int
    var loggedAt: Date

    init(id: UUID = UUID(), name: String, grams: Int, loggedAt: Date = .now) {
        self.id = id
        self.name = name
        self.grams = grams
        self.loggedAt = loggedAt
    }

    var emoji: String { FoodEmoji.forFood(named: name) }

    /// Includes how many / how much when the stored name is just the food, e.g. "3 eggs".
    var displayName: String {
        let trimmed = name.trimmingCharacters(in: .whitespacesAndNewlines)
        if let first = trimmed.first, first.isNumber {
            return name
        }
        guard let food = FoodDatabase.food(matching: name) else { return name }
        return food.logTitle(portionLabel: food.inferredPortionLabel(proteinGrams: grams))
    }
}
