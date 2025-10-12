import SwiftUI
import Foundation
import Combine

struct Recipe: Identifiable, Codable, Hashable {
    var id: UUID = UUID()
    var title: String
    var summary: String
    var category: String
    var cuisine: String
    var difficulty: String
    var ingredients: [String]
    var steps: [String]
    var prepMinutes: Int
    var cookMinutes: Int
    var totalMinutes: Int
    var servings: Int
    var author: String
    var createdAt: Date = Date()
    var updatedAt: Date?
    var notes: String
    var rating: Double
    var calories: Int
    var proteinGrams: Double
    var fatGrams: Double
    var carbsGrams: Double
    var tags: [String]
    var isVegetarian: Bool
    var isVegan: Bool
    var isGlutenFree: Bool
    var isDairyFree: Bool
    var mainIngredient: String
    var utensilNeeded: String
    var temperatureCelsius: Double
    var imageName: String
    var videoLink: String
    var source: String
    var region: String
    var flavorProfile: String
    var costEstimate: String
    var favoriteCount: Int
    var lastCooked: Date?
}

struct Ingredient: Identifiable, Codable, Hashable {
    var id: UUID = UUID()
    var name: String
    var quantity: String
    var unit: String
    var category: String
    var freshnessLevel: String
    var supplier: String
    var origin: String
    var purchaseDate: Date?
    var expiryDate: Date?
    var storageLocation: String
    var tags: [String]
    var caloriesPer100g: Int
    var costPerUnit: Double
    var isOrganic: Bool
    var isLocal: Bool
    var isAllergen: Bool
    var allergenType: String
    var replacementSuggestions: [String]
    var color: String
    var texture: String
    var aroma: String
    var taste: String
    var usedInRecipes: [UUID]
    var preferredBrand: String
    var moistureLevel: String
    var density: Double
    var nutritionGrade: String
    var seasonality: String
    var handlingTips: String
    var preparationSteps: [String]
    var rating: Double
    var lastUpdated: Date?
    var barcode: String
    var shelfLifeDays: Int
    var availabilityStatus: String
}

struct SearchQuery: Identifiable, Codable, Hashable {
    var id: UUID = UUID()
    var text: String
    var ingredientFilters: [String]
    var maxCookTime: Int?
    var minRating: Double
    var maxCalories: Int
    var categoryFilter: String
    var cuisineFilter: String
    var isVegetarianOnly: Bool
    var isVeganOnly: Bool
    var includeGlutenFree: Bool
    var includeDairyFree: Bool
    var sortOption: String
    var sortOrder: String
    var showFavoritesOnly: Bool
    var includeTags: [String]
    var excludeTags: [String]
    var savedAt: Date = Date()
    var lastUsed: Date?
    var searchCount: Int
    var totalResults: Int
    var recentResultTitles: [String]
    var isAdvancedMode: Bool
    var timeRangeLabel: String
    var difficultyLevel: String
    var authorFilter: String
    var regionFilter: String
    var keywordMatchType: String
    var autoSuggestionsEnabled: Bool
    var lastUsedDevice: String
    var language: String
    var temperatureUnit: String
    var favoriteOnly: Bool
    var userNote: String
    var includeImages: Bool
    var showQuickRecipes: Bool
    var filterGroup: String
    var cacheKey: String
}

struct FavoriteEntry: Identifiable, Codable, Hashable {
    var id: UUID = UUID()
    var recipeId: UUID
    var addedAt: Date = Date()
    var note: String?
    var rating: Double
    var timesCooked: Int
    var customLabel: String
    var moodTag: String
    var sharedWithFriends: Bool
    var bookmarkedAt: Date?
    var imagePreview: String
    var lastCooked: Date?
    var category: String
    var cuisine: String
    var isWeeklyFavorite: Bool
    var isSeasonalPick: Bool
    var isHealthyChoice: Bool
    var author: String
    var preparationTips: String
    var nutritionSummary: String
    var cookCount: Int
    var lastModified: Date?
    var recipeName: String
    var spiceLevel: String
    var flavorProfile: String
    var favoriteReason: String
    var difficultyLevel: String
    var prepTime: Int
    var cookTime: Int
    var totalTime: Int
    var ratingOutOfFive: Int
    var locationAdded: String
    var source: String
    var backupStatus: String
    var reviewText: String
    var sharedDate: Date?
    var moodWhenCooked: String
}

