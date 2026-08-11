import Foundation

/// Picks an emoji for a food from its name. Entries can be typed freehand, so this
/// matches on keywords and falls back to a generic plate.
enum FoodEmoji {
    private static let matches: [(keywords: [String], emoji: String)] = [
        (["chicken", "turkey", "poultry"], "🍗"),
        (["steak", "beef", "mince", "burger", "lamb"], "🥩"),
        (["bacon", "ham", "pork", "sausage"], "🥓"),
        (["salmon", "tuna", "fish", "cod", "prawn", "shrimp"], "🐟"),
        (["egg"], "🥚"),
        (["shake", "whey", "casein", "smoothie"], "🥤"),
        (["yogurt", "yoghurt", "skyr", "quark"], "🥣"),
        (["cheese", "cottage", "paneer"], "🧀"),
        (["milk", "kefir"], "🥛"),
        (["bean", "lentil", "chickpea", "hummus"], "🫘"),
        (["tofu", "tempeh", "soy", "seitan", "edamame"], "🌱"),
        (["peanut", "almond", "cashew", "pistachio", "walnut", "nut"], "🥜"),
        (["bar", "chocolate"], "🍫"),
        (["oat", "porridge", "granola", "cereal", "muesli"], "🌾"),
        (["bread", "toast", "sandwich", "wrap", "bagel"], "🥪"),
        (["rice", "pasta", "noodle", "quinoa"], "🍚"),
        (["quick add"], "⚡️")
    ]

    static func forFood(named name: String) -> String {
        let lowered = name.lowercased()

        for match in matches where match.keywords.contains(where: lowered.contains) {
            return match.emoji
        }

        return "🍽️"
    }
}
