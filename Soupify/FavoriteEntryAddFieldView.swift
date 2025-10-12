import SwiftUI
import Combine

extension Date {

    func formattedDateTime() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter.string(from: self)
    }
}

@available(iOS 14.0, *)
struct FavoriteEntryAddFieldView: View {
    let title: String
    let iconName: String
    @Binding var text: String
    let keyboardType: UIKeyboardType
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Image(systemName: iconName)
                    .foregroundColor(.blue)
                Text(title)
                    .font(.caption)
                    .fontWeight(.bold)
            }
            .padding(.horizontal, 4)
            
            TextField("", text: $text)
                .keyboardType(keyboardType)
                .padding(.vertical, 10)
                .padding(.horizontal, 15)
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                )
        }
    }
}

@available(iOS 14.0, *)
struct FavoriteEntryAddDatePickerView: View {
    let title: String
    let iconName: String
    @Binding var date: Date
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Image(systemName: iconName)
                    .foregroundColor(.purple)
                Text(title)
                    .font(.caption)
                    .fontWeight(.bold)
            }
            .padding(.horizontal, 4)
            
            DatePicker("", selection: $date, displayedComponents: .date)
                .labelsHidden()
                .padding(.vertical, 5)
                .padding(.horizontal, 15)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                )
        }
    }
}

@available(iOS 14.0, *)
struct FavoriteEntryAddToggleView: View {
    let title: String
    let iconName: String
    @Binding var isOn: Bool
    
    var body: some View {
        HStack {
            
            Text(title)
            
            Spacer()
            
            Toggle("", isOn: $isOn)
                .labelsHidden()
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 15)
        .background(Color(.systemGray6))
        .cornerRadius(10)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
        )
    }
}

@available(iOS 14.0, *)
struct FavoriteEntryAddSectionHeaderView: View {
    let title: String
    let iconName: String
    let color: Color
    
    var body: some View {
        HStack {
            Image(systemName: iconName)
                .font(.headline)
                .foregroundColor(color)
            Text(title)
                .font(.headline)
                .fontWeight(.heavy)
                .foregroundColor(color)
        }
        .padding(.top, 15)
        .padding(.bottom, 5)
    }
}

@available(iOS 14.0, *)
struct FavoriteEntrySearchBarView: View {
    @Binding var searchText: String
    @State private var isEditing = false
    
    var body: some View {
        HStack {
            TextField("Search Favorites...", text: $searchText)
                .padding(7)
                .padding(.horizontal, isEditing ? 30 : 25)
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .overlay(
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                            .padding(.leading, 8)
                        
                        Spacer()
                        
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
                    self.searchText = ""
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                }) {
                    Text("Cancel")
                }
                .transition(.move(edge: .trailing))
            }
        }
        .padding(.horizontal)
    }
}

@available(iOS 14.0, *)
struct FavoriteEntryNoDataView: View {
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "heart.slash.fill")
                .font(.system(size: 80))
                .foregroundColor(.red)
                .opacity(0.6)
            
            Text("No Favorites Found")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.primary)
            
            Text("It looks like you haven't added any favorite recipes yet. Tap the '+' button to add your first entry!")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
        }
        .padding(.top, 50)
    }
}

@available(iOS 14.0, *)
struct FavoriteEntryDetailFieldRow: View {
    let label: String
    let value: String
    let iconName: String
    let color: Color
    
    var body: some View {
        HStack(alignment: .top) {
            Image(systemName: iconName)
                .foregroundColor(color)
                .frame(width: 25)
                .padding(.top, 3)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(label)
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(.gray)
                Text(value)
                    .font(.callout)
                    .foregroundColor(.primary)
            }
            .padding(.leading, 5)
            
            Spacer()
        }
        .padding(.vertical, 5)
    }
}

