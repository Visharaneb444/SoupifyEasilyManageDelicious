import SwiftUI
import Foundation
import Combine

@available(iOS 14.0, *)
extension Date {
    func formattedString() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: self)
    }
}

@available(iOS 14.0, *)
struct RecipeAddFieldView: View {
    let title: String
    let iconName: String
    @Binding var text: String
    var keyboardType: UIKeyboardType = .default
    var isRequired: Bool = true
    var isNumeric: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(title)
                .font(.caption)
                .foregroundColor(.gray)
                .opacity(text.isEmpty ? 0 : 1)
                .animation(.easeOut(duration: 0.15), value: text.isEmpty)
            
            HStack {
                Image(systemName: iconName)
                    .foregroundColor(text.isEmpty && isRequired ? .red : .accentColor)
                
                TextField(title, text: $text)
                    .keyboardType(keyboardType)
                    .onReceive(Just(text)) { newValue in
                        if isNumeric {
                            let filtered = newValue.filter { "0123456789.".contains($0) }
                            if filtered != newValue {
                                self.text = filtered
                            }
                        }
                    }
            }
            .padding(.vertical, 8)
            .padding(.horizontal, 10)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(text.isEmpty && isRequired ? Color.red.opacity(0.5) : Color.gray.opacity(0.3), lineWidth: 1)
            )
            .frame(height: 50)
            
            if text.isEmpty && isRequired {
                Text("Required")
                    .font(.caption2)
                    .foregroundColor(.red)
            }
        }
    }
}

@available(iOS 14.0, *)
struct RecipeAddOptionalDatePickerView: View {
    let title: String
    let iconName: String
    @Binding var date: Date?
    @State private var useDate: Bool
    @State private var tempDate: Date
    
    init(title: String, iconName: String, date: Binding<Date?>) {
        self.title = title
        self.iconName = iconName
        self._date = date
        let initialDate = date.wrappedValue ?? Date()
        self._tempDate = State(initialValue: initialDate)
        self._useDate = State(initialValue: date.wrappedValue != nil)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            HStack {
                Image(systemName: iconName)
                    .foregroundColor(.accentColor)
                Text(title)
                    .font(.body)
                Spacer()
                Toggle("", isOn: $useDate)
                    .labelsHidden()
                    .onReceive(Just(useDate)) { newValue in
                        if newValue {
                            date = tempDate
                        } else {
                            date = nil
                        }
                    }
            }
            .padding(.vertical, 8)
            .padding(.horizontal, 10)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.secondary.opacity(0.1))
            )
            
            if useDate {
                DatePicker("Select Date", selection: $tempDate, displayedComponents: .date)
                    .labelsHidden()
                    .datePickerStyle(CompactDatePickerStyle())
                    .padding(.horizontal)
                    .onReceive(Just(tempDate)) { newValue in
                        date = newValue
                    }

            }
        }
    }
}

@available(iOS 14.0, *)
struct RecipeAddSectionHeaderView: View {
    let title: String
    let iconName: String
    
    var body: some View {
        HStack {
            Image(systemName: iconName)
                .foregroundColor(.white)
                .padding(6)
                .background(Color.orange)
                .cornerRadius(6)
            Text(title)
                .font(.headline)
                .foregroundColor(.primary)
            Spacer()
        }
        .padding(.top)
    }
}

@available(iOS 14.0, *)
struct RecipeAddToggleView: View {
    let title: String
    let iconName: String
    @Binding var isOn: Bool
    
    var body: some View {
        HStack {
            Image(systemName: iconName)
                .foregroundColor(.accentColor)
            Text(title)
                .font(.body)
            Spacer()
            Toggle("", isOn: $isOn)
                .labelsHidden()
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 10)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.secondary.opacity(0.1))
        )
    }
}

@available(iOS 14.0, *)
struct RecipeDetailFieldRow: View {
    let label: String
    let value: String
    let iconName: String
    let color: Color
    
    var body: some View {
        HStack {
            Image(systemName: iconName)
                .foregroundColor(color)
                .frame(width: 20)
            
            Text(label)
                .font(.caption)
                .foregroundColor(.secondary)
            
            Spacer()
            
            Text(value)
                .font(.subheadline)
                .fontWeight(.medium)
                .lineLimit(1)
        }
    }
}

