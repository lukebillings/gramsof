import Foundation

/// Built-in protein reference. Values are grams of protein per 100g of food as
/// eaten, rounded to the nearest sensible figure, with a typical UK portion.
enum FoodDatabase {
    static let all: [FoodItem] = meat + fish + eggsAndDairy + supplements + plantProtein + grains + breads + vegetables + fruits + everydayExtras

    static func food(matching name: String) -> FoodItem? {
        let lowered = name.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        guard !lowered.isEmpty else { return nil }
        if let exact = all.first(where: { $0.name.lowercased() == lowered }) {
            return exact
        }
        return all.first(where: { $0.aliases.contains(lowered) })
    }

    // MARK: - Meat

    private static let meat: [FoodItem] = [
        FoodItem("Chicken breast", protein: 30, serving: 120, label: "120g breast", aliases: ["chicken", "chicken fillet", "chicken breast fillet"]),
        FoodItem("Chicken thigh", protein: 26, serving: 100, label: "100g", aliases: ["chicken thighs"]),
        FoodItem("Chicken thigh fillet", protein: 24, serving: 100, label: "100g", aliases: ["skinless chicken thigh", "boneless chicken thigh"]),
        FoodItem("Chicken drumstick", protein: 24, serving: 80, label: "1 drumstick", unit: "drumstick", aliases: ["drumstick", "chicken drumsticks"]),
        FoodItem("Chicken wing", protein: 22, serving: 40, label: "2 wings", unit: "wing", unitGrams: 40, aliases: ["chicken wings", "wings"]),
        FoodItem("Chicken leg", protein: 24, serving: 150, label: "1 leg", unit: "leg", aliases: ["chicken legs"]),
        FoodItem("Chicken mince", protein: 27, serving: 125, label: "125g", aliases: ["ground chicken"]),
        FoodItem("Roast chicken", protein: 27, serving: 120, label: "120g", aliases: ["rotisserie chicken", "whole chicken"]),
        FoodItem("Grilled chicken", protein: 30, serving: 120, label: "120g", aliases: ["chicken grill"]),
        FoodItem("Shredded chicken", protein: 28, serving: 100, label: "100g", aliases: ["pulled chicken"]),
        FoodItem("Chicken kebab", protein: 25, serving: 150, label: "1 kebab", unit: "kebab", aliases: ["chicken kebabs", "chicken skewer"]),
        FoodItem("Chicken tikka", protein: 25, serving: 120, label: "120g"),
        FoodItem("Peri peri chicken", protein: 26, serving: 120, label: "120g", aliases: ["peri-peri chicken", "nandos chicken", "piri piri chicken"]),
        FoodItem("Chicken burger", protein: 18, serving: 110, label: "1 burger", unit: "burger"),
        FoodItem("Chicken sausage", protein: 14, serving: 60, label: "1 sausage", unit: "sausage"),
        FoodItem("Chicken goujons", protein: 18, serving: 100, label: "4 goujons", unit: "goujon", unitGrams: 25, aliases: ["chicken tenders", "chicken strips", "chicken dippers"]),
        FoodItem("Chicken nuggets", protein: 15, serving: 100, label: "6 nuggets", unit: "nugget", unitGrams: 17, aliases: ["nuggets", "popcorn chicken"]),
        FoodItem("Chicken liver", protein: 26, serving: 100, label: "100g", aliases: ["chicken livers"]),
        FoodItem("Turkey breast", protein: 29, serving: 120, label: "120g", aliases: ["turkey"]),
        FoodItem("Turkey mince", protein: 27, serving: 125, label: "125g"),
        FoodItem("Beef mince", protein: 26, serving: 125, label: "125g", aliases: ["mince", "ground beef"]),
        FoodItem("Steak", protein: 27, serving: 200, label: "200g steak", aliases: ["beef steak", "beef"]),
        FoodItem("Rump steak", protein: 31, serving: 200, label: "200g steak", aliases: ["rump"]),
        FoodItem("Sirloin steak", protein: 28, serving: 200, label: "200g steak", aliases: ["sirloin"]),
        FoodItem("Ribeye steak", protein: 25, serving: 200, label: "200g steak", aliases: ["ribeye", "rib-eye", "rib eye"]),
        FoodItem("Fillet steak", protein: 29, serving: 180, label: "180g steak", aliases: ["fillet", "beef fillet", "tenderloin"]),
        FoodItem("T-bone steak", protein: 26, serving: 250, label: "250g steak", aliases: ["t-bone", "t bone", "tbone"]),
        FoodItem("Porterhouse steak", protein: 26, serving: 300, label: "300g steak", aliases: ["porterhouse"]),
        FoodItem("Flank steak", protein: 28, serving: 200, label: "200g steak", aliases: ["flank"]),
        FoodItem("Skirt steak", protein: 29, serving: 180, label: "180g steak", aliases: ["skirt"]),
        FoodItem("Bavette steak", protein: 27, serving: 200, label: "200g steak", aliases: ["bavette"]),
        FoodItem("Hanger steak", protein: 28, serving: 180, label: "180g steak", aliases: ["hanger", "onglet"]),
        FoodItem("Flat iron steak", protein: 27, serving: 180, label: "180g steak", aliases: ["flat iron"]),
        FoodItem("Minute steak", protein: 29, serving: 120, label: "120g steak", aliases: ["minute"]),
        FoodItem("Picanha", protein: 26, serving: 200, label: "200g steak", aliases: ["rump cap", "picanha steak"]),
        FoodItem("Tomahawk steak", protein: 24, serving: 400, label: "400g steak", aliases: ["tomahawk"]),
        FoodItem("Beef burger", protein: 25, serving: 110, label: "1 patty", unit: "burger", aliases: ["burger", "patty"]),
        FoodItem("Pork chop", protein: 27, serving: 150, label: "150g chop", aliases: ["pork"]),
        FoodItem("Bacon", protein: 37, serving: 25, label: "1 rasher", unit: "rasher"),
        FoodItem("Ham", protein: 18, serving: 30, label: "1 slice", unit: "slice"),
        FoodItem("Sausage", protein: 12, serving: 60, label: "1 sausage", unit: "sausage"),
        FoodItem("Lamb", protein: 25, serving: 120, label: "120g"),
        FoodItem("Venison", protein: 30, serving: 120, label: "120g"),
        FoodItem("Duck", protein: 19, serving: 120, label: "120g")
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
        FoodItem("Lettuce", protein: 1.4, serving: 50, label: "50g", aliases: ["salad"]),
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
        FoodItem("Nori", protein: 5.8, serving: 3, label: "1 sheet", unit: "sheet", aliases: ["seaweed", "sushi nori"]),
        FoodItem("Baby spinach", protein: 2.9, serving: 80, label: "80g"),
        FoodItem("Corn on the cob", protein: 3.3, serving: 150, label: "1 cob", unit: "cob", aliases: ["corn cob", "sweetcorn cob"]),
        FoodItem("Baby corn", protein: 2.5, serving: 80, label: "80g", aliases: ["baby sweetcorn"]),
        FoodItem("Okra", protein: 2.0, serving: 80, label: "80g", aliases: ["ladies fingers", "bhindi"]),
        FoodItem("Celeriac", protein: 1.2, serving: 100, label: "100g"),
        FoodItem("Garlic", protein: 6.4, serving: 10, label: "2 cloves", unit: "clove", unitGrams: 5),
        FoodItem("Red onion", protein: 1.1, serving: 80, label: "1 medium", unit: "onion"),
        FoodItem("Shallot", protein: 1.2, serving: 40, label: "2 shallots", unit: "shallot", unitGrams: 20, aliases: ["shallots"]),
        FoodItem("Cos lettuce", protein: 1.2, serving: 80, label: "80g", aliases: ["romaine", "romaine lettuce"]),
        FoodItem("Little gem", protein: 1.2, serving: 80, label: "80g", aliases: ["little gem lettuce"]),
        FoodItem("Iceberg lettuce", protein: 0.7, serving: 80, label: "80g", aliases: ["iceberg"]),
        FoodItem("Cauliflower rice", protein: 1.9, serving: 150, label: "150g", aliases: ["cauli rice"]),
        FoodItem("Jacket potato", protein: 2.1, serving: 220, label: "1 potato", unit: "potato", aliases: ["baked potato", "jacket"]),
        FoodItem("New potatoes", protein: 1.8, serving: 150, label: "150g", aliases: ["baby potatoes", "salad potatoes"]),
        FoodItem("Roast potatoes", protein: 2.2, serving: 150, label: "150g", aliases: ["roasties", "roast potato"]),
        FoodItem("Chips", protein: 3.4, serving: 165, label: "165g", aliases: ["fries", "french fries", "oven chips"]),
        FoodItem("Coleslaw", protein: 0.9, serving: 80, label: "80g"),
        FoodItem("Gherkins", protein: 0.9, serving: 40, label: "3 gherkins", unit: "gherkin", unitGrams: 13, aliases: ["pickle", "pickles", "pickled cucumber"]),
        FoodItem("Chilli", protein: 1.9, serving: 20, label: "1 chilli", unit: "chilli", aliases: ["chili", "chillies", "jalapeno", "jalapeño"]),
        FoodItem("Stir-fry vegetables", protein: 2.2, serving: 150, label: "150g", aliases: ["stir fry veg", "stir fry vegetables", "wok vegetables"]),
        FoodItem("Roast vegetables", protein: 1.6, serving: 150, label: "150g", aliases: ["roasted vegetables", "roast veg"]),
        FoodItem("Beansprouts", protein: 3.0, serving: 80, label: "80g", aliases: ["bean sprouts", "mung bean sprouts"]),
        FoodItem("Red cabbage", protein: 1.4, serving: 80, label: "80g"),
        FoodItem("Savoy cabbage", protein: 2.0, serving: 80, label: "80g"),
        FoodItem("Petit pois", protein: 5.4, serving: 80, label: "80g", aliases: ["petits pois"]),
        FoodItem("Mushy peas", protein: 5.0, serving: 80, label: "80g"),
        FoodItem("Marrow", protein: 0.6, serving: 150, label: "150g"),
        FoodItem("Portobello mushroom", protein: 3.1, serving: 80, label: "1 mushroom", unit: "mushroom", aliases: ["portobello", "portabella"]),
        FoodItem("Chicory", protein: 0.9, serving: 80, label: "80g", aliases: ["endive", "witloof"])
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
        FoodItem("Melon", protein: 0.8, serving: 150, label: "150g"),
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
        FoodItem("Coconut", protein: 3.3, serving: 30, label: "30g"),
        FoodItem("Apricot", protein: 1.4, serving: 80, label: "2 apricots", unit: "apricot", unitGrams: 40, aliases: ["apricots", "fresh apricot"]),
        FoodItem("Cranberries", protein: 0.4, serving: 80, label: "80g", aliases: ["cranberry"]),
        FoodItem("Dried cranberries", protein: 0.1, serving: 30, label: "30g", aliases: ["craisins"]),
        FoodItem("Rhubarb", protein: 0.9, serving: 100, label: "100g"),
        FoodItem("Blackcurrants", protein: 1.4, serving: 80, label: "80g", aliases: ["blackcurrant"]),
        FoodItem("Redcurrants", protein: 1.4, serving: 80, label: "80g", aliases: ["redcurrant"]),
        FoodItem("Prunes", protein: 2.3, serving: 50, label: "5 prunes", unit: "prune", unitGrams: 10, aliases: ["prune", "dried plum"]),
        FoodItem("Dragon fruit", protein: 1.2, serving: 150, label: "1/2 fruit", aliases: ["pitaya", "pitahaya"]),
        FoodItem("Lychee", protein: 0.8, serving: 80, label: "6 lychees", unit: "lychee", unitGrams: 13, aliases: ["lychees", "litchi"]),
        FoodItem("Jackfruit", protein: 1.7, serving: 150, label: "150g"),
        FoodItem("Sharon fruit", protein: 0.6, serving: 150, label: "1 fruit", unit: "fruit", aliases: ["persimmon", "kaki"]),
        FoodItem("Honeydew melon", protein: 0.5, serving: 150, label: "150g", aliases: ["honeydew"]),
        FoodItem("Cantaloupe", protein: 0.8, serving: 150, label: "150g", aliases: ["cantaloupe melon"]),
        FoodItem("Galia melon", protein: 0.6, serving: 150, label: "150g", aliases: ["galia"]),
        FoodItem("Red grapes", protein: 0.7, serving: 80, label: "80g"),
        FoodItem("Green grapes", protein: 0.6, serving: 80, label: "80g", aliases: ["white grapes"]),
        FoodItem("Fruit salad", protein: 0.6, serving: 150, label: "150g", aliases: ["mixed fruit", "fresh fruit"]),
        FoodItem("Frozen berries", protein: 0.7, serving: 100, label: "100g", aliases: ["frozen mixed berries"]),
        FoodItem("Dried fruit", protein: 2.5, serving: 40, label: "40g", aliases: ["mixed dried fruit"]),
        FoodItem("Goji berries", protein: 14, serving: 20, label: "20g", aliases: ["goji"]),
        FoodItem("Physalis", protein: 1.9, serving: 50, label: "8 fruits", unit: "fruit", unitGrams: 6, aliases: ["cape gooseberry"]),
        FoodItem("Gooseberries", protein: 0.9, serving: 80, label: "80g", aliases: ["gooseberry"]),
        FoodItem("Star fruit", protein: 1.0, serving: 80, label: "1 fruit", unit: "fruit", aliases: ["starfruit", "carambola"])
    ]

    // MARK: - Everyday extras

    private static let everydayExtras: [FoodItem] = [
        FoodItem("Pizza", protein: 11, serving: 250, label: "1/2 pizza"),
        FoodItem("Popcorn", protein: 12, serving: 25, label: "25g")
    ]
}