@available(iOS 14.0, *)
struct FavoriteEntryAddView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var dataStore: SoupDataStore
    
    @State private var recipeId: String = UUID().uuidString
    @State private var note: String = ""
    @State private var rating: Double = 3.0
    @State private var timesCooked: String = "1"
    @State private var customLabel: String = ""
    @State private var moodTag: String = ""
    @State private var sharedWithFriends: Bool = false
    @State private var bookmarkedAt: Date = Date()
    @State private var imagePreview: String = "placeholder"
    @State private var lastCooked: Date = Date()
    @State private var category: String = "Dinner"
    @State private var cuisine: String = "International"
    @State private var isWeeklyFavorite: Bool = false
    @State private var isSeasonalPick: Bool = false
    @State private var isHealthyChoice: Bool = false
    @State private var author: String = ""
    @State private var preparationTips: String = ""
    @State private var nutritionSummary: String = ""
    @State private var cookCount: String = "1"
    @State private var lastModified: Date = Date()
    @State private var recipeName: String = ""
    @State private var spiceLevel: String = "Medium"
    @State private var flavorProfile: String = "Balanced"
    @State private var favoriteReason: String = ""
    @State private var difficultyLevel: String = "Moderate"
    @State private var prepTime: String = "15"
    @State private var cookTime: String = "30"
    @State private var totalTime: String = "45"
    @State private var ratingOutOfFive: Int = 3
    @State private var locationAdded: String = "Home"
    @State private var source: String = "Website"
    @State private var backupStatus: String = "Pending"
    @State private var reviewText: String = ""
    @State private var sharedDate: Date = Date()
    @State private var moodWhenCooked: String = "Neutral"
    
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    private func validateAndSave() {
        var errors: [String] = []
        
        if recipeName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            errors.append("Recipe Name is required.")
        }
        if customLabel.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            errors.append("Custom Label is required.")
        }
        if author.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            errors.append("Author is required.")
        }
        if favoriteReason.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            errors.append("Favorite Reason is required.")
        }
        if category.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            errors.append("Category is required.")
        }
        if cuisine.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            errors.append("Cuisine is required.")
        }
        if difficultyLevel.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            errors.append("Difficulty Level is required.")
        }
        if spiceLevel.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            errors.append("Spice Level is required.")
        }
        if flavorProfile.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            errors.append("Flavor Profile is required.")
        }
        if locationAdded.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            errors.append("Location Added is required.")
        }
        if source.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            errors.append("Source is required.")
        }
        
        if Int(timesCooked) == nil || Int(timesCooked)! < 0 {
            errors.append("Times Cooked must be a non-negative number.")
        }
        if Int(cookCount) == nil || Int(cookCount)! < 0 {
            errors.append("Cook Count must be a non-negative number.")
        }
        if Int(prepTime) == nil || Int(prepTime)! < 0 {
            errors.append("Prep Time must be a non-negative number.")
        }
        if Int(cookTime) == nil || Int(cookTime)! < 0 {
            errors.append("Cook Time must be a non-negative number.")
        }
        if Int(totalTime) == nil || Int(totalTime)! < 0 {
            errors.append("Total Time must be a non-negative number.")
        }
        
        if errors.isEmpty {
            let newEntry = FavoriteEntry(
                recipeId: UUID(),
                note: note,
                rating: rating,
                timesCooked: Int(timesCooked) ?? 0,
                customLabel: customLabel,
                moodTag: moodTag,
                sharedWithFriends: sharedWithFriends,
                bookmarkedAt: bookmarkedAt,
                imagePreview: imagePreview,
                lastCooked: lastCooked,
                category: category,
                cuisine: cuisine,
                isWeeklyFavorite: isWeeklyFavorite,
                isSeasonalPick: isSeasonalPick,
                isHealthyChoice: isHealthyChoice,
                author: author,
                preparationTips: preparationTips,
                nutritionSummary: nutritionSummary,
                cookCount: Int(cookCount) ?? 0,
                lastModified: Date(),
                recipeName: recipeName,
                spiceLevel: spiceLevel,
                flavorProfile: flavorProfile,
                favoriteReason: favoriteReason,
                difficultyLevel: difficultyLevel,
                prepTime: Int(prepTime) ?? 0,
                cookTime: Int(cookTime) ?? 0,
                totalTime: Int(totalTime) ?? 0,
                ratingOutOfFive: ratingOutOfFive,
                locationAdded: locationAdded,
                source: source,
                backupStatus: backupStatus,
                reviewText: reviewText,
                sharedDate: sharedDate,
                moodWhenCooked: moodWhenCooked
            )
            dataStore.addFavorite(newEntry)
            
            alertMessage = "Success!\n\n'\(recipeName)' has been added to your favorites."
            showAlert = true
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                presentationMode.wrappedValue.dismiss()
            }
            
        } else {
            alertMessage = "Please correct the following errors:\n\n• " + errors.joined(separator: "\n• ")
            showAlert = true
        }
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 25) {
                    
                    FavoriteEntryAddSectionHeaderView(title: "Recipe Details", iconName: "fork.knife.circle.fill", color: .orange)
                    
                    HStack(spacing: 15) {
                        FavoriteEntryAddFieldView(title: "Recipe Name*", iconName: "heart.text.square.fill", text: $recipeName, keyboardType: .default)
                        
                        FavoriteEntryAddFieldView(title: "Author*", iconName: "person.crop.circle.fill", text: $author, keyboardType: .default)
                    }
                    
                    HStack(spacing: 15) {
                        FavoriteEntryAddFieldView(title: "Category*", iconName: "square.grid.2x2.fill", text: $category, keyboardType: .default)
                        
                        FavoriteEntryAddFieldView(title: "Cuisine*", iconName: "map.fill", text: $cuisine, keyboardType: .default)
                    }
                    
                    HStack(spacing: 15) {
                        FavoriteEntryAddFieldView(title: "Difficulty*", iconName: "gauge.medium", text: $difficultyLevel, keyboardType: .default)
                        
                        FavoriteEntryAddFieldView(title: "Flavor Profile*", iconName: "waveform.path.ecg", text: $flavorProfile, keyboardType: .default)
                    }
                    
                    FavoriteEntryAddFieldView(title: "Favorite Reason*", iconName: "trophy.fill", text: $favoriteReason, keyboardType: .default)
                    
                    FavoriteEntryAddSectionHeaderView(title: "Timing & History", iconName: "clock.fill", color: .blue)
                    
                    HStack(spacing: 15) {
                        FavoriteEntryAddFieldView(title: "Prep Time (min)*", iconName: "timer.square.fill", text: $prepTime, keyboardType: .numberPad)
                        
                        FavoriteEntryAddFieldView(title: "Cook Time (min)*", iconName: "flame.fill", text: $cookTime, keyboardType: .numberPad)
                        
                        FavoriteEntryAddFieldView(title: "Total Time (min)*", iconName: "hourglass.split", text: $totalTime, keyboardType: .numberPad)
                    }
                    
                    HStack(spacing: 15) {
                        FavoriteEntryAddFieldView(title: "Times Cooked*", iconName: "repeat.circle.fill", text: $timesCooked, keyboardType: .numberPad)
                        
                        FavoriteEntryAddFieldView(title: "Cook Count*", iconName: "number.square.fill", text: $cookCount, keyboardType: .numberPad)
                    }
                    
                    FavoriteEntryAddDatePickerView(title: "Last Cooked Date", iconName: "calendar.badge.clock", date: $lastCooked)
                    
                    FavoriteEntryAddSectionHeaderView(title: "Personalization & Context", iconName: "star.bubble.fill", color: .green)
                    
                    HStack(spacing: 15) {
                        FavoriteEntryAddFieldView(title: "Custom Label*", iconName: "tag.fill", text: $customLabel, keyboardType: .default)
                        
                        FavoriteEntryAddFieldView(title: "Mood Tag", iconName: "face.smiling.fill", text: $moodTag, keyboardType: .default)
                    }
                    
                    HStack(spacing: 15) {
                        FavoriteEntryAddFieldView(title: "Spice Level*", iconName: "cloud.drizzle.fill", text: $spiceLevel, keyboardType: .default)
                        
                        FavoriteEntryAddFieldView(title: "Mood When Cooked", iconName: "face.smiling", text: $moodWhenCooked, keyboardType: .default)
                    }
                    
                    FavoriteEntryAddFieldView(title: "Location Added*", iconName: "house.fill", text: $locationAdded, keyboardType: .default)
                    
                    VStack(alignment: .leading) {
                        Text("Personal Rating (\(String(format: "%.1f", rating)) / 5.0)")
                            .font(.caption)
                            .fontWeight(.bold)
                            .padding(.leading, 5)
                            .foregroundColor(.secondary)
                        
                        Slider(value: $rating, in: 0...5, step: 0.1)
                            .accentColor(.yellow)
                    }
                    .padding(.horizontal)
                    
                    Picker("Rating (1-5)", selection: $ratingOutOfFive) {
                        ForEach(1...5, id: \.self) {
                            Text("\($0)")
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding(.horizontal)
                    
                    FavoriteEntryAddSectionHeaderView(title: "Notes & Status", iconName: "note.text", color: .red)
                    
                    FavoriteEntryAddFieldView(title: "Source*", iconName: "link", text: $source, keyboardType: .default)
                    FavoriteEntryAddFieldView(title: "Backup Status", iconName: "icloud.fill", text: $backupStatus, keyboardType: .default)
                    FavoriteEntryAddFieldView(title: "Nutrition Summary", iconName: "cross.case.fill", text: $nutritionSummary, keyboardType: .default)
                    FavoriteEntryAddFieldView(title: "Preparation Tips", iconName: "lightbulb.fill", text: $preparationTips, keyboardType: .default)
                    FavoriteEntryAddFieldView(title: "Review Text", iconName: "quote.bubble.fill", text: $reviewText, keyboardType: .default)
                    FavoriteEntryAddFieldView(title: "Note", iconName: "pencil", text: $note, keyboardType: .default)
                    
                    FavoriteEntryAddSectionHeaderView(title: "Boolean Flags", iconName: "checkmark.seal.fill", color: .green)
                    
                    VStack(spacing: 15) {
                        FavoriteEntryAddToggleView(title: "Weekly Favorite", iconName: "star.fill", isOn: $isWeeklyFavorite)
                        FavoriteEntryAddToggleView(title: "Seasonal Pick", iconName: "leaf.fill", isOn: $isSeasonalPick)
                        FavoriteEntryAddToggleView(title: "Healthy Choice", iconName: "heart.circle.fill", isOn: $isHealthyChoice)
                        FavoriteEntryAddToggleView(title: "Shared with Friends", iconName: "share.sheet.fill", isOn: $sharedWithFriends)
                    }
                    .padding(.horizontal)
                    
                    FavoriteEntryAddSectionHeaderView(title: "Dates", iconName: "calendar", color: .pink)
                    FavoriteEntryAddDatePickerView(title: "Bookmarked At", iconName: "bookmark.fill", date: $bookmarkedAt)
                    FavoriteEntryAddDatePickerView(title: "Shared Date", iconName: "person.2.fill", date: $sharedDate)
                    
                    Button(action: validateAndSave) {
                        Text("Save Favorite Entry")
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.pink)
                            .cornerRadius(15)
                            .shadow(color: Color.pink.opacity(0.5), radius: 10, x: 0, y: 5)
                    }
                    .padding(.horizontal)
                    .padding(.top, 20)
                    .padding(.bottom, 50)
                }
                .padding(.horizontal)
            }
            .navigationTitle("New Favorite Recipe")
            .alert(isPresented: $showAlert) {
                Alert(title: Text(alertMessage.contains("Success") ? "Saved!" : "Validation Error"),
                      message: Text(alertMessage),
                      dismissButton: .default(Text("OK")) {
                        if alertMessage.contains("Success") {
                            presentationMode.wrappedValue.dismiss()
                        }
                      }
                )
            }
        }
    }
}

