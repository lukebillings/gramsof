import Foundation

struct QuickAddItem: Identifiable, Hashable {
    let id: UUID
    var name: String
    var detail: String
    var grams: Int

    init(id: UUID = UUID(), name: String, detail: String, grams: Int) {
        self.id = id
        self.name = name
        self.detail = detail
        self.grams = grams
    }

    var emoji: String { FoodEmoji.forFood(named: name) }

    static let favourites: [QuickAddItem] = [
        QuickAddItem(name: "Greek yogurt", detail: "170g pot", grams: 17),
        QuickAddItem(name: "Chicken breast", detail: "120g", grams: 36),
        QuickAddItem(name: "Protein shake", detail: "1 scoop", grams: 25),
        QuickAddItem(name: "Eggs", detail: "2 large", grams: 12)
    ]
}
