import SwiftUI
import Foundation
import Combine



extension Color {
    static let soupPrimary = Color(red: 0.1, green: 0.4, blue: 0.8)
    static let soupAccent = Color(red: 0.9, green: 0.5, blue: 0.2)
    static let soupBackground = Color(UIColor.systemGray6)
    static let soupCard = Color(UIColor.systemBackground)
}

extension DateFormatter {
    static let customShort: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter
    }()
}

@available(iOS 14.0, *)
struct SearchQueryIconLabel: View {
    let iconName: String
    let text: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: iconName)
                .foregroundColor(color)
                .font(.caption)
            Text(text)
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }
}

@available(iOS 14.0, *)
struct SearchQueryAddSectionHeaderView: View {
    let title: String
    let iconName: String
    
    var body: some View {
        HStack {
            Image(systemName: iconName)
                .foregroundColor(.soupPrimary)
                .font(.headline)
            Text(title)
                .font(.headline)
                .foregroundColor(.primary)
            Spacer()
        }
        .padding(.top, 20)
        .padding(.bottom, 5)
    }
}

@available(iOS 14.0, *)
struct SearchQueryAddFieldView: View {
    let title: String
    let iconName: String
    @Binding var text: String
    let keyboardType: UIKeyboardType
    
    @State private var isEditing: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.caption)
                .foregroundColor(isEditing ? .soupAccent : .secondary)
                .animation(.easeInOut(duration: 0.2), value: isEditing)
            
            HStack(spacing: 10) {
                Image(systemName: iconName)
                    .foregroundColor(.soupPrimary)
                    .frame(width: 20)
                
                TextField("", text: $text) { isEditing in
                    self.isEditing = isEditing
                } onCommit: {}
                .keyboardType(keyboardType)
                .padding(.vertical, 8)
            }
            
            Rectangle()
                .frame(height: 1)
                .foregroundColor(isEditing ? .soupAccent : .soupBackground)
        }
        .padding(.horizontal, 10)
    }
}

@available(iOS 14.0, *)
struct SearchQueryAddStepperFieldView: View {
    let title: String
    let iconName: String
    @Binding var value: Int
    let range: ClosedRange<Int>
    let step: Int
    
    var body: some View {
        HStack {
            Image(systemName: iconName)
                .foregroundColor(.soupPrimary)
            
            Text(title)
                .foregroundColor(.primary)
            
            Spacer()
            
            Stepper("\(value) min", value: $value, in: range, step: step)
                .labelsHidden()
            
            Text("\(value) min")
                .font(.headline)
                .foregroundColor(.soupAccent)
                .frame(minWidth: 50, alignment: .trailing)
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 8)
        .background(Color.soupCard)
        .cornerRadius(8)
    }
}

@available(iOS 14.0, *)
struct SearchQueryAddToggleFieldView: View {
    let title: String
    let iconName: String
    @Binding var isOn: Bool
    
    var body: some View {
        HStack {
            Image(systemName: iconName)
                .foregroundColor(.soupPrimary)
            
            Text(title)
                .foregroundColor(.primary)
            
            Spacer()
            
            Toggle("", isOn: $isOn)
                .labelsHidden()
                .toggleStyle(SwitchToggleStyle(tint: .soupAccent))
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 8)
        .background(Color.soupCard)
        .cornerRadius(8)
    }
}

@available(iOS 14.0, *)
struct SearchQueryAddPickerFieldView: View {
    let title: String
    let iconName: String
    @Binding var selection: String
    let options: [String]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
            
            HStack {
                Image(systemName: iconName)
                    .foregroundColor(.soupPrimary)
                
                Picker(title, selection: $selection) {
                    ForEach(options, id: \.self) { option in
                        Text(option).tag(option)
                    }
                }
                .pickerStyle(MenuPickerStyle())
                .labelsHidden()
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 4)
            .background(Color.soupCard)
            .cornerRadius(8)
        }
    }
}

@available(iOS 14.0, *)
struct SearchQueryAddRatingView: View {
    @Binding var rating: Double
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text("Min Rating")
                .font(.caption)
                .foregroundColor(.secondary)
            
            HStack(spacing: 5) {
                Image(systemName: "star.fill")
                    .foregroundColor(.soupAccent)
                
                Slider(value: $rating, in: 0...5, step: 0.5)
                    .accentColor(.soupAccent)
                
                Text(String(format: "%.1f", rating))
                    .font(.callout)
                    .foregroundColor(.primary)
                    .frame(width: 30)
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 8)
            .background(Color.soupCard)
            .cornerRadius(8)
        }
    }
}