struct CookingReminder: Identifiable, Codable, Hashable {
    var id: UUID = UUID()
    var recipeId: UUID
    var title: String
    var fireDate: Date
    var repeatIntervalMinutes: Int?
    var isActive: Bool
    var createdAt: Date = Date()
    var updatedAt: Date?
    var reminderMessage: String
    var soundName: String
    var vibrationEnabled: Bool
    var alertType: String
    var snoozeMinutes: Int
    var repeatDays: [String]
    var isPersistent: Bool
    var priorityLevel: String
    var reminderCategory: String
    var recipeName: String
    var durationMinutes: Int
    var estimatedCompletion: Date?
    var colorCode: String
    var iconName: String
    var showOnLockScreen: Bool
    var isSilent: Bool
    var autoDeleteAfterTrigger: Bool
    var linkedTimerId: UUID?
    var isRecurring: Bool
    var startCookingTime: Date?
    var endCookingTime: Date?
    var kitchenZone: String
    var assignedUser: String
    var displayOrder: Int
    var locationContext: String
    var notes: String
    var completed: Bool
}

struct MeasurementPreference: Identifiable, Codable, Hashable {
    var id: UUID = UUID()
    var unitSystem: String
    var decimalPlaces: Int
    var weightUnit: String
    var volumeUnit: String
    var temperatureUnit: String
    var pressureUnit: String
    var preferredLanguage: String
    var defaultCurrency: String
    var roundingMode: String
    var conversionPrecision: Int
    var autoConvertEnabled: Bool
    var showFractionUnits: Bool
    var displayAbbreviations: Bool
    var fontScale: Double
    var theme: String
    var showTips: Bool
    var quickEntryMode: Bool
    var includeScientificUnits: Bool
    var temperatureDisplayFormat: String
    var ingredientSortOption: String
    var recipeDisplayMode: String
    var rememberLastChoice: Bool
    var vibrationFeedback: Bool
    var hapticLevel: Int
    var preferredDateFormat: String
    var colorScheme: String
    var accessibilityTextSize: Int
    var highContrastEnabled: Bool
    var autoSaveSettings: Bool
    var defaultPortionSize: Int
    var useLocalFormatting: Bool
    var region: String
    var backupEnabled: Bool
    var lastUpdated: Date?
    var appVersion: String
    var developerMode: Bool
}

import Foundation
import Combine

@available(iOS 14.0, *)
class SoupDataStore: ObservableObject {

    @Published var recipes: [Recipe] = []
    @Published var ingredients: [Ingredient] = []
    @Published var searchQueries: [SearchQuery] = []
    @Published var favorites: [FavoriteEntry] = []
    @Published var reminders: [CookingReminder] = []
    @Published var measurementPrefs: [MeasurementPreference] = []
    
    private let recipesKey = "recipesKey"
    private let ingredientsKey = "ingredientsKey"
    private let searchQueriesKey = "searchQueriesKey"
    private let favoritesKey = "favoritesKey"
    private let remindersKey = "remindersKey"
    private let measurementPrefsKey = "measurementPrefsKey"
    
    init() {
        loadData()
        if recipes.isEmpty { loadDummyData() }
    }
    
    func addRecipe(_ recipe: Recipe) {
        recipes.append(recipe)
        saveData()
    }
    
    func addIngredient(_ ingredient: Ingredient) {
        ingredients.append(ingredient)
        saveData()
    }
    
    func addSearchQuery(_ query: SearchQuery) {
        searchQueries.append(query)
        saveData()
    }
    
    func addFavorite(_ favorite: FavoriteEntry) {
        favorites.append(favorite)
        saveData()
    }
    
    func addReminder(_ reminder: CookingReminder) {
        reminders.append(reminder)
        saveData()
    }
    
    func addMeasurementPref(_ pref: MeasurementPreference) {
        measurementPrefs.append(pref)
        saveData()
    }
    
    func deleteRecipe(at offsets: IndexSet) {
        recipes.remove(atOffsets: offsets)
        saveData()
    }
    
    func deleteIngredient(at offsets: IndexSet) {
        ingredients.remove(atOffsets: offsets)
        saveData()
    }
    
    func deleteSearchQuery(at offsets: IndexSet) {
        searchQueries.remove(atOffsets: offsets)
        saveData()
    }
    
    func deleteFavorite(at offsets: IndexSet) {
        favorites.remove(atOffsets: offsets)
        saveData()
    }
    
    func deleteReminder(at offsets: IndexSet) {
        reminders.remove(atOffsets: offsets)
        saveData()
    }
    
    func deleteMeasurementPref(at offsets: IndexSet) {
        measurementPrefs.remove(atOffsets: offsets)
        saveData()
    }
    
