import Foundation

/// Built-in protein reference. Values are grams of protein per 100g of food as
/// eaten, rounded to the nearest sensible figure, with a typical UK portion.
enum FoodDatabase {
    static let all: [FoodItem] = meat + fish + eggsAndDairy + supplements + plantProtein + grains + everydayExtras

    // MARK: - Meat

    private static let meat: [FoodItem] = [
        FoodItem("Chicken breast", protein: 30, serving: 120, label: "120g breast", aliases: ["chicken"]),
        FoodItem("Chicken thigh", protein: 26, serving: 100, label: "100g"),
        FoodItem("Roast chicken", protein: 27, serving: 120, label: "120g"),
        FoodItem("Turkey breast", protein: 29, serving: 120, label: "120g", aliases: ["turkey"]),
        FoodItem("Turkey mince", protein: 27, serving: 125, label: "125g"),
        FoodItem("Beef mince", protein: 26, serving: 125, label: "125g", aliases: ["mince", "ground beef"]),
        FoodItem("Steak", protein: 27, serving: 200, label: "200g steak", aliases: ["sirloin", "ribeye", "beef"]),
        FoodItem("Beef burger", protein: 25, serving: 110, label: "1 patty", unit: "burger", aliases: ["burger", "patty"]),
        FoodItem("Pork chop", protein: 27, serving: 150, label: "150g chop", aliases: ["pork"]),
        FoodItem("Bacon", protein: 37, serving: 25, label: "1 rasher", unit: "rasher"),
        FoodItem("Ham", protein: 18, serving: 30, label: "1 slice", unit: "slice"),
        FoodItem("Sausage", protein: 12, serving: 60, label: "1 sausage", unit: "sausage"),
        FoodItem("Lamb", protein: 25, serving: 120, label: "120g"),
        FoodItem("Venison", protein: 30, serving: 120, label: "120g"),
        FoodItem("Duck", protein: 19, serving: 120, label: "120g"),
        FoodItem("Chicken nuggets", protein: 15, serving: 100, label: "6 nuggets", unit: "nugget", unitGrams: 17, aliases: ["nuggets"])
    ]

    // MARK: - Fish

    private static let fish: [FoodItem] = [
        FoodItem("Salmon", protein: 25, serving: 130, label: "130g fillet", aliases: ["salmon fillet"]),
        FoodItem("Smoked salmon", protein: 25, serving: 50, label: "50g"),
        FoodItem("Tuna", protein: 26, serving: 110, label: "1 tin", unit: "tin", aliases: ["tinned tuna", "canned tuna"]),
        FoodItem("Tuna steak", protein: 29, serving: 130, label: "130g"),
        FoodItem("Cod", protein: 23, serving: 130, label: "130g fillet"),
        FoodItem("Haddock", protein: 23, serving: 130, label: "130g fillet"),
        FoodItem("Mackerel", protein: 19, serving: 100, label: "100g"),
        FoodItem("Sardines", protein: 25, serving: 90, label: "1 tin", unit: "tin"),
        FoodItem("Prawns", protein: 24, serving: 100, label: "100g", aliases: ["shrimp"]),
        FoodItem("Fish fingers", protein: 12, serving: 100, label: "4 fingers", unit: "finger", unitGrams: 25)
    ]

    // MARK: - Eggs and dairy