@available(iOS 14.0, *)
struct FavoriteEntryListRowView: View {
    let entry: FavoriteEntry
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            
            // MARK: Header
            HStack(alignment: .top) {
                Image(systemName: "heart.circle.fill")
                    .resizable()
                    .frame(width: 34, height: 34)
                    .foregroundColor(.red)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(entry.recipeName)
                        .font(.system(.headline, design: .rounded))
                        .fontWeight(.bold)
                        .lineLimit(1)
                    
                    Text(entry.customLabel)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .lineLimit(1)
                    
                    Text("Category: \(entry.category)")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 3) {
                    HStack(spacing: 2) {
                        ForEach(0..<entry.ratingOutOfFive, id: \.self) { _ in
                            Image(systemName: "star.fill")
                                .foregroundColor(.yellow)
                                .font(.caption)
                        }
                        Text("(\(String(format: "%.1f", entry.rating)))")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    
                    Text(entry.difficultyLevel)
                        .font(.caption2)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 3)
                        .background(Color.blue.opacity(0.1))
                        .cornerRadius(5)
                    
                    Text(entry.flavorProfile)
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
            }
            
            Divider()
            
            // MARK: Main Stats
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 5) {
                    GridStat(icon: "clock.fill", label: "Total Time", value: "\(entry.totalTime) min", color: .orange)
                    GridStat(icon: "timer", label: "Prep", value: "\(entry.prepTime) min", color: .gray)
                    GridStat(icon: "flame.fill", label: "Cook", value: "\(entry.cookTime) min", color: .red)
                    GridStat(icon: "fork.knife", label: "Cuisine", value: entry.cuisine, color: .purple)
                    GridStat(icon: "repeat", label: "Cooked", value: "\(entry.timesCooked)×", color: .blue)
                    GridStat(icon: "face.smiling.fill", label: "Mood", value: entry.moodTag, color: .pink)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                VStack(alignment: .leading, spacing: 5) {
                    GridStat(icon: "person.fill", label: "Author", value: entry.author, color: .red)
                    GridStat(icon: "thermometer", label: "Spice", value: entry.spiceLevel, color: .purple)
                    GridStat(icon: "heart.fill", label: "Reason", value: entry.favoriteReason, color: .orange)
                    GridStat(icon: "map.fill", label: "Location", value: entry.locationAdded, color: .green)
                    GridStat(icon: "doc.text.fill", label: "Source", value: entry.source, color: .gray)
                    GridStat(icon: "cpu", label: "Backup", value: entry.backupStatus, color: .red)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            
            Divider()
            
            // MARK: - Status Pills
            HStack(spacing: 8) {
                if entry.isWeeklyFavorite {
                    FlagPill(text: "Weekly Fave", color: .yellow)
                }
                if entry.isHealthyChoice {
                    FlagPill(text: "Healthy", color: .green)
                }
                if entry.isSeasonalPick {
                    FlagPill(text: "Seasonal", color: .blue)
                }
                if entry.sharedWithFriends {
                    FlagPill(text: "Shared", color: .orange)
                }
                if entry.nutritionSummary.contains("Low fat") {
                    FlagPill(text: "Low Fat", color: .blue)
                }
            }
            
            Divider()
            
            // MARK: - MetaInfo
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Image(systemName: "calendar.badge.clock")
                        .foregroundColor(.gray)
                    Text("Added: \(entry.bookmarkedAt?.formattedDate() ?? "N/A")")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Spacer()
                    if let lastCooked = entry.lastCooked {
                        Text("Last Cooked: \(lastCooked.formattedDate())")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                
                if let sharedDate = entry.sharedDate {
                    Label("Shared On: \(sharedDate.formattedDate())", systemImage: "person.2.fill")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                if let lastModified = entry.lastModified {
                    Label("Modified: \(lastModified.formattedDate())", systemImage: "pencil")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            Divider()
            
            // MARK: - Notes & Tips
            if !entry.preparationTips.isEmpty {
                Label("Tips: \(entry.preparationTips)", systemImage: "lightbulb.fill")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            if let note = entry.note, !note.isEmpty {
                Label("Note: \(note)", systemImage: "note.text")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            if !entry.reviewText.isEmpty {
                Label("Review: \(entry.reviewText)", systemImage: "text.bubble.fill")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Divider()
            
            // MARK: - Nutrition Summary
            Text("Nutrition: \(entry.nutritionSummary)")
                .font(.caption2)
                .foregroundColor(.gray)
                .lineLimit(2)
            
            // MARK: - Footer
            HStack {
                Text("Cook Count: \(entry.cookCount)")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Spacer()
                
                Text("Mood When Cooked: \(entry.moodWhenCooked)")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding(15)
        .background(Color.white)
        .cornerRadius(15)
        .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 5)
        .padding(.horizontal, 8)
    }
    
    // MARK: Helper Views
    private struct GridStat: View {
        let icon: String
        let label: String
        let value: String
        let color: Color
        
        var body: some View {
            HStack(spacing: 5) {
                Image(systemName: icon)
                    .foregroundColor(color)
                    .font(.caption)
                Text(value)
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(.primary)
                    .lineLimit(1)
            }
        }
    }
    
    private struct FlagPill: View {
        let text: String
        let color: Color
        
        var body: some View {
            Text(text)
                .font(.caption2)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .padding(.horizontal, 8)
                .padding(.vertical, 3)
                .background(color)
                .cornerRadius(10)
        }
    }
}


@available(iOS 14.0, *)
struct FavoriteEntryListView: View {
    @ObservedObject var dataStore: SoupDataStore
    @State private var showingAddView = false
    @State private var searchText = ""
    
    var filteredFavorites: [FavoriteEntry] {
        if searchText.isEmpty {
            return dataStore.favorites
        } else {
            return dataStore.favorites.filter {
                $0.recipeName.localizedCaseInsensitiveContains(searchText) ||
                $0.customLabel.localizedCaseInsensitiveContains(searchText) ||
                $0.cuisine.localizedCaseInsensitiveContains(searchText) ||
                $0.author.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    private func delete(at offsets: IndexSet) {
        dataStore.deleteFavorite(at: offsets)
    }
    
    var body: some View {
            VStack {
                FavoriteEntrySearchBarView(searchText: $searchText)
                
                if filteredFavorites.isEmpty {
                    FavoriteEntryNoDataView()
                } else {
                    List {
                        ForEach(filteredFavorites) { entry in
                            NavigationLink(destination: FavoriteEntryDetailView(entry: entry)) {
                                FavoriteEntryListRowView(entry: entry)
                                    .listRowInsets(EdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 0))
                                    .background(Color(.systemBackground))
                            }
                        }
                        .onDelete(perform: delete)
                        .listRowBackground(Color(.systemGroupedBackground))
                    }
                    .listStyle(InsetGroupedListStyle())
                }
            }
            .navigationTitle("My Favorites")
            .background(Color(.systemGroupedBackground))
            .navigationBarItems(trailing:
                Button(action: {
                    showingAddView = true
                }) {
                    Image(systemName: "plus.circle.fill")
                        .foregroundColor(.pink)
                        .font(.title2)
                }
            )
            .sheet(isPresented: $showingAddView) {
                FavoriteEntryAddView(dataStore : dataStore)
            }
        
        .accentColor(.pink)
    }
}

@available(iOS 14.0, *)
struct FavoriteEntryDetailView: View {
    let entry: FavoriteEntry
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                
                VStack(alignment: .leading, spacing: 10) {
                    Text(entry.recipeName)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    Text(entry.favoriteReason)
                        .font(.title3)
                        .foregroundColor(.white.opacity(0.9))
                    
                    HStack {
                        Image(systemName: "person.crop.circle.fill")
                        Text(entry.author)
                        Spacer()
                        RatingStars(rating: entry.rating)
                    }
                    .foregroundColor(.white)
                    .font(.subheadline)
                }
                .padding(25)
                .frame(maxWidth: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: 25)
                        .fill(Color.pink.opacity(0.8))
                        .shadow(color: Color.pink.opacity(0.6), radius: 10, x: 0, y: 5)
                )
                .padding(.horizontal)
                .padding(.top, 10)
                
                VStack(alignment: .leading, spacing: 10) {
                    Text("Core Metrics")
                        .font(.title2)
                        .fontWeight(.heavy)
                        .foregroundColor(.primary)
                    
                    HStack {
                        DetailMetricView(icon: "clock.fill", label: "Total Time", value: "\(entry.totalTime)m", color: .orange)
                        DetailMetricView(icon: "flame.fill", label: "Cook Time", value: "\(entry.cookTime)m", color: .red)
                        DetailMetricView(icon: "repeat.circle.fill", label: "Cooked", value: "\(entry.timesCooked)", color: .blue)
                    }
                }
                .padding(.horizontal)
                
                VStack(alignment: .leading, spacing: 15) {
                    DetailSectionHeader(title: "Personal Review & Notes", icon: "pencil.and.scribble", color: .purple)
                    
                    HStack(alignment: .top) {
                        VStack(alignment: .leading, spacing: 10) {
                            FavoriteEntryDetailFieldRow(label: "Custom Label", value: entry.customLabel, iconName: "tag.fill", color: .purple)
                            FavoriteEntryDetailFieldRow(label: "My Note", value: entry.note ?? "No custom note added.", iconName: "note.text", color: .purple)
                            FavoriteEntryDetailFieldRow(label: "Review Text", value: entry.reviewText, iconName: "quote.bubble.fill", color: .purple)
                        }
                        .frame(maxWidth: .infinity)
                        
                        VStack(alignment: .leading, spacing: 10) {
                            FavoriteEntryDetailFieldRow(label: "Mood Tag", value: entry.moodTag, iconName: "face.smiling.fill", color: .purple)
                            FavoriteEntryDetailFieldRow(label: "Mood When Cooked", value: entry.moodWhenCooked, iconName: "face.smiling", color: .purple)
                            FavoriteEntryDetailFieldRow(label: "Image Preview", value: entry.imagePreview, iconName: "photo.fill", color: .purple)
                        }
                        .frame(maxWidth: .infinity)
                    }
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(15)
                .padding(.horizontal)
                
                DetailSectionHeader(title: "Recipe Categorization", icon: "list.bullet.rectangle.fill", color: .green)
                    .padding(.leading)
                
                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: 10) {
                        FavoriteEntryDetailFieldRow(label: "Category", value: entry.category, iconName: "square.grid.2x2", color: .green)
                        FavoriteEntryDetailFieldRow(label: "Cuisine", value: entry.cuisine, iconName: "map.fill", color: .green)
                        FavoriteEntryDetailFieldRow(label: "Difficulty", value: entry.difficultyLevel, iconName: "gauge.medium", color: .green)
                        FavoriteEntryDetailFieldRow(label: "Spice Level", value: entry.spiceLevel, iconName: "cloud.drizzle.fill", color: .green)
                        FavoriteEntryDetailFieldRow(label: "Prep Time (min)", value: "\(entry.prepTime)", iconName: "hourglass.start.fill", color: .green)
                    }
                    .frame(maxWidth: .infinity)
                    
                    VStack(alignment: .leading, spacing: 10) {
                        FavoriteEntryDetailFieldRow(label: "Source", value: entry.source, iconName: "link", color: .green)
                        FavoriteEntryDetailFieldRow(label: "Location Added", value: entry.locationAdded, iconName: "house.fill", color: .green)
                        FavoriteEntryDetailFieldRow(label: "Flavor Profile", value: entry.flavorProfile, iconName: "waveform.path.ecg", color: .green)
                        FavoriteEntryDetailFieldRow(label: "Cook Count", value: "\(entry.cookCount)", iconName: "number.square.fill", color: .green)
                        FavoriteEntryDetailFieldRow(label: "Rating Out of 5", value: "\(entry.ratingOutOfFive)", iconName: "star.lefthalf.fill", color: .green)
                    }
                    .frame(maxWidth: .infinity)
                }
                .padding(.horizontal)
                
                DetailSectionHeader(title: "Status & Dates", icon: "shield.righthalf.fill", color: .blue)
                    .padding(.leading)
                
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        FavoriteEntryDetailFieldRow(label: "Bookmarked At", value: entry.bookmarkedAt?.formattedDateTime() ?? "N/A", iconName: "bookmark.fill", color: .blue)
                        Spacer()
                        FavoriteEntryDetailFieldRow(label: "Last Cooked", value: entry.lastCooked?.formattedDate() ?? "N/A", iconName: "calendar.badge.clock", color: .blue)
                    }
                    
                    HStack {
                        FavoriteEntryDetailFieldRow(label: "Last Modified", value: entry.lastModified?.formattedDateTime() ?? "N/A", iconName: "slider.horizontal.3", color: .blue)
                        Spacer()
                        FavoriteEntryDetailFieldRow(label: "Shared Date", value: entry.sharedDate?.formattedDate() ?? "N/A", iconName: "person.2.fill", color: .blue)
                    }
                    
                    HStack {
                        FavoriteEntryDetailFieldRow(label: "Backup Status", value: entry.backupStatus, iconName: "icloud.fill", color: .blue)
                        Spacer()
                        FavoriteEntryDetailFieldRow(label: "Shared with Friends", value: entry.sharedWithFriends ? "Yes" : "No", iconName: "share.sheet.fill", color: .blue)
                    }
                    
                    HStack {
                        FavoriteEntryDetailFieldRow(label: "Is Weekly Favorite", value: entry.isWeeklyFavorite ? "Yes" : "No", iconName: "star.fill", color: .blue)
                        Spacer()
                        FavoriteEntryDetailFieldRow(label: "Is Seasonal Pick", value: entry.isSeasonalPick ? "Yes" : "No", iconName: "leaf.fill", color: .blue)
                    }
                    
                    FavoriteEntryDetailFieldRow(label: "Preparation Tips", value: entry.preparationTips, iconName: "lightbulb.fill", color: .blue)
                    
                    FavoriteEntryDetailFieldRow(label: "Nutrition Summary", value: entry.nutritionSummary, iconName: "cross.case.fill", color: .blue)
                }
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(15)
                .padding(.horizontal)
                
                Spacer(minLength: 50)
            }
        }
        .navigationTitle("Favorite Details")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private struct RatingStars: View {
        let rating: Double
        
        var body: some View {
            HStack(spacing: 1) {
                ForEach(1...5, id: \.self) { index in
                    Image(systemName: index <= Int(rating.rounded(.down)) ? "star.fill" : "star")
                        .foregroundColor(.yellow)
                        .font(.caption)
                }
                Text("\(String(format: "%.1f", rating))")
                    .font(.caption)
                    .fontWeight(.bold)
            }
        }
    }
    
    private struct DetailMetricView: View {
        let icon: String
        let label: String
        let value: String
        let color: Color
        
        var body: some View {
            VStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.title)
                    .foregroundColor(color)
                Text(value)
                    .font(.headline)
                    .fontWeight(.bold)
                Text(label)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .frame(maxWidth: .infinity)
            .padding(15)
            .background(Color(.systemGray6))
            .cornerRadius(15)
        }
    }
    
    private struct DetailSectionHeader: View {
        let title: String
        let icon: String
        let color: Color
        
        var body: some View {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(color)
                    .font(.headline)
                Text(title)
                    .font(.title3)
                    .fontWeight(.heavy)
                    .foregroundColor(.primary)
            }
            .padding(.top, 10)
        }
    }
}