    private func saveData() {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(recipes) {
            UserDefaults.standard.set(encoded, forKey: recipesKey)
        }
        if let encoded = try? encoder.encode(ingredients) {
            UserDefaults.standard.set(encoded, forKey: ingredientsKey)
        }
        if let encoded = try? encoder.encode(searchQueries) {
            UserDefaults.standard.set(encoded, forKey: searchQueriesKey)
        }
        if let encoded = try? encoder.encode(favorites) {
            UserDefaults.standard.set(encoded, forKey: favoritesKey)
        }
        if let encoded = try? encoder.encode(reminders) {
            UserDefaults.standard.set(encoded, forKey: remindersKey)
        }
        if let encoded = try? encoder.encode(measurementPrefs) {
            UserDefaults.standard.set(encoded, forKey: measurementPrefsKey)
        }
    }
    
    private func loadData() {
        let decoder = JSONDecoder()
        if let data = UserDefaults.standard.data(forKey: recipesKey),
           let decoded = try? decoder.decode([Recipe].self, from: data) {
            recipes = decoded
        }
        if let data = UserDefaults.standard.data(forKey: ingredientsKey),
           let decoded = try? decoder.decode([Ingredient].self, from: data) {
            ingredients = decoded
        }
        if let data = UserDefaults.standard.data(forKey: searchQueriesKey),
           let decoded = try? decoder.decode([SearchQuery].self, from: data) {
            searchQueries = decoded
        }
        if let data = UserDefaults.standard.data(forKey: favoritesKey),
           let decoded = try? decoder.decode([FavoriteEntry].self, from: data) {
            favorites = decoded
        }
        if let data = UserDefaults.standard.data(forKey: remindersKey),
           let decoded = try? decoder.decode([CookingReminder].self, from: data) {
            reminders = decoded
        }
        if let data = UserDefaults.standard.data(forKey: measurementPrefsKey),
           let decoded = try? decoder.decode([MeasurementPreference].self, from: data) {
            measurementPrefs = decoded
        }
    }
    