    private static let eggsAndDairy: [FoodItem] = [
        FoodItem("Eggs", protein: 12, serving: 50, label: "1 large egg", unit: "egg", aliases: ["egg", "boiled egg", "fried egg"]),
        FoodItem("Egg whites", protein: 11, serving: 33, label: "1 white", unit: "white"),
        FoodItem("Scrambled eggs", protein: 11, serving: 130, label: "2 eggs"),
        FoodItem("Omelette", protein: 11, serving: 150, label: "3 eggs"),
        FoodItem("Greek yogurt", protein: 10, serving: 170, label: "170g pot", unit: "pot", aliases: ["greek yoghurt", "yogurt", "yoghurt"]),
        FoodItem("Skyr", protein: 11, serving: 150, label: "150g pot", unit: "pot"),
        FoodItem("Quark", protein: 12, serving: 150, label: "150g"),
        FoodItem("Cottage cheese", protein: 11, serving: 100, label: "100g"),
        FoodItem("Cheddar", protein: 25, serving: 30, label: "30g", aliases: ["cheese"]),
        FoodItem("Mozzarella", protein: 22, serving: 60, label: "60g"),
        FoodItem("Halloumi", protein: 22, serving: 80, label: "80g"),
        FoodItem("Feta", protein: 14, serving: 50, label: "50g"),
        FoodItem("Parmesan", protein: 36, serving: 15, label: "15g"),
        FoodItem("Cream cheese", protein: 6, serving: 30, label: "30g"),
        FoodItem("Ricotta", protein: 11, serving: 60, label: "60g"),
        FoodItem("Babybel", protein: 23, serving: 20, label: "1 cheese", unit: "cheese"),
        FoodItem("Whole milk", protein: 3.3, serving: 200, label: "200ml glass", aliases: ["full fat milk", "whole dairy milk"]),
        FoodItem("Semi-skimmed milk", protein: 3.5, serving: 200, label: "200ml glass", aliases: ["semi skimmed milk", "semi skimmed", "semi-skimmed", "milk"]),
        FoodItem("Skimmed milk", protein: 3.6, serving: 200, label: "200ml glass", aliases: ["skim milk", "fat free milk"]),
        FoodItem("Kefir", protein: 3.3, serving: 200, label: "200ml"),
        FoodItem("Protein yogurt", protein: 10, serving: 200, label: "200g pot", unit: "pot"),
        FoodItem("Protein pudding", protein: 7, serving: 200, label: "1 pot", unit: "pot")
    ]

    // MARK: - Supplements

    private static let supplements: [FoodItem] = [
        FoodItem("Protein shake", protein: 83, serving: 30, label: "1 scoop", unit: "scoop", aliases: ["whey", "protein powder", "shake"]),
        FoodItem("Casein shake", protein: 78, serving: 30, label: "1 scoop", unit: "scoop", aliases: ["casein"]),
        FoodItem("Protein bar", protein: 30, serving: 60, label: "1 bar", unit: "bar"),
        FoodItem("Clear whey", protein: 88, serving: 25, label: "1 sachet", unit: "sachet"),
        FoodItem("Protein cookie", protein: 20, serving: 75, label: "1 cookie", unit: "cookie"),
        FoodItem("Protein ice cream", protein: 6, serving: 150, label: "150g")
    ]

    // MARK: - Plant protein

    private static let plantProtein: [FoodItem] = [
        FoodItem("Tofu", protein: 12, serving: 100, label: "100g"),
        FoodItem("Tempeh", protein: 19, serving: 100, label: "100g"),
        FoodItem("Seitan", protein: 25, serving: 100, label: "100g"),
        FoodItem("Edamame", protein: 11, serving: 100, label: "100g"),
        FoodItem("Chickpeas", protein: 9, serving: 120, label: "120g"),
        FoodItem("Lentils", protein: 9, serving: 120, label: "120g"),
        FoodItem("Black beans", protein: 9, serving: 120, label: "120g", aliases: ["beans"]),
        FoodItem("Kidney beans", protein: 8, serving: 120, label: "120g"),
        FoodItem("Baked beans", protein: 5, serving: 200, label: "1/2 tin"),
        FoodItem("Hummus", protein: 8, serving: 50, label: "50g"),
        FoodItem("Falafel", protein: 13, serving: 80, label: "4 pieces", unit: "piece", unitGrams: 20),
        FoodItem("Soy milk", protein: 3.3, serving: 200, label: "200ml", aliases: ["soya milk"]),
        FoodItem("Almond milk", protein: 0.5, serving: 200, label: "200ml"),
        FoodItem("Oat milk", protein: 1.0, serving: 200, label: "200ml"),
        FoodItem("Coconut milk", protein: 0.2, serving: 200, label: "200ml drink", aliases: ["coconut drink"]),
        FoodItem("Rice milk", protein: 0.3, serving: 200, label: "200ml"),
        FoodItem("Cashew milk", protein: 0.5, serving: 200, label: "200ml"),
        FoodItem("Pea milk", protein: 2.0, serving: 200, label: "200ml", aliases: ["sproud"]),
        FoodItem("Peanut butter", protein: 25, serving: 30, label: "2 tbsp", aliases: ["pb"]),
        FoodItem("Peanuts", protein: 26, serving: 30, label: "30g"),
        FoodItem("Almonds", protein: 21, serving: 30, label: "30g"),
        FoodItem("Cashews", protein: 18, serving: 30, label: "30g"),
        FoodItem("Walnuts", protein: 15, serving: 30, label: "30g"),
        FoodItem("Pistachios", protein: 20, serving: 30, label: "30g"),
        FoodItem("Pumpkin seeds", protein: 30, serving: 25, label: "25g"),
        FoodItem("Sunflower seeds", protein: 21, serving: 25, label: "25g"),
        FoodItem("Chia seeds", protein: 17, serving: 20, label: "20g"),
        FoodItem("Flax seeds", protein: 18, serving: 20, label: "20g")
    ]