@available(iOS 14.0, *)
struct RecipeAddView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var dataStore: SoupDataStore
    
    @State private var title: String = ""
    @State private var summary: String = ""
    @State private var category: String = "Main Dish"
    @State private var cuisine: String = "International"
    @State private var difficulty: String = "Medium"
    @State private var ingredientsList: String = ""
    @State private var stepsList: String = ""
    @State private var prepMinutesText: String = ""
    @State private var cookMinutesText: String = ""
    @State private var servingsText: String = ""
    @State private var author: String = ""
    @State private var notes: String = ""
    @State private var ratingText: String = ""
    @State private var caloriesText: String = ""
    @State private var proteinGramsText: String = ""
    @State private var fatGramsText: String = ""
    @State private var carbsGramsText: String = ""
    @State private var tagsList: String = ""
    @State private var isVegetarian: Bool = false
    @State private var isVegan: Bool = false
    @State private var isGlutenFree: Bool = false
    @State private var isDairyFree: Bool = false
    @State private var mainIngredient: String = ""
    @State private var utensilNeeded: String = ""
    @State private var temperatureCelsiusText: String = ""
    @State private var imageName: String = ""
    @State private var videoLink: String = ""
    @State private var source: String = ""
    @State private var region: String = ""
    @State private var flavorProfile: String = ""
    @State private var costEstimate: String = "Low"
    
    @State private var lastCooked: Date? = nil
    
    @State private var showingAlert = false
    @State private var alertMessage = ""
    
    private var requiredFields: [(String, String)] {
        [
            (title, "Title"), (summary, "Summary"), (prepMinutesText, "Prep Time"),
            (cookMinutesText, "Cook Time"), (servingsText, "Servings"), (author, "Author"),
            (ratingText, "Rating"), (caloriesText, "Calories"), (proteinGramsText, "Protein"),
            (fatGramsText, "Fat"), (carbsGramsText, "Carbs"), (mainIngredient, "Main Ingredient"),
            (utensilNeeded, "Utensil Needed"), (imageName, "Image Name"), (source, "Source"),
            (ingredientsList, "Ingredients"), (stepsList, "Steps"), (notes, "Notes"),
            (temperatureCelsiusText, "Temperature"), (region, "Region"), (flavorProfile, "Flavor Profile"),
            (videoLink, "Video Link")
        ]
    }
    
    private func validateAndSave() {
        var errors: [String] = []
        
        for (fieldValue, fieldName) in requiredFields {
            if fieldValue.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                errors.append("\(fieldName) is required.")
            }
        }
        
        guard let prepMin = Int(prepMinutesText),
              let cookMin = Int(cookMinutesText),
              let servings = Int(servingsText),
              let rating = Double(ratingText),
              let calories = Int(caloriesText),
              let protein = Double(proteinGramsText),
              let fat = Double(fatGramsText),
              let carbs = Double(carbsGramsText),
              let temp = Double(temperatureCelsiusText) else {
            errors.append("One or more numeric fields are invalid.")
            alertMessage = "Please correct the following errors:\n\n• " + errors.joined(separator: "\n• ")
            showingAlert = true
            return
        }
        
        if errors.isEmpty {
            let newRecipe = Recipe(
                title: title,
                summary: summary,
                category: category,
                cuisine: cuisine,
                difficulty: difficulty,
                ingredients: ingredientsList.split(separator: "\n").map { $0.trimmingCharacters(in: .whitespacesAndNewlines) },
                steps: stepsList.split(separator: "\n").map { $0.trimmingCharacters(in: .whitespacesAndNewlines) },
                prepMinutes: prepMin,
                cookMinutes: cookMin,
                totalMinutes: prepMin + cookMin,
                servings: servings,
                author: author,
                notes: notes,
                rating: rating,
                calories: calories,
                proteinGrams: protein,
                fatGrams: fat,
                carbsGrams: carbs,
                tags: tagsList.split(separator: ",").map { $0.trimmingCharacters(in: .whitespacesAndNewlines) },
                isVegetarian: isVegetarian,
                isVegan: isVegan,
                isGlutenFree: isGlutenFree,
                isDairyFree: isDairyFree,
                mainIngredient: mainIngredient,
                utensilNeeded: utensilNeeded,
                temperatureCelsius: temp,
                imageName: imageName,
                videoLink: videoLink,
                source: source,
                region: region,
                flavorProfile: flavorProfile,
                costEstimate: costEstimate,
                favoriteCount: 0,
                lastCooked: lastCooked
            )
            
            dataStore.addRecipe(newRecipe)
            
            alertMessage = "Recipe **\(newRecipe.title)** saved successfully!"
            showingAlert = true
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            }
            
        } else {
            alertMessage = "Please correct the following errors:\n\n• " + errors.joined(separator: "\n• ")
            showingAlert = true
        }
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 25) {
                    
                    RecipeAddSectionHeaderView(title: "Core Information", iconName: "fork.knife")
                    
                    VStack(spacing: 15) {
                        RecipeAddFieldView(title: "Title", iconName: "text.cursor", text: $title)
                        RecipeAddFieldView(title: "Summary (Brief)", iconName: "doc.text", text: $summary)
                        RecipeAddFieldView(title: "Author", iconName: "person.fill", text: $author)
                        
                        HStack(spacing: 15) {
                            Picker("Category", selection: $category) {
                                Text("Main Dish").tag("Main Dish")
                                Text("Soup").tag("Soup")
                                Text("Dessert").tag("Dessert")
                            }
                            .pickerStyle(MenuPickerStyle())
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.secondary.opacity(0.1))
                            .cornerRadius(10)
                            
                            Picker("Difficulty", selection: $difficulty) {
                                Text("Easy").tag("Easy")
                                Text("Medium").tag("Medium")
                                Text("Hard").tag("Hard")
                            }
                            .pickerStyle(MenuPickerStyle())
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.secondary.opacity(0.1))
                            .cornerRadius(10)
                        }
                    }
                    .padding(.horizontal)
                    
                    RecipeAddSectionHeaderView(title: "Timing & Serving", iconName: "timer")
                    
                    VStack(spacing: 15) {
                        HStack {
                            RecipeAddFieldView(title: "Prep (min)", iconName: "hourglass.tophalf.fill", text: $prepMinutesText, keyboardType: .numberPad, isNumeric: true)
                            RecipeAddFieldView(title: "Cook (min)", iconName: "oven.fill", text: $cookMinutesText, keyboardType: .numberPad, isNumeric: true)
                        }
                        
                        HStack {
                            RecipeAddFieldView(title: "Servings", iconName: "person.3.fill", text: $servingsText, keyboardType: .numberPad, isNumeric: true)
                            RecipeAddFieldView(title: "Rating (0.0-5.0)", iconName: "star.fill", text: $ratingText, keyboardType: .decimalPad, isNumeric: true)
                        }
                        
                        RecipeAddOptionalDatePickerView(title: "Last Cooked Date", iconName: "calendar.badge.clock", date: $lastCooked)
                    }
                    .padding(.horizontal)
                    
                    RecipeAddSectionHeaderView(title: "Ingredients & Instructions", iconName: "book.closed.fill")
                    
                    VStack(spacing: 15) {
                        RecipeAddFieldView(title: "Ingredients (one per line)", iconName: "list.bullet", text: $ingredientsList)
                            .frame(height: 100)
                        
                        RecipeAddFieldView(title: "Steps (one per line)", iconName: "figure.walk", text: $stepsList)
                            .frame(height: 150)
                        
                        RecipeAddFieldView(title: "Notes", iconName: "note.text", text: $notes)
                            .frame(height: 70)
                        
                        RecipeAddFieldView(title: "Tags (comma separated)", iconName: "tag.circle.fill", text: $tagsList, isRequired: false)
                        
                        RecipeAddFieldView(title: "Main Ingredient", iconName: "bag.fill", text: $mainIngredient)
                        
                        RecipeAddFieldView(title: "Utensil Needed", iconName: "kitchenaid.stand.mixer", text: $utensilNeeded)
                    }
                    .padding(.horizontal)
                    
                    RecipeAddSectionHeaderView(title: "Nutrition & Meta", iconName: "leaf.fill")
                    
                    VStack(spacing: 15) {
                        RecipeAddFieldView(title: "Calories", iconName: "flame.fill", text: $caloriesText, keyboardType: .numberPad, isNumeric: true)
                        
                        HStack {
                            RecipeAddFieldView(title: "Protein (g)", iconName: "cube.box.fill", text: $proteinGramsText, keyboardType: .decimalPad, isNumeric: true)
                            RecipeAddFieldView(title: "Fat (g)", iconName: "drop.fill", text: $fatGramsText, keyboardType: .decimalPad, isNumeric: true)
                            RecipeAddFieldView(title: "Carbs (g)", iconName: "leaf.fill", text: $carbsGramsText, keyboardType: .decimalPad, isNumeric: true)
                        }
                        
                        RecipeAddToggleView(title: "Vegetarian", iconName: "carrot.fill", isOn: $isVegetarian)
                        RecipeAddToggleView(title: "Vegan", iconName: "sun.max.fill", isOn: $isVegan)
                        RecipeAddToggleView(title: "Gluten-Free", iconName: "minus.circle.fill", isOn: $isGlutenFree)
                        RecipeAddToggleView(title: "Dairy-Free", iconName: "milk.fill", isOn: $isDairyFree)
                    }
                    .padding(.horizontal)
                    
                    RecipeAddSectionHeaderView(title: "Source & Context", iconName: "globe")
                    
                    VStack(spacing: 15) {
                        Picker("Cost Estimate", selection: $costEstimate) {
                            Text("Low").tag("Low")
                            Text("Medium").tag("Medium")
                            Text("High").tag("High")
                        }
                        .pickerStyle(MenuPickerStyle())
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.secondary.opacity(0.1))
                        .cornerRadius(10)
                        .padding(.horizontal)
                        
                        RecipeAddFieldView(title: "Cuisine", iconName: "location.fill", text: $cuisine)
                        RecipeAddFieldView(title: "Region", iconName: "map.fill", text: $region)
                        RecipeAddFieldView(title: "Flavor Profile", iconName: "mouth.fill", text: $flavorProfile)
                        RecipeAddFieldView(title: "Image Name", iconName: "photo.fill", text: $imageName)
                        RecipeAddFieldView(title: "Video Link", iconName: "link", text: $videoLink)
                        RecipeAddFieldView(title: "Source Name", iconName: "book.fill", text: $source)
                        RecipeAddFieldView(title: "Oven Temp (°C)", iconName: "thermometer", text: $temperatureCelsiusText, keyboardType: .decimalPad, isNumeric: true)
                    }
                    .padding(.horizontal)
                    
                    Button(action: validateAndSave) {
                        HStack {
                            Image(systemName: "plus.circle.fill")
                            Text("Add New Recipe")
                        }
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(15)
                        .shadow(color: .blue.opacity(0.5), radius: 10, x: 0, y: 5)
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 30)
                }
            }
            .navigationTitle("New Recipe Creation")
            .background(Color.gray.opacity(0.05).edgesIgnoringSafeArea(.all))
            .alert(isPresented: $showingAlert) {
                Alert(title: Text("Form Status"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
        }
        .navigationViewStyle(.stack)
    }
}