@available(iOS 14.0, *)
struct SearchQueryAddView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var dataStore: SoupDataStore
    
    @State private var text: String = ""
    @State private var ingredientFilters: String = ""
    @State private var maxCookTime: Int = 45
    @State private var minRating: Double = 3.0
    @State private var maxCalories: String = "400"
    @State private var categoryFilter: String = "All"
    @State private var cuisineFilter: String = "All"
    @State private var isVegetarianOnly: Bool = false
    @State private var isVeganOnly: Bool = false
    @State private var includeGlutenFree: Bool = true
    @State private var includeDairyFree: Bool = false
    @State private var sortOption: String = "Relevance"
    @State private var sortOrder: String = "Descending"
    @State private var showFavoritesOnly: Bool = false
    @State private var includeTags: String = ""
    @State private var excludeTags: String = ""
    @State private var lastUsed: Date? = nil
    @State private var searchCount: String = "1"
    @State private var totalResults: String = "0"
    @State private var recentResultTitles: String = ""
    @State private var isAdvancedMode: Bool = false
    @State private var difficultyLevel: String = "All"
    @State private var authorFilter: String = ""
    @State private var regionFilter: String = ""
    @State private var keywordMatchType: String = "Fuzzy"
    @State private var autoSuggestionsEnabled: Bool = true
    @State private var lastUsedDevice: String = "iPhone"
    @State private var language: String = "en"
    @State private var temperatureUnit: String = "Celsius"
    @State private var userNote: String = ""
    @State private var includeImages: Bool = true
    @State private var showQuickRecipes: Bool = false
    @State private var filterGroup: String = "Custom"
    @State private var cacheKey: String = UUID().uuidString
    
    @State private var showingAlert = false
    @State private var alertMessage = ""
    
    let categoryOptions = ["All", "Soup", "Stew", "Chili", "Broth"]
    let cuisineOptions = ["All", "Italian", "Asian", "Mexican", "Continental"]
    let sortOptions = ["Relevance", "Rating", "Cook Time", "Calories"]
    let sortOrderOptions = ["Ascending", "Descending"]
    let difficultyOptions = ["All", "Easy", "Medium", "Hard"]
    let keywordMatchOptions = ["Exact", "Fuzzy", "Partial"]
    let languageOptions = ["en", "es", "fr"]
    let unitOptions = ["Celsius", "Fahrenheit"]
    
    private func validateAndSave() {
        var errors: [String] = []
        
        if text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            errors.append("Search Text is required.")
        }
        
        guard let validMaxCalories = Int(maxCalories), validMaxCalories >= 0 else {
            errors.append("Max Calories must be a valid number (0 or greater).")
            return
        }
        
        guard let validSearchCount = Int(searchCount), validSearchCount >= 1 else {
            errors.append("Search Count must be a valid number (1 or greater).")
            return
        }
        
        guard let validTotalResults = Int(totalResults), validTotalResults >= 0 else {
            errors.append("Total Results must be a valid number (0 or greater).")
            return
        }
        
        if errors.isEmpty {
            let newQuery = SearchQuery(
                text: text,
                ingredientFilters: ingredientFilters.split(separator: ",").map { $0.trimmingCharacters(in: .whitespacesAndNewlines) },
                maxCookTime: maxCookTime,
                minRating: minRating,
                maxCalories: validMaxCalories,
                categoryFilter: categoryFilter,
                cuisineFilter: cuisineFilter,
                isVegetarianOnly: isVegetarianOnly,
                isVeganOnly: isVeganOnly,
                includeGlutenFree: includeGlutenFree,
                includeDairyFree: includeDairyFree,
                sortOption: sortOption,
                sortOrder: sortOrder,
                showFavoritesOnly: showFavoritesOnly,
                includeTags: includeTags.split(separator: ",").map { $0.trimmingCharacters(in: .whitespacesAndNewlines) },
                excludeTags: excludeTags.split(separator: ",").map { $0.trimmingCharacters(in: .whitespacesAndNewlines) },
                lastUsed: lastUsed,
                searchCount: validSearchCount,
                totalResults: validTotalResults,
                recentResultTitles: recentResultTitles.split(separator: ",").map { $0.trimmingCharacters(in: .whitespacesAndNewlines) },
                isAdvancedMode: isAdvancedMode,
                timeRangeLabel: maxCookTime < 30 ? "Quick" : "Normal",
                difficultyLevel: difficultyLevel,
                authorFilter: authorFilter,
                regionFilter: regionFilter,
                keywordMatchType: keywordMatchType,
                autoSuggestionsEnabled: autoSuggestionsEnabled,
                lastUsedDevice: lastUsedDevice,
                language: language,
                temperatureUnit: temperatureUnit,
                favoriteOnly: showFavoritesOnly,
                userNote: userNote,
                includeImages: includeImages,
                showQuickRecipes: showQuickRecipes,
                filterGroup: filterGroup,
                cacheKey: cacheKey
            )
            
            dataStore.addSearchQuery(newQuery)
            alertMessage = "✅ Success! Search Query '\(text)' saved."
            showingAlert = true
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                self.presentationMode.wrappedValue.dismiss()
            }
        } else {
            alertMessage = "Please correct the following errors:\n" + errors.joined(separator: "\n")
            showingAlert = true
        }
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.soupBackground.edgesIgnoringSafeArea(.all)
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        
                        SearchQueryAddSectionHeaderView(title: "Core Query", iconName: "magnifyingglass.circle.fill")
                        
                        SearchQueryAddFieldView(title: "Search Text", iconName: "text.magnifyingglass", text: $text, keyboardType: .default)
                        
                        SearchQueryAddFieldView(title: "Max Calories", iconName: "flame.fill", text: $maxCalories, keyboardType: .numberPad)
                        
                        SearchQueryAddRatingView(rating: $minRating)
                        
                        SearchQueryAddStepperFieldView(title: "Max Cook Time", iconName: "timer", value: $maxCookTime, range: 5...120, step: 5)
                        
                        SearchQueryAddFieldView(title: "Author Filter", iconName: "person.crop.circle.fill", text: $authorFilter, keyboardType: .default)
                        
                        SearchQueryAddSectionHeaderView(title: "Classification & Difficulty", iconName: "tag.fill")
                        
                        HStack(spacing: 20) {
                            SearchQueryAddPickerFieldView(title: "Category", iconName: "square.grid.2x2.fill", selection: $categoryFilter, options: categoryOptions)
                            
                            SearchQueryAddPickerFieldView(title: "Cuisine", iconName: "globe", selection: $cuisineFilter, options: cuisineOptions)
                        }
                        
                        HStack(spacing: 20) {
                            SearchQueryAddPickerFieldView(title: "Difficulty", iconName: "chart.bar.fill", selection: $difficultyLevel, options: difficultyOptions)
                            
                            SearchQueryAddPickerFieldView(title: "Region", iconName: "map.fill", selection: $regionFilter, options: cuisineOptions)
                        }
                        
                        SearchQueryAddSectionHeaderView(title: "Dietary Restrictions", iconName: "leaf.fill")
                        
                        VStack(spacing: 10) {
                            SearchQueryAddToggleFieldView(title: "Vegetarian Only", iconName: "carrot.fill", isOn: $isVegetarianOnly)
                            
                            SearchQueryAddToggleFieldView(title: "Vegan Only", iconName: "tree.fill", isOn: $isVeganOnly)
                            
                            SearchQueryAddToggleFieldView(title: "Include Gluten Free", iconName: "figure.wave", isOn: $includeGlutenFree)
                            
                            SearchQueryAddToggleFieldView(title: "Include Dairy Free", iconName: "drop.fill", isOn: $includeDairyFree)
                        }
                        .padding(.horizontal, 10)
                        
                        SearchQueryAddSectionHeaderView(title: "Tags & Ingredients", iconName: "pencil.and.outline")
                        
                        SearchQueryAddFieldView(title: "Ingredients (comma-separated)", iconName: "fork.knife", text: $ingredientFilters, keyboardType: .default)
                        
                        SearchQueryAddFieldView(title: "Include Tags (comma-separated)", iconName: "plus.circle.fill", text: $includeTags, keyboardType: .default)
                        
                        SearchQueryAddFieldView(title: "Exclude Tags (comma-separated)", iconName: "minus.circle.fill", text: $excludeTags, keyboardType: .default)
                        
                        SearchQueryAddSectionHeaderView(title: "Sorting & Display", iconName: "slider.horizontal.3")
                        
                        HStack(spacing: 20) {
                            SearchQueryAddPickerFieldView(title: "Sort By", iconName: "arrow.up.arrow.down.circle.fill", selection: $sortOption, options: sortOptions)
                            
                            SearchQueryAddPickerFieldView(title: "Sort Order", iconName: "list.bullet.indent", selection: $sortOrder, options: sortOrderOptions)
                        }
                        
                        VStack(spacing: 10) {
                            SearchQueryAddToggleFieldView(title: "Show Favorites Only", iconName: "heart.fill", isOn: $showFavoritesOnly)
                            
                            SearchQueryAddToggleFieldView(title: "Quick Recipes", iconName: "bolt.fill", isOn: $showQuickRecipes)
                            
                            SearchQueryAddToggleFieldView(title: "Include Images", iconName: "photo.fill.on.rectangle.fill", isOn: $includeImages)
                            
                            SearchQueryAddToggleFieldView(title: "Advanced Mode", iconName: "switch.2", isOn: $isAdvancedMode)
                            
                            SearchQueryAddToggleFieldView(title: "Auto Suggestions", iconName: "wand.and.stars", isOn: $autoSuggestionsEnabled)
                        }
                        .padding(.horizontal, 10)
                        
                        SearchQueryAddSectionHeaderView(title: "Metadata & Status", iconName: "info.circle.fill")
                        
                        SearchQueryAddFieldView(title: "Search Count", iconName: "number", text: $searchCount, keyboardType: .numberPad)
                        
                        SearchQueryAddFieldView(title: "Total Results (Estimate)", iconName: "sum", text: $totalResults, keyboardType: .numberPad)
                        
                        SearchQueryAddFieldView(title: "Recent Results (comma-separated)", iconName: "doc.text.fill", text: $recentResultTitles, keyboardType: .default)
                        
                        SearchQueryAddFieldView(title: "Keyword Match Type", iconName: "textformat.alt", text: $keywordMatchType, keyboardType: .default)
                        
                        SearchQueryAddFieldView(title: "Last Used Device", iconName: "iphone.homebutton", text: $lastUsedDevice, keyboardType: .default)
                        
                        HStack(spacing: 20) {
                            SearchQueryAddPickerFieldView(title: "Language", iconName: "speaker.wave.2.fill", selection: $language, options: languageOptions)
                            
                            SearchQueryAddPickerFieldView(title: "Temperature Unit", iconName: "thermometer", selection: $temperatureUnit, options: unitOptions)
                        }
                        
                        SearchQueryAddFieldView(title: "User Note", iconName: "note.text", text: $userNote, keyboardType: .default)
                        
                        Button(action: validateAndSave) {
                            Text("Save Search Query")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.soupAccent)
                                .cornerRadius(12)
                                .shadow(color: Color.soupAccent.opacity(0.5), radius: 5, x: 0, y: 5)
                        }
                        .padding(.horizontal, 10)
                        .padding(.vertical, 30)
                    }
                    .padding(.horizontal)
                }
            }
            .navigationTitle("New Search Query")
            .alert(isPresented: $showingAlert) {
                Alert(title: Text("Query Status"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
        }
    }
}

