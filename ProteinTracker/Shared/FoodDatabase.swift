import Foundation

/// Built-in protein reference. Values are grams of protein per 100g of food as
/// eaten, rounded to the nearest sensible figure, with a typical UK portion.
enum FoodDatabase {
    static let all: [FoodItem] = meat + fish + eggsAndDairy + supplements + plantProtein + grains + breads + vegetables + fruits + everydayExtras

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
        FoodItem("Pasta", protein: 5, serving: 200, label: "200g cooked"),
        FoodItem("Rice", protein: 2.7, serving: 200, label: "200g cooked"),
        FoodItem("Quinoa", protein: 4.4, serving: 180, label: "180g cooked"),
        FoodItem("Noodles", protein: 5, serving: 200, label: "200g cooked"),
        FoodItem("Couscous", protein: 3.8, serving: 180, label: "180g cooked"),
        FoodItem("Potato", protein: 2, serving: 200, label: "1 medium", unit: "potato"),
        FoodItem("Sweet potato", protein: 1.6, serving: 200, label: "1 medium", unit: "potato"),
        FoodItem("Rice cakes", protein: 8, serving: 20, label: "2 cakes", unit: "cake", unitGrams: 10)
    ]

    // MARK: - Breads

    private static let breads: [FoodItem] = [
        FoodItem("White bread", protein: 9, serving: 40, label: "1 slice", unit: "slice", aliases: ["bread", "toast", "white toast"]),
        FoodItem("Wholemeal bread", protein: 9, serving: 40, label: "1 slice", unit: "slice", aliases: ["wholemeal", "whole wheat", "wholewheat", "brown bread", "brown toast"]),
        FoodItem("Sourdough", protein: 9, serving: 50, label: "1 slice", unit: "slice", aliases: ["sourdough bread"]),
        FoodItem("Rye bread", protein: 9, serving: 40, label: "1 slice", unit: "slice", aliases: ["rye", "dark rye"]),
        FoodItem("Seeded bread", protein: 11, serving: 40, label: "1 slice", unit: "slice", aliases: ["seeded", "multigrain", "multigrain bread", "seeds bread"]),
        FoodItem("Granary bread", protein: 10, serving: 40, label: "1 slice", unit: "slice", aliases: ["granary"]),
        FoodItem("Brioche", protein: 8, serving: 40, label: "1 slice", unit: "slice", aliases: ["brioche bread"]),
        FoodItem("Ciabatta", protein: 9, serving: 50, label: "1 roll", unit: "roll", aliases: ["ciabatta roll"]),
        FoodItem("Baguette", protein: 9, serving: 50, label: "1 portion", unit: "portion", aliases: ["french stick"]),
        FoodItem("Pitta", protein: 9, serving: 60, label: "1 pitta", unit: "pitta", aliases: ["pita", "pitta bread", "pita bread"]),
        FoodItem("Naan", protein: 8, serving: 100, label: "1 naan", unit: "naan", aliases: ["naan bread"]),
        FoodItem("Bagel", protein: 10, serving: 85, label: "1 bagel", unit: "bagel"),
        FoodItem("Crumpet", protein: 6, serving: 55, label: "1 crumpet", unit: "crumpet"),
        FoodItem("English muffin", protein: 9, serving: 60, label: "1 muffin", unit: "muffin", aliases: ["muffin"]),
        FoodItem("Wrap", protein: 9, serving: 60, label: "1 wrap", unit: "wrap", aliases: ["tortilla", "tortilla wrap"]),
        FoodItem("Gluten-free bread", protein: 4, serving: 40, label: "1 slice", unit: "slice", aliases: ["gluten free bread", "gf bread"])
    ]

    // MARK: - Vegetables

    private static let vegetables: [FoodItem] = [
        FoodItem("Broccoli", protein: 2.8, serving: 100, label: "100g"),
        FoodItem("Spinach", protein: 2.9, serving: 80, label: "80g"),
        FoodItem("Kale", protein: 2.9, serving: 80, label: "80g"),
        FoodItem("Peas", protein: 5, serving: 80, label: "80g"),
        FoodItem("Mangetout", protein: 2.8, serving: 80, label: "80g", aliases: ["snow peas", "sugar snap", "sugar snap peas"]),
        FoodItem("Sweetcorn", protein: 3.3, serving: 80, label: "80g", aliases: ["corn"]),
        FoodItem("Mushrooms", protein: 3.1, serving: 80, label: "80g"),
        FoodItem("Carrot", protein: 0.9, serving: 80, label: "1 medium", unit: "carrot", aliases: ["carrots"]),
        FoodItem("Courgette", protein: 1.2, serving: 100, label: "100g", aliases: ["zucchini"]),
        FoodItem("Cauliflower", protein: 1.9, serving: 100, label: "100g"),
        FoodItem("Cabbage", protein: 1.3, serving: 100, label: "100g"),
        FoodItem("Brussels sprouts", protein: 3.5, serving: 80, label: "80g", aliases: ["sprouts", "brussel sprouts"]),
        FoodItem("Green beans", protein: 1.8, serving: 80, label: "80g", aliases: ["runner beans", "french beans"]),
        FoodItem("Asparagus", protein: 2.2, serving: 80, label: "80g"),
        FoodItem("Tomato", protein: 0.9, serving: 100, label: "1 medium", unit: "tomato", aliases: ["tomatoes"]),
        FoodItem("Cucumber", protein: 0.7, serving: 100, label: "100g"),
        FoodItem("Pepper", protein: 0.9, serving: 100, label: "1 pepper", unit: "pepper", aliases: ["bell pepper", "capsicum", "red pepper"]),
        FoodItem("Onion", protein: 1.1, serving: 80, label: "1 medium", unit: "onion", aliases: ["onions"]),
        FoodItem("Leek", protein: 1.5, serving: 80, label: "80g", aliases: ["leeks"]),
        FoodItem("Celery", protein: 0.7, serving: 80, label: "2 sticks", unit: "stick", unitGrams: 40),
        FoodItem("Beetroot", protein: 1.6, serving: 80, label: "80g", aliases: ["beet"]),
        FoodItem("Parsnip", protein: 1.2, serving: 100, label: "1 medium", unit: "parsnip", aliases: ["parsnips"]),
        FoodItem("Aubergine", protein: 1.0, serving: 100, label: "100g", aliases: ["eggplant"]),
        FoodItem("Butternut squash", protein: 1.0, serving: 100, label: "100g", aliases: ["squash", "pumpkin"]),
        FoodItem("Lettuce", protein: 1.4, serving: 50, label: "50g", aliases: ["salad", "iceberg"]),
        FoodItem("Rocket", protein: 2.6, serving: 40, label: "40g", aliases: ["arugula"]),
        FoodItem("Mixed salad", protein: 1.5, serving: 80, label: "80g", aliases: ["salad leaves", "leafy salad"]),
        FoodItem("Pak choi", protein: 1.5, serving: 80, label: "80g", aliases: ["bok choy", "bok choi"]),
        FoodItem("Tenderstem broccoli", protein: 3.8, serving: 80, label: "80g", aliases: ["tenderstem", "broccolini"]),
        FoodItem("Spring greens", protein: 3.0, serving: 80, label: "80g", aliases: ["collard greens"]),
        FoodItem("Watercress", protein: 3.0, serving: 40, label: "40g"),
        FoodItem("Chard", protein: 1.8, serving: 80, label: "80g", aliases: ["swiss chard"]),
        FoodItem("Fennel", protein: 1.2, serving: 80, label: "80g"),
        FoodItem("Radish", protein: 0.7, serving: 80, label: "80g", aliases: ["radishes"]),
        FoodItem("Swede", protein: 0.7, serving: 150, label: "150g", aliases: ["rutabaga"]),
        FoodItem("Turnip", protein: 0.9, serving: 150, label: "150g", aliases: ["turnips"]),
        FoodItem("Artichoke", protein: 3.3, serving: 120, label: "1 artichoke", unit: "artichoke"),
        FoodItem("Olives", protein: 0.8, serving: 30, label: "30g"),
        FoodItem("Spring onion", protein: 1.8, serving: 20, label: "2 onions", unit: "onion", unitGrams: 10, aliases: ["scallion", "green onion", "spring onions"]),
        FoodItem("Broad beans", protein: 8.0, serving: 80, label: "80g", aliases: ["fava beans"]),
        FoodItem("Mixed vegetables", protein: 2.0, serving: 80, label: "80g", aliases: ["mixed veg", "frozen vegetables"]),
        FoodItem("Cherry tomatoes", protein: 0.9, serving: 100, label: "100g"),
        FoodItem("Sun-dried tomatoes", protein: 14, serving: 30, label: "30g", aliases: ["sundried tomatoes"]),
        FoodItem("Sauerkraut", protein: 0.9, serving: 80, label: "80g"),
        FoodItem("Kimchi", protein: 1.1, serving: 80, label: "80g"),
        FoodItem("Nori", protein: 5.8, serving: 3, label: "1 sheet", unit: "sheet", aliases: ["seaweed", "sushi nori"])
    ]

    // MARK: - Fruit

    private static let fruits: [FoodItem] = [
        FoodItem("Avocado", protein: 2, serving: 100, label: "1/2 avocado", aliases: ["avo"]),
        FoodItem("Banana", protein: 1.1, serving: 120, label: "1 banana", unit: "banana", aliases: ["bananas"]),
        FoodItem("Apple", protein: 0.3, serving: 150, label: "1 apple", unit: "apple", aliases: ["apples"]),
        FoodItem("Orange", protein: 0.9, serving: 150, label: "1 orange", unit: "orange", aliases: ["oranges"]),
        FoodItem("Clementine", protein: 0.9, serving: 80, label: "1 clementine", unit: "clementine", aliases: ["satsuma", "mandarin", "tangerine"]),
        FoodItem("Pear", protein: 0.4, serving: 150, label: "1 pear", unit: "pear", aliases: ["pears"]),
        FoodItem("Grapes", protein: 0.7, serving: 80, label: "80g", aliases: ["grape"]),
        FoodItem("Strawberries", protein: 0.7, serving: 100, label: "100g", aliases: ["strawberry"]),
        FoodItem("Blueberries", protein: 0.7, serving: 80, label: "80g", aliases: ["blueberry"]),
        FoodItem("Raspberries", protein: 1.2, serving: 80, label: "80g", aliases: ["raspberry"]),
        FoodItem("Blackberries", protein: 1.4, serving: 80, label: "80g", aliases: ["blackberry"]),
        FoodItem("Berries", protein: 0.7, serving: 100, label: "100g", aliases: ["mixed berries"]),
        FoodItem("Mango", protein: 0.8, serving: 150, label: "1 mango", unit: "mango"),
        FoodItem("Pineapple", protein: 0.5, serving: 80, label: "80g"),
        FoodItem("Kiwi", protein: 1.1, serving: 80, label: "1 kiwi", unit: "kiwi", aliases: ["kiwifruit", "kiwi fruit"]),
        FoodItem("Watermelon", protein: 0.6, serving: 150, label: "150g"),
        FoodItem("Melon", protein: 0.8, serving: 150, label: "150g", aliases: ["cantaloupe", "honeydew"]),
        FoodItem("Peach", protein: 0.9, serving: 150, label: "1 peach", unit: "peach", aliases: ["peaches"]),
        FoodItem("Nectarine", protein: 0.9, serving: 150, label: "1 nectarine", unit: "nectarine"),
        FoodItem("Plum", protein: 0.7, serving: 80, label: "1 plum", unit: "plum", aliases: ["plums"]),
        FoodItem("Cherries", protein: 1.0, serving: 80, label: "80g", aliases: ["cherry"]),
        FoodItem("Grapefruit", protein: 0.8, serving: 150, label: "1/2 grapefruit"),
        FoodItem("Lemon", protein: 1.1, serving: 60, label: "1 lemon", unit: "lemon"),
        FoodItem("Lime", protein: 0.7, serving: 50, label: "1 lime", unit: "lime"),
        FoodItem("Pomegranate", protein: 1.7, serving: 80, label: "80g seeds", aliases: ["pomegranate seeds"]),
        FoodItem("Passion fruit", protein: 2.2, serving: 50, label: "2 fruits", unit: "fruit", unitGrams: 25, aliases: ["passionfruit"]),
        FoodItem("Papaya", protein: 0.5, serving: 150, label: "150g", aliases: ["pawpaw"]),
        FoodItem("Guava", protein: 2.6, serving: 100, label: "1 guava", unit: "guava"),
        FoodItem("Figs", protein: 0.8, serving: 80, label: "2 figs", unit: "fig", unitGrams: 40, aliases: ["fig"]),
        FoodItem("Dates", protein: 2.5, serving: 50, label: "3 dates", unit: "date", unitGrams: 17, aliases: ["medjool", "medjool dates"]),
        FoodItem("Raisins", protein: 3.1, serving: 30, label: "30g", aliases: ["sultanas"]),
        FoodItem("Dried apricots", protein: 3.4, serving: 30, label: "30g", aliases: ["apricot"]),
        FoodItem("Coconut", protein: 3.3, serving: 30, label: "30g")
    ]

    // MARK: - Everyday extras

    private static let everydayExtras: [FoodItem] = [
        FoodItem("Pizza", protein: 11, serving: 250, label: "1/2 pizza"),
        FoodItem("Popcorn", protein: 12, serving: 25, label: "25g")
    ]
}