@available(iOS 14.0, *)
struct RecipeSearchBarView: View {
    @Binding var searchText: String
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.secondary)
            
            TextField("Search recipes...", text: $searchText)
                .foregroundColor(.primary)
                .padding(.vertical, 8)
                .background(Color.clear)
            
            if !searchText.isEmpty {
                Button(action: {
                    self.searchText = ""
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                }
            }
        }
        .padding(.horizontal, 10)
        .background(Color(.systemGray6))
        .cornerRadius(10)
        .shadow(color: .gray.opacity(0.2), radius: 5, x: 0, y: 2)
        .padding([.horizontal, .top])
    }
}

@available(iOS 14.0, *)
struct RecipeListRowView: View {
    let recipe: Recipe
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            
            HStack(alignment: .top) {
                VStack(alignment: .leading) {
                    Text(recipe.title)
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                        .lineLimit(1)
                    
                    HStack(spacing: 5) {
                        Text("\(recipe.cuisine) • \(recipe.category)")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        if recipe.isVegetarian {
                            Image(systemName: "leaf.circle.fill").foregroundColor(.green)
                        }
                        if recipe.isGlutenFree {
                            Image(systemName: "drop.circle.fill").foregroundColor(.blue)
                        }
                    }
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 5) {
                    HStack(spacing: 2) {
                        Image(systemName: "star.fill")
                            .foregroundColor(.yellow)
                            .font(.caption)
                        Text(String(format: "%.1f", recipe.rating))
                            .font(.subheadline)
                            .fontWeight(.semibold)
                    }
                    .padding(5)
                    .background(Color.yellow.opacity(0.1))
                    .cornerRadius(5)
                    
                    Text(recipe.difficulty)
                        .font(.caption2)
                        .foregroundColor(.white)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 3)
                        .background(recipe.difficulty == "Easy" ? Color.green : recipe.difficulty == "Medium" ? Color.orange : Color.red)
                        .cornerRadius(5)
                }
            }
            .padding(.horizontal)
            .padding(.top)
            
            Rectangle()
                .frame(height: 1)
                .foregroundColor(Color.gray.opacity(0.1))
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 8) {
                RecipeListStatView(icon: "clock.fill", label: "Total Time", value: "\(recipe.totalMinutes)m", color: .blue)
                RecipeListStatView(icon: "flame.fill", label: "Calories", value: "\(recipe.calories) kcal", color: .red)
                RecipeListStatView(icon: "person.3.fill", label: "Servings", value: "\(recipe.servings)", color: .orange)
                
                RecipeListStatView(icon: "pencil.circle.fill", label: "Author", value: recipe.author, color: .purple)
                RecipeListStatView(icon: "tag.fill", label: "Main Ing.", value: recipe.mainIngredient, color: .green)
                RecipeListStatView(icon: "map.fill", label: "Region", value: recipe.region, color: .yellow)
            }
            .padding([.horizontal, .bottom])
            
            VStack(alignment: .leading, spacing: 5) {
                Text("Summary:")
                    .font(.caption)
                    .fontWeight(.semibold)
                Text(recipe.summary)
                    .font(.footnote)
                    .foregroundColor(.gray)
                    .lineLimit(2)
            }
            .padding(.horizontal)
            .padding(.bottom)
            
        }
        .background(Color.white)
        .cornerRadius(15)
        .shadow(color: .gray.opacity(0.2), radius: 8, x: 0, y: 5)
        .padding(.horizontal, 15)
        .padding(.vertical, 5)
    }
}

