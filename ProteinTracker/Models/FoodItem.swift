import Foundation

struct FoodItem: Identifiable, Hashable {
    let name: String
    let proteinPer100g: Double
    let servingGrams: Double
    let servingLabel: String
    /// Set when the food is naturally counted rather than weighed, so "2 eggs"
    /// can read back as "2 eggs" instead of "2 x 50g".
    let countUnit: String?
    /// Weight of a single countable unit, when the default portion is more than one.
    private let unitGrams: Double?
    let aliases: [String]

    var id: String { name }

    /// Weight to multiply by when the user types a count.
    var countGrams: Double { unitGrams ?? servingGrams }

    init(
        _ name: String,
        protein proteinPer100g: Double,
        serving servingGrams: Double,
        label servingLabel: String,
        unit countUnit: String? = nil,
        unitGrams: Double? = nil,
        aliases: [String] = []
    ) {
        self.name = name
        self.proteinPer100g = proteinPer100g
        self.servingGrams = servingGrams
        self.servingLabel = servingLabel
        self.countUnit = countUnit
        self.unitGrams = unitGrams
        self.aliases = aliases
    }

    func protein(forGrams grams: Double) -> Int {
        Int((proteinPer100g * grams / 100).rounded())
    }

    func countLabel(_ count: Double) -> String {
        let amount = Self.formattedAmount(count)
        guard let unit = countUnit else { return "\(amount) x \(Self.formattedAmount(servingGrams))g" }
        return count == 1 ? "1 \(unit)" : "\(amount) \(unit)s"
    }

    /// Food log title, including how many / how much, e.g. "3 eggs" or "200g Salmon".
    func logTitle(portionLabel: String) -> String {
        let portion = portionLabel
        let foodName = name
        let loweredPortion = portion.lowercased()
        let loweredName = foodName.lowercased()

        if loweredPortion.contains(loweredName) {
            return portion
        }

        if let unit = countUnit {
            let unitLower = unit.lowercased()
            if loweredName == unitLower || loweredName == "\(unitLower)s" || loweredName.contains(unitLower) {
                return portion
            }
        }

        if let weight = Self.leadingWeightLabel(in: portion) {
            return "\(weight) \(foodName)"
        }

        return "\(portion) \(foodName)"
    }

    func inferredPortionLabel(proteinGrams: Int) -> String {
        if countUnit != nil {
            let perUnit = proteinPer100g * countGrams / 100
            let count = max(1, (Double(proteinGrams) / max(perUnit, 0.01)).rounded())
            return countLabel(count)
        }

        let foodGrams = max(1, (Double(proteinGrams) / max(proteinPer100g, 0.01) * 100).rounded())
        return "\(Self.formattedAmount(foodGrams))g"
    }

    private static func formattedAmount(_ value: Double) -> String {
        value == value.rounded() ? String(Int(value)) : String(value)
    }

    private static func leadingWeightLabel(in portion: String) -> String? {
        let lowered = portion.lowercased()
        guard let match = lowered.range(of: #"^\d+(?:\.\d+)?(?:g|ml)\b"#, options: .regularExpression) else {
            return nil
        }
        let count = lowered.distance(from: lowered.startIndex, to: match.upperBound)
        return String(portion.prefix(count))
    }
}