@available(iOS 14.0, *)
struct SearchQuerySearchBarView: View {
    @Binding var searchText: String
    @State private var isEditing: Bool = false
    
    var body: some View {
        HStack {
            TextField("Search queries...", text: $searchText)
                .padding(8)
                .padding(.horizontal, 25)
                .background(Color.soupCard)
                .cornerRadius(8)
                .overlay(
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                            .frame(minWidth: 0, maxWidth: 25, alignment: .leading)
                        
                        if isEditing {
                            Button(action: {
                                self.searchText = ""
                            }) {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.gray)
                                    .padding(.trailing, 8)
                            }
                        }
                    }
                )
                .onTapGesture {
                    self.isEditing = true
                }
            
            if isEditing {
                Button(action: {
                    self.isEditing = false
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                }) {
                    Text("Cancel")
                }
                .padding(.trailing, 10)
                .transition(.move(edge: .trailing))
            }
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 8)
        .background(Color.soupBackground)
        .animation(.default, value: isEditing)
    }
}

@available(iOS 14.0, *)
struct SearchQueryListRowView: View {
    let query: SearchQuery
    
    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            
            // MARK: - Header Section
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 6) {
                    Text(query.text)
                        .font(.system(.title3, design: .rounded))
                        .fontWeight(.bold)
                        .foregroundColor(.soupPrimary)
                        .lineLimit(1)
                    
                    HStack(spacing: 8) {
                        SearchQueryIconLabel(iconName: "flame.fill", text: "\(query.maxCalories) Cal Max", color: .orange)
                        SearchQueryIconLabel(iconName: "clock.fill", text: "\(query.maxCookTime ?? 0) Min", color: .green)
                        SearchQueryIconLabel(iconName: "star.fill", text: String(format: "%.1f+", query.minRating), color: .yellow)
                    }
                }
                
                Spacer()
                
                VStack(spacing: 5) {
                    Image(systemName: query.showFavoritesOnly ? "heart.fill" : "heart")
                        .foregroundColor(query.showFavoritesOnly ? .red : .gray)
                        .font(.title3)
                    
                    Text("x\(query.searchCount)")
                        .font(.caption2)
                        .fontWeight(.bold)
                        .padding(6)
                        .background(Color.soupAccent.opacity(0.9))
                        .foregroundColor(.white)
                        .clipShape(Circle())
                }
            }
            
            Divider()
            
            // MARK: - Filter Info
            VStack(alignment: .leading, spacing: 8) {
                HStack(spacing: 15) {
                    SearchQueryIconLabel(iconName: "tag.fill", text: "Category: \(query.categoryFilter)", color: .purple)
                    SearchQueryIconLabel(iconName: "globe", text: "Cuisine: \(query.cuisineFilter)", color: .blue)
                    SearchQueryIconLabel(iconName: "list.number", text: "Level: \(query.difficultyLevel)", color: .gray)
                }
                
                HStack(spacing: 15) {
                    SearchQueryIconLabel(iconName: query.isVegetarianOnly ? "leaf.fill" : "leaf", text: query.isVegetarianOnly ? "Vegetarian" : "All Diets", color: query.isVegetarianOnly ? .green : .gray)
                    SearchQueryIconLabel(iconName: query.isVeganOnly ? "leaf.circle.fill" : "leaf.circle", text: query.isVeganOnly ? "Vegan" : "Non-Vegan", color: query.isVeganOnly ? .green : .gray)
                    SearchQueryIconLabel(iconName: "figure.wave", text: "GF: \(query.includeGlutenFree ? "Yes" : "No")", color: .orange)
                    SearchQueryIconLabel(iconName: "drop.triangle.fill", text: "DF: \(query.includeDairyFree ? "Yes" : "No")", color: .blue)
                }
                
                HStack(spacing: 15) {
                    SearchQueryIconLabel(iconName: "arrow.up.arrow.down.circle.fill", text: "\(query.sortOption) (\(query.sortOrder.prefix(4)))", color: .pink)
                    SearchQueryIconLabel(iconName: "bolt.horizontal.circle.fill", text: query.isAdvancedMode ? "Advanced" : "Simple", color: query.isAdvancedMode ? .orange : .gray)
                    SearchQueryIconLabel(iconName: "hare.fill", text: query.showQuickRecipes ? "Quick" : "All Recipes", color: .green)
                }
            }
            
            Divider()
            
            VStack(alignment: .leading, spacing: 6) {
                HStack(spacing: 15) {
                    SearchQueryIconLabel(iconName: "person.fill", text: "Author: \(query.authorFilter)", color: .purple)
                    SearchQueryIconLabel(iconName: "mappin.and.ellipse", text: "Region: \(query.regionFilter)", color: .red)
                    SearchQueryIconLabel(iconName: "character.book.closed.fill", text: "Lang: \(query.language)", color: .blue)
                }
                
                HStack(spacing: 15) {
                    SearchQueryIconLabel(iconName: "laptopcomputer", text: query.lastUsedDevice, color: .gray)
                    SearchQueryIconLabel(iconName: "thermometer.sun.fill", text: query.temperatureUnit, color: .orange)
                    SearchQueryIconLabel(iconName: "folder.fill.badge.person.crop", text: "Group: \(query.filterGroup)", color: .pink)
                }
            }
            
            Divider()
            
            // MARK: - Tags Section
            VStack(alignment: .leading, spacing: 4) {
                if !query.ingredientFilters.isEmpty {
                    Text("Ingredients: \(query.ingredientFilters.joined(separator: ", "))")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                if !query.includeTags.isEmpty {
                    Text("Include Tags: \(query.includeTags.joined(separator: ", "))")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                if !query.excludeTags.isEmpty {
                    Text("Exclude Tags: \(query.excludeTags.joined(separator: ", "))")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            Divider()
            
            // MARK: - Meta Section
            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    SearchQueryIconLabel(iconName: "calendar.badge.clock", text: "Saved: \(dateFormatter.string(from: query.savedAt))", color: .gray)
                    
                    if let lastUsed = query.lastUsed {
                        SearchQueryIconLabel(iconName: "clock.arrow.circlepath", text: "Last Used: \(dateFormatter.string(from: lastUsed))", color: .gray)
                    }
                }
                
                HStack {
                    SearchQueryIconLabel(iconName: "text.magnifyingglass", text: "Keyword: \(query.keywordMatchType)", color: .purple)
                    SearchQueryIconLabel(iconName: "key.horizontal.fill", text: "Cache: \(query.cacheKey.prefix(8))...", color: .gray)
                }
            }
            
            Divider()
            
            // MARK: - User Notes & Results
            if !query.userNote.isEmpty {
                Label("Note: \(query.userNote)", systemImage: "note.text")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            if !query.recentResultTitles.isEmpty {
                Text("Recent Results: \(query.recentResultTitles.prefix(3).joined(separator: ", "))")
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
            
            // MARK: - Summary Footer
            HStack {
                Label("Results: \(query.totalResults)", systemImage: "doc.text.magnifyingglass")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Spacer()
                
                Label("Device: \(query.lastUsedDevice)", systemImage: "iphone")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding(15)
        .background(Color.soupCard)
        .cornerRadius(15)
        .shadow(color: Color.black.opacity(0.12), radius: 6, x: 0, y: 3)
    }
    
    // MARK: - Helpers
    private var dateFormatter: DateFormatter {
        let df = DateFormatter()
        df.dateStyle = .short
        df.timeStyle = .none
        return df
    }
}

@available(iOS 14.0, *)
struct SearchQueryNoDataView: View {
    var body: some View {
        VStack(spacing: 15) {
            Image(systemName: "questionmark.folder.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 80, height: 80)
                .foregroundColor(.soupAccent)
                .opacity(0.6)
            
            Text("No Search Queries Found")
                .font(.headline)
                .foregroundColor(.primary)
            
            Text("Tap the '+' to create your first search query and start filtering recipes!")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
        }
        .padding(.vertical, 50)
    }
}

@available(iOS 14.0, *)
struct SearchQueryListView: View {
    @ObservedObject var dataStore: SoupDataStore
    @State private var showingAddView = false
    @State private var searchText = ""
    
    var filteredQueries: [SearchQuery] {
        if searchText.isEmpty {
            return dataStore.searchQueries
        } else {
            return dataStore.searchQueries.filter { query in
                query.text.localizedCaseInsensitiveContains(searchText) ||
                query.categoryFilter.localizedCaseInsensitiveContains(searchText) ||
                query.cuisineFilter.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    var body: some View {
            VStack {
                SearchQuerySearchBarView(searchText: $searchText)
                
                if filteredQueries.isEmpty {
                    SearchQueryNoDataView()
                    Spacer()
                } else {
                    List {
                        ForEach(filteredQueries) { query in
                            ZStack {
                                NavigationLink(destination: SearchQueryDetailView(query: query)) {
                                    EmptyView()
                                }
                                .opacity(0)
                                
                                SearchQueryListRowView(query: query)
                            }
                            .padding(.vertical, 5)
                            .listRowInsets(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
                            .listRowBackground(Color.soupBackground)
                        }
                        .onDelete(perform: deleteQuery)
                    }
                    .listStyle(PlainListStyle())
                }
            }
            .background(Color.soupBackground.edgesIgnoringSafeArea(.all))
            .navigationTitle("Saved Queries")
            .navigationBarItems(trailing:
                Button(action: {
                    self.showingAddView = true
                }) {
                    Image(systemName: "plus.circle.fill")
                        .font(.title2)
                        .foregroundColor(.soupAccent)
                }
            )
            .sheet(isPresented: $showingAddView) {
                SearchQueryAddView(dataStore: dataStore)
            }
    
    }
    
    private func deleteQuery(at offsets: IndexSet) {
        guard let firstIndex = offsets.first else { return }
        let queryToDelete = filteredQueries[firstIndex]
        
        if let originalIndex = dataStore.searchQueries.firstIndex(where: { $0.id == queryToDelete.id }) {
            dataStore.deleteSearchQuery(at: IndexSet(integer: originalIndex))
        }
    }
}

@available(iOS 14.0, *)
struct SearchQueryDetailFieldRow: View {
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
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            Spacer()
            
            Text(value)
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundColor(.primary)
                .lineLimit(1)
        }
        .padding(.vertical, 5)
    }
}

@available(iOS 14.0, *)
struct SearchQueryDetailBooleanRow: View {
    let label: String
    let isOn: Bool
    let iconName: String
    
    var body: some View {
        HStack {
            Image(systemName: iconName)
                .foregroundColor(isOn ? .green : .red)
                .frame(width: 20)
            
            Text(label)
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            Spacer()
            
            Text(isOn ? "Enabled" : "Disabled")
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundColor(isOn ? .green : .red)
        }
        .padding(.vertical, 5)
    }
}

@available(iOS 14.0, *)
struct SearchQueryDetailRatingDisplay: View {
    let rating: Double
    
    var body: some View {
        HStack(spacing: 5) {
            ForEach(0..<5) { index in
                Image(systemName: index < Int(rating) ? "star.fill" : "star")
                    .foregroundColor(.yellow)
            }
            Text(String(format: "%.1f", rating))
                .font(.headline)
                .foregroundColor(.primary)
        }
    }
}

@available(iOS 14.0, *)
struct SearchQueryDetailView: View {
    let query: SearchQuery
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 25) {
                
                VStack(alignment: .leading, spacing: 5) {
                    Text("Search Query Details")
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundColor(.soupAccent)
                    
                    Text(query.text)
                        .font(.largeTitle)
                        .fontWeight(.heavy)
                        .foregroundColor(.soupPrimary)
                    
                    SearchQueryDetailRatingDisplay(rating: query.minRating)
                }
                .padding(.horizontal)
                
                VStack(alignment: .leading, spacing: 15) {
                    Text("Core Parameters")
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    VStack(spacing: 10) {
                        SearchQueryDetailFieldRow(label: "Category Filter", value: query.categoryFilter, iconName: "square.grid.2x2.fill", color: .blue)
                        SearchQueryDetailFieldRow(label: "Cuisine Filter", value: query.cuisineFilter, iconName: "globe", color: .green)
                        SearchQueryDetailFieldRow(label: "Difficulty Level", value: query.difficultyLevel, iconName: "chart.bar.fill", color: .purple)
                        SearchQueryDetailFieldRow(label: "Region Filter", value: query.regionFilter, iconName: "map.fill", color: .yellow)
                        SearchQueryDetailFieldRow(label: "Author Filter", value: query.authorFilter.isEmpty ? "Any" : query.authorFilter, iconName: "person.crop.circle.fill", color: .gray)
                    }
                    .padding(15)
                    .background(Color.soupCard)
                    .cornerRadius(12)
                    .shadow(color: Color.black.opacity(0.08), radius: 3, x: 0, y: 1)
                }
                .padding(.horizontal)
                
                VStack(alignment: .leading, spacing: 15) {
                    Text("Limits & Constraints")
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    VStack(spacing: 10) {
                        SearchQueryDetailFieldRow(label: "Max Cook Time", value: "\(query.maxCookTime ?? 0) min", iconName: "timer", color: .orange)
                        SearchQueryDetailFieldRow(label: "Max Calories", value: "\(query.maxCalories)", iconName: "flame.fill", color: .red)
                        SearchQueryDetailFieldRow(label: "Time Range Label", value: query.timeRangeLabel, iconName: "speedometer", color: .green)
                    }
                    .padding(15)
                    .background(Color.soupCard)
                    .cornerRadius(12)
                    .shadow(color: Color.black.opacity(0.08), radius: 3, x: 0, y: 1)
                }
                .padding(.horizontal)
                
                VStack(alignment: .leading, spacing: 15) {
                    Text("Dietary Filters")
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    VStack(spacing: 10) {
                        SearchQueryDetailBooleanRow(label: "Vegetarian Only", isOn: query.isVegetarianOnly, iconName: "leaf.fill")
                        SearchQueryDetailBooleanRow(label: "Vegan Only", isOn: query.isVeganOnly, iconName: "tree.fill")
                        SearchQueryDetailBooleanRow(label: "Include Gluten Free", isOn: query.includeGlutenFree, iconName: "figure.wave")
                        SearchQueryDetailBooleanRow(label: "Include Dairy Free", isOn: query.includeDairyFree, iconName: "drop.fill")
                    }
                    .padding(15)
                    .background(Color.soupCard)
                    .cornerRadius(12)
                    .shadow(color: Color.black.opacity(0.08), radius: 3, x: 0, y: 1)
                }
                .padding(.horizontal)
                
                VStack(alignment: .leading, spacing: 15) {
                    Text("Tag & Ingredient Filters")
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    VStack(spacing: 10) {
                        SearchQueryDetailFieldRow(label: "Ingredients", value: query.ingredientFilters.joined(separator: ", ").isEmpty ? "None" : query.ingredientFilters.joined(separator: ", "), iconName: "fork.knife", color: .orange)
                        SearchQueryDetailFieldRow(label: "Include Tags", value: query.includeTags.joined(separator: ", ").isEmpty ? "None" : query.includeTags.joined(separator: ", "), iconName: "plus.circle.fill", color: .blue)
                        SearchQueryDetailFieldRow(label: "Exclude Tags", value: query.excludeTags.joined(separator: ", ").isEmpty ? "None" : query.excludeTags.joined(separator: ", "), iconName: "minus.circle.fill", color: .red)
                    }
                    .padding(15)
                    .background(Color.soupCard)
                    .cornerRadius(12)
                    .shadow(color: Color.black.opacity(0.08), radius: 3, x: 0, y: 1)
                }
                .padding(.horizontal)
                
                VStack(alignment: .leading, spacing: 15) {
                    Text("Sorting & Advanced Options")
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    VStack(spacing: 10) {
                        SearchQueryDetailFieldRow(label: "Sort By", value: query.sortOption, iconName: "arrow.up.arrow.down.circle.fill", color: .pink)
                        SearchQueryDetailFieldRow(label: "Sort Order", value: query.sortOrder, iconName: "list.bullet.indent", color: .pink.opacity(0.7))
                        SearchQueryDetailBooleanRow(label: "Advanced Mode", isOn: query.isAdvancedMode, iconName: "switch.2")
                        SearchQueryDetailFieldRow(label: "Keyword Match Type", value: query.keywordMatchType, iconName: "textformat.alt", color: .secondary)
                        SearchQueryDetailBooleanRow(label: "Auto Suggestions", isOn: query.autoSuggestionsEnabled, iconName: "wand.and.stars")
                        SearchQueryDetailBooleanRow(label: "Show Favorites Only", isOn: query.showFavoritesOnly, iconName: "heart.fill")
                        SearchQueryDetailBooleanRow(label: "Show Quick Recipes", isOn: query.showQuickRecipes, iconName: "bolt.fill")
                        SearchQueryDetailBooleanRow(label: "Include Images", isOn: query.includeImages, iconName: "photo.fill.on.rectangle.fill")
                    }
                    .padding(15)
                    .background(Color.soupCard)
                    .cornerRadius(12)
                    .shadow(color: Color.black.opacity(0.08), radius: 3, x: 0, y: 1)
                }
                .padding(.horizontal)
                
                VStack(alignment: .leading, spacing: 15) {
                    Text("Usage Statistics")
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    VStack(spacing: 10) {
                        SearchQueryDetailFieldRow(label: "Search Count", value: "\(query.searchCount)", iconName: "number.circle.fill", color: .secondary)
                        SearchQueryDetailFieldRow(label: "Total Results", value: "\(query.totalResults)", iconName: "sum", color: .secondary)
                        SearchQueryDetailFieldRow(label: "Recent Results", value: query.recentResultTitles.joined(separator: ", ").isEmpty ? "None" : query.recentResultTitles.joined(separator: ", "), iconName: "doc.text.fill", color: .secondary)
                        SearchQueryDetailFieldRow(label: "Last Used Device", value: query.lastUsedDevice, iconName: "iphone.homebutton", color: .secondary)
                        SearchQueryDetailFieldRow(label: "Language", value: query.language, iconName: "speaker.wave.2.fill", color: .secondary)
                        SearchQueryDetailFieldRow(label: "Temperature Unit", value: query.temperatureUnit, iconName: "thermometer", color: .secondary)
                        SearchQueryDetailFieldRow(label: "Saved At", value: DateFormatter.customShort.string(from: query.savedAt), iconName: "calendar", color: .secondary)
                        SearchQueryDetailFieldRow(label: "Cache Key", value: query.cacheKey, iconName: "key.fill", color: .secondary)
                        SearchQueryDetailFieldRow(label: "Filter Group", value: query.filterGroup, iconName: "folder.fill", color: .secondary)
                    }
                    .padding(15)
                    .background(Color.soupCard)
                    .cornerRadius(12)
                    .shadow(color: Color.black.opacity(0.08), radius: 3, x: 0, y: 1)
                }
                .padding(.horizontal)
                
                if !query.userNote.isEmpty {
                    VStack(alignment: .leading, spacing: 15) {
                        Text("User Note")
                            .font(.headline)
                            .foregroundColor(.primary)
                        
                        Text(query.userNote)
                            .font(.body)
                            .foregroundColor(.secondary)
                            .padding(15)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color.soupCard)
                            .cornerRadius(12)
                            .shadow(color: Color.black.opacity(0.08), radius: 3, x: 0, y: 1)
                    }
                    .padding(.horizontal)
                }
            }
            .padding(.vertical)
        }
        .background(Color.soupBackground.edgesIgnoringSafeArea(.all))
        .navigationTitle("Query: \(query.text)")
        .navigationBarTitleDisplayMode(.inline)
    }
}