@available(iOS 14.0, *)
struct RecipeListStatView: View {
    let icon: String
    let label: String
    let value: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 5) {
            Image(systemName: icon)
                .foregroundColor(color)
                .font(.caption2)
            
            VStack(alignment: .leading, spacing: 1) {
                Text(label)
                    .font(.caption2)
                    .foregroundColor(.secondary)
                Text(value)
                    .font(.footnote)
                    .fontWeight(.bold)
                    .lineLimit(1)
            }
        }
    }
}

@available(iOS 14.0, *)
struct RecipeNoDataView: View {
    var body: some View {
        VStack(spacing: 15) {
            Image(systemName: "bowl.fill")
                .font(.largeTitle)
                .foregroundColor(.orange)
                .padding()
                .background(Circle().fill(Color.orange.opacity(0.1)))
            
            Text("No Recipes Found")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.primary)
            
            Text("Try adjusting your search filters or add a new recipe to get started.")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
        }
        .padding(.top, 50)
    }
}

@available(iOS 14.0, *)
struct RecipeListView: View {
    @ObservedObject var dataStore: SoupDataStore
    @State private var searchText: String = ""
    @State private var showingAddSheet = false
    
    var filteredRecipes: [Recipe] {
        if searchText.isEmpty {
            return dataStore.recipes
        } else {
            return dataStore.recipes.filter { recipe in
                recipe.title.localizedCaseInsensitiveContains(searchText) ||
                recipe.summary.localizedCaseInsensitiveContains(searchText) ||
                recipe.ingredients.joined(separator: " ").localizedCaseInsensitiveContains(searchText) ||
                recipe.cuisine.localizedCaseInsensitiveContains(searchText) ||
                recipe.category.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    private func deleteRecipe(at offsets: IndexSet) {
        let recipesToDelete = offsets.map { filteredRecipes[$0] }
        
        let originalIndices: [Int] = recipesToDelete.compactMap { recipeToDelete in
            dataStore.recipes.firstIndex(where: { $0.id == recipeToDelete.id })
        }
        
        let originalIndexSet = IndexSet(originalIndices)
        
        dataStore.deleteRecipe(at: originalIndexSet)
    }
    
    var body: some View {
            VStack {
                
                RecipeSearchBarView(searchText: $searchText)
                
                if filteredRecipes.isEmpty {
                    RecipeNoDataView()
                    Spacer()
                } else {
                    List {
                        ForEach(filteredRecipes) { recipe in
                            NavigationLink(destination: RecipeDetailView(recipe: recipe)) {
                                RecipeListRowView(recipe: recipe)
                                    .padding(.vertical, 5)
                                    .listRowInsets(EdgeInsets())
                                    .background(Color.clear)
                            }
                        }
                        .onDelete(perform: deleteRecipe)
                    }
                    .listStyle(PlainListStyle())
                    .padding(.top, -10)
                }
            }
            .navigationTitle("Cookbook")
            .navigationBarItems(trailing:
                Button(action: {
                    showingAddSheet = true
                }) {
                    Image(systemName: "plus.circle.fill")
                        .font(.title2)
                        .foregroundColor(.blue)
                }
            )
            .sheet(isPresented: $showingAddSheet) {
                RecipeAddView()
                    .environmentObject(dataStore)
            }
        
        .navigationViewStyle(.stack)
    }
}

@available(iOS 14.0, *)
struct RecipeDetailView: View {
    let recipe: Recipe
    
    var body: some View {
        ScrollView {
            VStack(spacing: 25) {
                
                VStack {
                    Image(systemName: recipe.imageName.isEmpty ? "photo.fill" : recipe.imageName)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 150)
                        .cornerRadius(15)
                        .overlay(
                            RoundedRectangle(cornerRadius: 15).stroke(Color.gray.opacity(0.2), lineWidth: 1)
                        )
                        .padding(.top, 20)
                    
                    Text(recipe.summary)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .padding(.horizontal)
                        .padding(.top, 5)
                }
                .frame(maxWidth: .infinity)
                .background(Color.white)
                .cornerRadius(20)
                .shadow(color: Color.gray.opacity(0.15), radius: 10, x: 0, y: 5)
                .padding(.horizontal)
                
                VStack(alignment: .leading, spacing: 10) {
                    Text("Vital Stats")
                        .font(.title3)
                        .fontWeight(.bold)
                        .padding(.leading, 15)
                    
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 15) {
                        
                        RecipeDetailFieldRow(label: "Prep Time", value: "\(recipe.prepMinutes) min", iconName: "hourglass.tophalf.fill", color: .blue)
                        RecipeDetailFieldRow(label: "Cook Time", value: "\(recipe.cookMinutes) min", iconName: "oven.fill", color: .red)
                        RecipeDetailFieldRow(label: "Total Time", value: "\(recipe.totalMinutes) min", iconName: "clock.fill", color: .orange)
                        RecipeDetailFieldRow(label: "Servings", value: "\(recipe.servings)", iconName: "person.3.fill", color: .green)
                        RecipeDetailFieldRow(label: "Difficulty", value: recipe.difficulty, iconName: "speedometer", color: .purple)
                        RecipeDetailFieldRow(label: "Rating", value: String(format: "%.1f / 5.0", recipe.rating), iconName: "star.fill", color: .yellow)
                        RecipeDetailFieldRow(label: "Category", value: recipe.category, iconName: "tag.fill", color: .blue)
                        RecipeDetailFieldRow(label: "Cuisine", value: recipe.cuisine, iconName: "globe", color: .pink)
                        
                    }
                    .padding()
                    .background(Color.secondary.opacity(0.05))
                    .cornerRadius(15)
                    .padding(.horizontal)
                }
                
                HStack(alignment: .top, spacing: 15) {
                    
                    VStack(alignment: .leading, spacing: 10) {
                        HStack {
                            Image(systemName: "list.bullet.rectangle.fill").foregroundColor(.accentColor)
                            Text("Ingredients")
                                .font(.headline)
                        }
                        VStack(alignment: .leading, spacing: 5) {
                            ForEach(recipe.ingredients, id: \.self) { ingredient in
                                Text("• \(ingredient)")
                                    .font(.subheadline)
                                    .foregroundColor(.primary)
                            }
                        }
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue.opacity(0.1))
                    .cornerRadius(15)
                    
                    VStack(alignment: .leading, spacing: 10) {
                        HStack {
                            Image(systemName: "figure.walk").foregroundColor(.accentColor)
                            Text("Instructions")
                                .font(.headline)
                        }
                        VStack(alignment: .leading, spacing: 5) {
                            ForEach(recipe.steps.indices, id: \.self) { index in
                                Text("**Step \(index + 1):** \(recipe.steps[index])")
                                    .font(.subheadline)
                                    .foregroundColor(.primary)
                            }
                        }
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.green.opacity(0.1))
                    .cornerRadius(15)
                }
                .padding(.horizontal)
                
                VStack(alignment: .leading, spacing: 10) {
                    Text("Nutrition & Metadata")
                        .font(.title3)
                        .fontWeight(.bold)
                        .padding(.leading, 15)
                    
                    VStack(spacing: 12) {
                        RecipeDetailFieldRow(label: "Protein", value: String(format: "%.1f g", recipe.proteinGrams), iconName: "cube.box.fill", color: .red)
                        RecipeDetailFieldRow(label: "Fat", value: String(format: "%.1f g", recipe.fatGrams), iconName: "drop.fill", color: .red)
                        RecipeDetailFieldRow(label: "Carbs", value: String(format: "%.1f g", recipe.carbsGrams), iconName: "leaf.fill", color: .green)
                        RecipeDetailFieldRow(label: "Calories", value: "\(recipe.calories) kcal", iconName: "flame.fill", color: .red)
                        
                        Divider()
                        
                        RecipeDetailFieldRow(label: "Utensil Needed", value: recipe.utensilNeeded, iconName: "kitchenaid.stand.mixer", color: .gray)
                        RecipeDetailFieldRow(label: "Temperature", value: String(format: "%.1f °C", recipe.temperatureCelsius), iconName: "thermometer", color: .orange)
                        RecipeDetailFieldRow(label: "Source", value: recipe.source, iconName: "link.circle.fill", color: .blue)
                        RecipeDetailFieldRow(label: "Region", value: recipe.region, iconName: "map.fill", color: .yellow)
                        RecipeDetailFieldRow(label: "Flavor Profile", value: recipe.flavorProfile, iconName: "mouth.fill", color: .purple)
                        RecipeDetailFieldRow(label: "Cost Estimate", value: recipe.costEstimate, iconName: "dollarsign.circle.fill", color: .green)
                        RecipeDetailFieldRow(label: "Video Link", value: recipe.videoLink.isEmpty ? "N/A" : "Available", iconName: "video.fill", color: .red)
                        
                        Divider()
                        
                        RecipeDetailFieldRow(label: "Vegetarian", value: recipe.isVegetarian ? "Yes" : "No", iconName: recipe.isVegetarian ? "checkmark.circle.fill" : "xmark.circle.fill", color: .green)
                        RecipeDetailFieldRow(label: "Vegan", value: recipe.isVegan ? "Yes" : "No", iconName: recipe.isVegan ? "leaf.fill" : "leaf.slash.fill", color: .green)
                        RecipeDetailFieldRow(label: "Gluten-Free", value: recipe.isGlutenFree ? "Yes" : "No", iconName: recipe.isGlutenFree ? "drop.fill" : "drop.slash.fill", color: .blue)
                        RecipeDetailFieldRow(label: "Dairy-Free", value: recipe.isDairyFree ? "Yes" : "No", iconName: recipe.isDairyFree ? "milk.fill" : "milk.slash.fill", color: .blue)
                        
                        Divider()
                        
                        RecipeDetailFieldRow(label: "Author", value: recipe.author, iconName: "person.crop.circle.fill", color: .pink)
                        RecipeDetailFieldRow(label: "Created At", value: recipe.createdAt.formattedString(), iconName: "calendar", color: .green)
                        RecipeDetailFieldRow(label: "Last Cooked", value: recipe.lastCooked?.formattedString() ?? "Never", iconName: "gobackward", color: .orange)
                        RecipeDetailFieldRow(label: "Favorite Count", value: "\(recipe.favoriteCount)", iconName: "heart.fill", color: .red)
                        RecipeDetailFieldRow(label: "Notes", value: recipe.notes.isEmpty ? "None" : recipe.notes, iconName: "note.text.fill", color: .gray)
                        
                        Divider()
                        
                        HStack {
                            Text("Tags:")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            ForEach(recipe.tags, id: \.self) { tag in
                                Text(tag)
                                    .font(.caption2)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 4)
                                    .background(Color.yellow.opacity(0.2))
                                    .cornerRadius(8)
                            }
                        }
                        .padding(.top, 5)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(15)
                    .shadow(color: Color.gray.opacity(0.1), radius: 5, x: 0, y: 3)
                    .padding(.horizontal)
                    .padding(.bottom, 20)
                }
            }
        }
        .navigationTitle(recipe.title)
        .navigationBarTitleDisplayMode(.inline)
    }
}
