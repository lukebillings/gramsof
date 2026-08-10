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
}
