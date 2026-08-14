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
        (["bread", "toast", "sandwich", "wrap", "bagel", "sourdough", "rye", "pitta", "pita", "naan", "ciabatta", "brioche", "crumpet", "baguette", "granary", "muffin"], "🥪"),
        (["rice", "pasta", "noodle", "quinoa"], "🍚"),
        (["avocado"], "🥑"),
        (["banana"], "🍌"),
        (["pineapple"], "🍍"),
        (["apple"], "🍎"),
        (["orange", "clementine", "mandarin", "satsuma", "tangerine", "grapefruit"], "🍊"),
        (["grape"], "🍇"),
        (["strawberr"], "🍓"),
        (["blueberry", "blueberries", "berr"], "🫐"),
        (["mango"], "🥭"),
        (["kiwi"], "🥝"),
        (["watermelon", "melon"], "🍉"),
        (["peach", "nectarine"], "🍑"),
        (["pear"], "🍐"),
        (["cherry", "cherries"], "🍒"),
        (["coconut"], "🥥"),
        (["lemon", "lime"], "🍋"),
        (["date", "raisin", "sultana", "apricot", "fig", "plum", "pomegranate", "papaya", "guava", "passion"], "🍇"),
        (["broccoli", "spinach", "kale", "carrot", "pea", "corn", "mushroom", "tomato", "cucumber", "pepper", "onion", "lettuce", "salad", "cabbage", "cauliflower", "asparagus", "courgette", "zucchini", "sprout", "aubergine", "squash", "leek", "celery", "beet", "parsnip", "rocket", "pak choi", "bok", "chard", "fennel", "radish", "swede", "turnip", "artichoke", "olive", "nori", "seaweed", "kimchi", "sauerkraut", "watercress"], "🥬"),
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
