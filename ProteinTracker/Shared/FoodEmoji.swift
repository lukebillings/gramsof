import Foundation

/// Picks an emoji for a food from its name. Entries can be typed freehand, so this
/// matches on keywords and falls back to a generic plate.
enum FoodEmoji {
    private static let matches: [(keywords: [String], emoji: String)] = [
        (["turkey"], "🦃"),
        (["chicken", "poultry"], "🍗"),
        (["burger", "patty"], "🍔"),
        (["steak", "beef", "mince", "lamb", "picanha", "venison", "duck", "liver"], "🥩"),
        (["bacon", "ham", "pork", "sausage"], "🥓"),
        (["prawn", "shrimp"], "🦐"),
        (["salmon", "tuna", "fish", "cod", "haddock", "mackerel", "sardine"], "🐟"),
        (["egg"], "🥚"),
        (["shake", "whey", "casein", "smoothie"], "🥤"),
        (["ice cream"], "🍦"),
        (["pudding", "custard"], "🍮"),
        (["yogurt", "yoghurt", "skyr", "quark"], "🥣"),
        (["cheese", "cottage", "paneer", "babybel"], "🧀"),
        (["milk", "kefir"], "🥛"),
        (["falafel"], "🧆"),
        (["bean", "lentil", "chickpea", "hummus"], "🫘"),
        (["tofu", "tempeh", "soy", "seitan", "edamame"], "🌱"),
        (["peanut", "almond", "cashew", "pistachio", "walnut", "nut"], "🥜"),
        (["seed"], "🌱"),
        (["cookie"], "🍪"),
        (["bar", "chocolate"], "🍫"),
        (["pizza"], "🍕"),
        (["popcorn"], "🍿"),
        (["oat", "porridge", "granola", "cereal", "muesli", "weetabix", "bran"], "🌾"),
        (["bread", "toast", "sandwich", "wrap", "bagel", "sourdough", "rye", "pitta", "pita", "naan", "ciabatta", "brioche", "crumpet", "baguette", "granary", "muffin"], "🥪"),
        (["pasta", "noodle"], "🍝"),
        (["broccoli", "broccolini", "tenderstem", "cauliflower"], "🥦"),
        (["rice", "quinoa", "couscous"], "🍚"),
        (["avocado"], "🥑"),
        (["banana"], "🍌"),
        (["pineapple"], "🍍"),
        (["apple"], "🍎"),
        (["orange", "clementine", "mandarin", "satsuma", "tangerine", "grapefruit"], "🍊"),
        (["grape"], "🍇"),
        (["strawberr", "raspberr"], "🍓"),
        (["blueberry", "blueberries", "berr"], "🫐"),
        (["mango"], "🥭"),
        (["kiwi"], "🥝"),
        (["watermelon"], "🍉"),
        (["honeydew", "cantaloupe", "galia", "melon"], "🍈"),
        (["peach", "nectarine"], "🍑"),
        (["pear"], "🍐"),
        (["cherry", "cherries"], "🍒"),
        (["coconut"], "🥥"),
        (["lemon", "lime"], "🍋"),
        (["date", "raisin", "sultana", "apricot", "fig", "plum", "pomegranate", "papaya", "guava", "passion", "rhubarb", "prune", "currant", "lychee", "dragon", "jackfruit", "sharon", "persimmon", "goji", "physalis", "gooseberr", "star fruit", "starfruit"], "🍇"),
        (["carrot"], "🥕"),
        (["sweet potato"], "🍠"),
        (["potato", "chips", "fries", "roasties"], "🥔"),
        (["corn", "sweetcorn"], "🌽"),
        (["mushroom"], "🍄"),
        (["tomato"], "🍅"),
        (["cucumber", "gherkin", "pickle", "courgette", "zucchini"], "🥒"),
        (["pepper", "capsicum"], "🫑"),
        (["chilli", "chili", "jalapeno", "jalapeño"], "🌶️"),
        (["onion", "shallot", "leek"], "🧅"),
        (["garlic"], "🧄"),
        (["pea", "pois", "mangetout"], "🫛"),
        (["aubergine", "eggplant"], "🍆"),
        (["squash", "pumpkin"], "🎃"),
        (["olive"], "🫒"),
        (["nori", "seaweed"], "🍣"),
        (["spinach", "kale", "lettuce", "salad", "cabbage", "asparagus", "sprout", "celery", "celeriac", "beet", "parsnip", "rocket", "pak choi", "bok", "chard", "fennel", "radish", "swede", "turnip", "artichoke", "kimchi", "sauerkraut", "watercress", "coleslaw", "okra", "marrow", "chicory", "greens"], "🥬"),
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