    // MARK: - Grains and carbs

    private static let grains: [FoodItem] = [
        FoodItem("Oats", protein: 13, serving: 50, label: "50g dry", aliases: ["porridge"]),
        FoodItem("Granola", protein: 9, serving: 50, label: "50g"),
        FoodItem("Muesli", protein: 10, serving: 50, label: "50g"),
        FoodItem("Weetabix", protein: 12, serving: 38, label: "2 biscuits", unit: "biscuit", unitGrams: 19),
        FoodItem("Bran flakes", protein: 10, serving: 40, label: "40g", aliases: ["cereal"]),
        FoodItem("Wholemeal bread", protein: 9, serving: 40, label: "1 slice", unit: "slice", aliases: ["bread", "toast"]),
        FoodItem("Bagel", protein: 10, serving: 85, label: "1 bagel", unit: "bagel"),
        FoodItem("Wrap", protein: 9, serving: 60, label: "1 wrap", unit: "wrap", aliases: ["tortilla"]),
        FoodItem("Pasta", protein: 5, serving: 200, label: "200g cooked"),
        FoodItem("Rice", protein: 2.7, serving: 200, label: "200g cooked"),
        FoodItem("Quinoa", protein: 4.4, serving: 180, label: "180g cooked"),
        FoodItem("Noodles", protein: 5, serving: 200, label: "200g cooked"),
        FoodItem("Couscous", protein: 3.8, serving: 180, label: "180g cooked"),
        FoodItem("Potato", protein: 2, serving: 200, label: "1 medium", unit: "potato"),
        FoodItem("Sweet potato", protein: 1.6, serving: 200, label: "1 medium", unit: "potato"),
        FoodItem("Rice cakes", protein: 8, serving: 20, label: "2 cakes", unit: "cake", unitGrams: 10)
    ]

    // MARK: - Everyday extras

    private static let everydayExtras: [FoodItem] = [
        FoodItem("Broccoli", protein: 2.8, serving: 100, label: "100g"),
        FoodItem("Spinach", protein: 2.9, serving: 80, label: "80g"),
        FoodItem("Peas", protein: 5, serving: 80, label: "80g"),
        FoodItem("Sweetcorn", protein: 3.3, serving: 80, label: "80g"),
        FoodItem("Mushrooms", protein: 3.1, serving: 80, label: "80g"),
        FoodItem("Avocado", protein: 2, serving: 100, label: "1/2 avocado"),
        FoodItem("Banana", protein: 1.1, serving: 120, label: "1 banana", unit: "banana"),
        FoodItem("Apple", protein: 0.3, serving: 150, label: "1 apple", unit: "apple"),
        FoodItem("Berries", protein: 0.7, serving: 100, label: "100g"),
        FoodItem("Pizza", protein: 11, serving: 250, label: "1/2 pizza"),
        FoodItem("Popcorn", protein: 12, serving: 25, label: "25g")
    ]
}
