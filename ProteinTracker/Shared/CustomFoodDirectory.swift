import Foundation
import Observation

struct CustomFood: Codable, Identifiable, Hashable {
    var name: String
    var proteinGrams: Int

    var id: String { name.lowercased() }

    var foodItem: FoodItem {
        FoodItem(
            name,
            protein: Double(proteinGrams),
            serving: 100,
            label: "1 serving"
        )
    }

    init(name: String, proteinGrams: Int) {
        self.name = name.trimmingCharacters(in: .whitespacesAndNewlines)
        self.proteinGrams = proteinGrams
    }
}

/// User-created foods kept between launches so search can find them again.
@Observable
final class CustomFoodDirectory {
    private enum Key {
        static let foods = "foods.customDirectory"
    }

    private let defaults: UserDefaults
    private(set) var foods: [CustomFood]

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
        if let data = defaults.data(forKey: Key.foods),
           let decoded = try? JSONDecoder().decode([CustomFood].self, from: data) {
            foods = decoded
        } else {
            foods = []
        }
    }

    var foodItems: [FoodItem] { foods.map(\.foodItem) }

    func food(named name: String) -> CustomFood? {
        let key = name.lowercased()
        return foods.first { $0.name.lowercased() == key }
    }

    @discardableResult
    func upsert(name: String, proteinGrams: Int) -> CustomFood {
        let food = CustomFood(name: Self.displayName(from: name), proteinGrams: proteinGrams)
        if let index = foods.firstIndex(where: { $0.id == food.id }) {
            foods[index] = food
        } else {
            foods.insert(food, at: 0)
        }
        persist()
        return food
    }

    func removeAll() {
        foods = []
        defaults.removeObject(forKey: Key.foods)
    }

    private func persist() {
        guard let data = try? JSONEncoder().encode(foods) else { return }
        defaults.set(data, forKey: Key.foods)
    }

    static func displayName(from raw: String) -> String {
        raw
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .split(separator: " ")
            .map { $0.prefix(1).uppercased() + $0.dropFirst().lowercased() }
            .joined(separator: " ")
    }

    static var preview: CustomFoodDirectory {
        CustomFoodDirectory(defaults: UserDefaults(suiteName: "preview.customFoods") ?? .standard)
    }
}