    private func loadDummyData() {
        recipes = [
            Recipe(
                title: "Creamy Tomato Basil Soup",
                summary: "A smooth and tangy classic comfort soup.",
                category: "Vegetarian",
                cuisine: "Italian",
                difficulty: "Easy",
                ingredients: ["Tomatoes", "Basil", "Cream", "Garlic"],
                steps: ["Blend tomatoes", "Simmer with cream", "Add basil"],
                prepMinutes: 10,
                cookMinutes: 20,
                totalMinutes: 30,
                servings: 4,
                author: "Chef Anna",
                notes: "Best served with garlic bread.",
                rating: 4.8,
                calories: 180,
                proteinGrams: 5.0,
                fatGrams: 7.0,
                carbsGrams: 20.0,
                tags: ["vegetarian", "creamy", "comfort"],
                isVegetarian: true,
                isVegan: false,
                isGlutenFree: true,
                isDairyFree: false,
                mainIngredient: "Tomatoes",
                utensilNeeded: "Blender",
                temperatureCelsius: 85,
                imageName: "tomatoSoup",
                videoLink: "https://example.com/tomatosoup",
                source: "Homemade",
                region: "Europe",
                flavorProfile: "Savory",
                costEstimate: "Low",
                favoriteCount: 12,
                lastCooked: nil
            )
        ]
        
        ingredients = [
            Ingredient(
                name: "Tomato",
                quantity: "3",
                unit: "pcs",
                category: "Vegetable",
                freshnessLevel: "Fresh",
                supplier: "Local Market",
                origin: "Pakistan",
                storageLocation: "Pantry",
                tags: ["vegetarian"],
                caloriesPer100g: 18,
                costPerUnit: 10.0,
                isOrganic: true,
                isLocal: true,
                isAllergen: false,
                allergenType: "",
                replacementSuggestions: ["Canned Tomato"],
                color: "Red",
                texture: "Smooth",
                aroma: "Mild",
                taste: "Tangy",
                usedInRecipes: [],
                preferredBrand: "N/A",
                moistureLevel: "High",
                density: 0.9,
                nutritionGrade: "A",
                seasonality: "Summer",
                handlingTips: "Wash before use.",
                preparationSteps: ["Chop finely"],
                rating: 4.9,
                barcode: "1234567890",
                shelfLifeDays: 7,
                availabilityStatus: "Available"
            )
        ]
        
        searchQueries = [
            SearchQuery(
                text: "Tomato Soup",
                ingredientFilters: ["Tomato"],
                maxCookTime: 30,
                minRating: 4.0,
                maxCalories: 250,
                categoryFilter: "Vegetarian",
                cuisineFilter: "Italian",
                isVegetarianOnly: true,
                isVeganOnly: false,
                includeGlutenFree: true,
                includeDairyFree: false,
                sortOption: "rating",
                sortOrder: "desc",
                showFavoritesOnly: false,
                includeTags: ["creamy"],
                excludeTags: [],
                searchCount: 3,
                totalResults: 5,
                recentResultTitles: ["Creamy Tomato Soup"],
                isAdvancedMode: false,
                timeRangeLabel: "Quick",
                difficultyLevel: "Easy",
                authorFilter: "Chef Anna",
                regionFilter: "Europe",
                keywordMatchType: "exact",
                autoSuggestionsEnabled: true,
                lastUsedDevice: "iPhone 15",
                language: "en",
                temperatureUnit: "Celsius",
                favoriteOnly: false,
                userNote: "Try new version with garlic.",
                includeImages: true,
                showQuickRecipes: true,
                filterGroup: "Default",
                cacheKey: "query_tomatoSoup"
            )
        ]
        
        favorites = [
            FavoriteEntry(
                recipeId: recipes[0].id,
                note: "All-time favorite soup.",
                rating: 5.0,
                timesCooked: 8,
                customLabel: "Comfort",
                moodTag: "Relaxed",
                sharedWithFriends: false,
                imagePreview: "tomatoSoup",
                category: "Vegetarian",
                cuisine: "Italian",
                isWeeklyFavorite: true,
                isSeasonalPick: false,
                isHealthyChoice: true,
                author: "Chef Anna",
                preparationTips: "Blend longer for smoother texture.",
                nutritionSummary: "Low fat, moderate carbs",
                cookCount: 8,
                recipeName: "Creamy Tomato Basil Soup",
                spiceLevel: "Mild",
                flavorProfile: "Savory",
                favoriteReason: "Comfort food",
                difficultyLevel: "Easy",
                prepTime: 10,
                cookTime: 20,
                totalTime: 30,
                ratingOutOfFive: 5,
                locationAdded: "Home Kitchen",
                source: "Homemade",
                backupStatus: "Saved",
                reviewText: "Always turns out perfect!",
                moodWhenCooked: "Happy"
            )
        ]
        
        reminders = [
            CookingReminder(
                recipeId: recipes[0].id,
                title: "Start simmering Tomato Soup",
                fireDate: Date().addingTimeInterval(3600),
                repeatIntervalMinutes: nil,
                isActive: true,
                reminderMessage: "Don’t forget to stir occasionally!",
                soundName: "chime",
                vibrationEnabled: true,
                alertType: "standard",
                snoozeMinutes: 10,
                repeatDays: [],
                isPersistent: false,
                priorityLevel: "medium",
                reminderCategory: "Cooking",
                recipeName: "Tomato Soup",
                durationMinutes: 20,
                colorCode: "red",
                iconName: "timer",
                showOnLockScreen: true,
                isSilent: false,
                autoDeleteAfterTrigger: true,
                isRecurring: false,
                kitchenZone: "Stovetop",
                assignedUser: "Self",
                displayOrder: 1,
                locationContext: "Home Kitchen",
                notes: "Add basil near the end.",
                completed: false
            )
        ]
        
        measurementPrefs = [
            MeasurementPreference(
                unitSystem: "Metric",
                decimalPlaces: 1,
                weightUnit: "grams",
                volumeUnit: "ml",
                temperatureUnit: "Celsius",
                pressureUnit: "bar",
                preferredLanguage: "English",
                defaultCurrency: "USD",
                roundingMode: "nearest",
                conversionPrecision: 2,
                autoConvertEnabled: true,
                showFractionUnits: false,
                displayAbbreviations: true,
                fontScale: 1.0,
                theme: "Light",
                showTips: true,
                quickEntryMode: false,
                includeScientificUnits: false,
                temperatureDisplayFormat: "°C",
                ingredientSortOption: "alphabetical",
                recipeDisplayMode: "compact",
                rememberLastChoice: true,
                vibrationFeedback: true,
                hapticLevel: 2,
                preferredDateFormat: "dd-MM-yyyy",
                colorScheme: "system",
                accessibilityTextSize: 16,
                highContrastEnabled: false,
                autoSaveSettings: true,
                defaultPortionSize: 1,
                useLocalFormatting: true,
                region: "Pakistan",
                backupEnabled: true,
                appVersion: "1.0",
                developerMode: false
            )
        ]
        
        saveData()
    }
}
