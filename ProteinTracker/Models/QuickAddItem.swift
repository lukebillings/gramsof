import Foundation

struct QuickAddItem: Identifiable, Hashable, Codable {
    let id: UUID
    var name: String
    var detail: String
    var grams: Int
    var portionGrams: Int?
    var proteinPer100g: Double?

    init(
        id: UUID = UUID(),
        name: String,
        detail: String,
        grams: Int,
        portionGrams: Int? = nil,
        proteinPer100g: Double? = nil
    ) {
        self.id = id
        self.name = name
        self.detail = detail
        self.grams = grams
        self.portionGrams = portionGrams
        self.proteinPer100g = proteinPer100g
    }

    var emoji: String { FoodEmoji.forFood(named: name) }

    var portionDescription: String {
        let raw: String
        if !detail.isEmpty {
            raw = detail
        } else if let portionGrams {
            raw = Self.gramsLabel(portionGrams, of: name)
        } else {
            return name
        }

        return raw.replacingOccurrences(of: "g of ", with: "g ", options: .caseInsensitive)
    }

    /// Portion as shown on the quick-add card, e.g. "100g Greek yogurt" or "1 scoop".
    var shortcutLabel: String {
        portionDescription
    }

    var canRecalculateProtein: Bool {
        proteinPer100g != nil && portionGrams != nil
    }

    mutating func setPortionGrams(_ newPortion: Int) {
        portionGrams = newPortion
        if let proteinPer100g {
            grams = max(1, Int((proteinPer100g * Double(newPortion) / 100).rounded()))
        }
        if usesWeightLabel {
            detail = Self.gramsLabel(newPortion, of: name)
        }
    }

    private var usesWeightLabel: Bool {
        let lowered = detail.lowercased()
        return lowered.contains("g of") || lowered.contains("g ") || detail.isEmpty
    }

    static func gramsLabel(_ grams: Int, of name: String) -> String {
        "\(grams)g \(name)"
    }

    static func from(food: FoodItem) -> QuickAddItem {
        let portion = max(1, Int(food.servingGrams.rounded()))
        let protein = max(1, food.protein(forGrams: food.servingGrams))
        let detail = food.countUnit == nil
            ? gramsLabel(portion, of: food.name)
            : food.servingLabel

        return QuickAddItem(
            name: food.name,
            detail: detail,
            grams: protein,
            portionGrams: portion,
            proteinPer100g: food.proteinPer100g
        )
    }

    static let defaults: [QuickAddItem] = [
        QuickAddItem(
            name: "Greek yogurt",
            detail: "100g Greek yogurt",
            grams: 10,
            portionGrams: 100,
            proteinPer100g: 10
        ),
        QuickAddItem(
            name: "Chicken breast",
            detail: "120g chicken breast",
            grams: 36,
            portionGrams: 120,
            proteinPer100g: 30
        ),
        QuickAddItem(
            name: "Protein shake",
            detail: "1 scoop",
            grams: 25,
            portionGrams: 30,
            proteinPer100g: 83
        ),
        QuickAddItem(
            name: "Eggs",
            detail: "3 large eggs",
            grams: 18,
            portionGrams: 150,
            proteinPer100g: 12
        )
    ]

    static let favourites = defaults
}
