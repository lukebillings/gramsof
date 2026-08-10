import Foundation

struct FoodSuggestion: Identifiable, Hashable {
    let food: FoodItem
    let grams: Int
    let portionLabel: String

    var id: String { food.id }
    var name: String { food.name }
    var emoji: String { FoodEmoji.forFood(named: food.name) }
}

/// Matches typed text against `FoodDatabase` and works out how much protein the
/// amount described adds up to.
enum FoodLookup {
    private static let maxResults = 4
    private static let minimumQueryLength = 2
    private static let weightUnits = ["grams", "gram", "g", "ml"]

    /// Words that describe an amount rather than the food, so "3 scoops of whey"
    /// still matches on "whey".
    private static let fillerWords: Set<String> = {
        var words: Set<String> = ["of", "serving", "servings", "portion", "portions", "cup", "cups", "tbsp", "tsp"]

        for food in FoodDatabase.all {
            guard let unit = food.countUnit else { continue }
            words.insert(unit)
            words.insert(unit + "s")
        }

        return words
    }()

    static func suggestions(for text: String, including extras: [FoodItem] = []) -> [FoodSuggestion] {
        guard let query = Query(text: text) else { return [] }

        var matches = self.matches(for: query.name, in: FoodDatabase.all + extras)

        // "3 scoops protein shake" only matches once the unit word is dropped, but
        // "4 chicken nuggets" must keep it, so this is a fallback rather than a rule.
        if matches.isEmpty, query.strippedName != query.name {
            matches = self.matches(for: query.strippedName, in: FoodDatabase.all + extras)
        }

        return matches.prefix(maxResults).map { suggestion(for: $0.food, query: query) }
    }

    /// The cleaned food name from free text, if it looks like something that could
    /// be saved as a custom food.
    static func customNameCandidate(in text: String) -> String? {
        guard let query = Query(text: text), query.name.count >= minimumQueryLength else { return nil }
        return CustomFoodDirectory.displayName(from: query.name)
    }

    private static func matches(for name: String, in foods: [FoodItem]) -> [Match] {
        guard name.count >= minimumQueryLength else { return [] }

        var matches: [Match] = []

        for food in foods {
            guard let rank = rank(food, matching: name) else { continue }
            matches.append(Match(food: food, rank: rank))
        }

        matches.sort { left, right in
            left.rank == right.rank
                ? left.food.name.count < right.food.name.count
                : left.rank < right.rank
        }

        return matches
    }

    private struct Match {
        let food: FoodItem
        let rank: Int
    }

    // MARK: - Matching

    private static func rank(_ food: FoodItem, matching query: String) -> Int? {
        let candidates = [food.name.lowercased()] + food.aliases

        return candidates.compactMap { candidate -> Int? in
            if candidate == query { return 0 }
            if candidate.hasPrefix(query) { return 1 }
            if candidate.contains(query) { return 2 }
            return nil
        }.min()
    }

    // MARK: - Portions

    private static func suggestion(for food: FoodItem, query: Query) -> FoodSuggestion {
        if let weight = query.weight {
            return FoodSuggestion(
                food: food,
                grams: food.protein(forGrams: weight),
                portionLabel: "\(format(weight))g"
            )
        }

        if let count = query.count {
            return FoodSuggestion(
                food: food,
                grams: food.protein(forGrams: food.countGrams * count),
                portionLabel: countLabel(count, for: food)
            )
        }

        return FoodSuggestion(
            food: food,
            grams: food.protein(forGrams: food.servingGrams),
            portionLabel: food.servingLabel
        )
    }

    private static func countLabel(_ count: Double, for food: FoodItem) -> String {
        let amount = format(count)

        // Serving labels can already read as a count ("6 nuggets"), so fall back to
        // the weight rather than producing "2 x 6 nuggets".
        guard let unit = food.countUnit else { return "\(amount) x \(format(food.servingGrams))g" }

        return count == 1 ? "1 \(unit)" : "\(amount) \(unit)s"
    }

    private static func format(_ value: Double) -> String {
        value == value.rounded() ? String(Int(value)) : String(value)
    }

    // MARK: - Query

    private struct Query {
        let name: String
        /// `name` with amount words such as "scoops" removed.
        let strippedName: String
        let weight: Double?
        let count: Double?

        init?(text: String) {
            var words = text
                .trimmingCharacters(in: .whitespacesAndNewlines)
                .lowercased()
                .split(separator: " ")
                .map(String.init)

            guard !words.isEmpty else { return nil }

            var weight: Double?
            var count: Double?

            if let index = words.firstIndex(where: { FoodLookup.weight(from: $0) != nil }) {
                weight = FoodLookup.weight(from: words[index])
                words.remove(at: index)
            } else if words.count > 1,
                      let number = Double(words[0]), number > 0,
                      FoodLookup.weightUnits.contains(words[1]) {
                weight = number
                words.removeFirst(2)
            } else if let number = Double(words[0]), number > 0 {
                count = number
                words.removeFirst()
            } else if words.contains(where: { Double($0) != nil }) {
                // A bare number after the food name is the user stating the protein
                // amount themselves, so there is nothing to look up.
                return nil
            }

            let name = words.joined(separator: " ").trimmingCharacters(in: .whitespaces)
            guard !name.isEmpty else { return nil }

            let stripped = words.filter { !FoodLookup.fillerWords.contains($0) }

            self.name = name
            self.strippedName = stripped.isEmpty ? name : stripped.joined(separator: " ")
            self.weight = weight
            self.count = count
        }
    }

    private static func weight(from word: String) -> Double? {
        for unit in weightUnits where word.hasSuffix(unit) {
            if let value = Double(word.dropLast(unit.count)), value > 0 { return value }
        }

        return nil
    }
}
