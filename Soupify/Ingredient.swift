

import SwiftUI
import Foundation
import Combine


@available(iOS 14.0, *)
struct IngredientFeatureRootView: View {
    @ObservedObject var dataStore: SoupDataStore
    
    var body: some View {
        NavigationView {
            IngredientListView(dataStore: dataStore)
        }
    }
}

@available(iOS 14.0, *)
struct IngredientAddView: View {
    @ObservedObject var dataStore: SoupDataStore
    @Environment(\.presentationMode) var presentationMode
    
    @State private var name: String = ""
    @State private var quantity: String = ""
    @State private var unit: String = ""
    @State private var category: String = ""
    @State private var freshnessLevel: String = "Fresh"
    @State private var supplier: String = ""
    @State private var origin: String = ""
    @State private var purchaseDate: Date = Date()
    @State private var expiryDate: Date = Calendar.current.date(byAdding: .day, value: 7, to: Date())!
    @State private var storageLocation: String = "Pantry"
    @State private var tags: String = ""
    @State private var caloriesPer100g: String = ""
    @State private var costPerUnit: String = ""
    @State private var isOrganic: Bool = false
    @State private var isLocal: Bool = false
    @State private var isAllergen: Bool = false
    @State private var allergenType: String = ""
    @State private var replacementSuggestions: String = ""
    @State private var color: String = ""
    @State private var texture: String = ""
    @State private var aroma: String = ""
    @State private var taste: String = ""
    @State private var preferredBrand: String = ""
    @State private var moistureLevel: String = ""
    @State private var density: String = ""
    @State private var nutritionGrade: String = "A"
    @State private var seasonality: String = "Year-Round"
    @State private var handlingTips: String = ""
    @State private var preparationSteps: String = ""
    @State private var rating: String = "0.0"
    @State private var barcode: String = ""
    @State private var shelfLifeDays: String = ""
    @State private var availabilityStatus: String = "Available"
    
    @State private var showAlert = false
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    
    let freshnessOptions = ["Fresh", "Frozen", "Dried", "Canned", "Refrigerated"]
    let storageOptions = ["Pantry", "Fridge", "Freezer", "Cool Room"]
    let nutritionGradeOptions = ["A", "B", "C", "D", "E"]
    let seasonalityOptions = ["Year-Round", "Spring", "Summer", "Autumn", "Winter"]
    let availabilityOptions = ["Available", "Low Stock", "Out of Stock"]
    
    private func validateAndSave() {
        var errors: [String] = []
        
        if name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            errors.append("• Name is required.")
        }
        if quantity.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            errors.append("• Quantity is required.")
        }
        if unit.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            errors.append("• Unit is required.")
        }
        if Int(caloriesPer100g) == nil || (Int(caloriesPer100g) ?? -1) < 0 {
            errors.append("• Calories must be a valid non-negative number.")
        }
        if Double(costPerUnit) == nil || (Double(costPerUnit) ?? -1) < 0 {
            errors.append("• Cost must be a valid non-negative number.")
        }
        if isAllergen && allergenType.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            errors.append("• Allergen type is required.")
        }
        if Double(density) == nil || (Double(density) ?? -1) < 0 {
            errors.append("• Density must be a valid non-negative number.")
        }
        if Int(shelfLifeDays) == nil || (Int(shelfLifeDays) ?? -1) < 0 {
            errors.append("• Shelf life must be a valid non-negative integer.")
        }
        
        if errors.isEmpty {
            saveIngredient()
            alertTitle = "Success!"
            alertMessage = "New ingredient, **\(name)**, has been added to your inventory."
        } else {
            alertTitle = "Validation Error"
            alertMessage = "Please correct the following issues:\n\n" + errors.joined(separator: "\n")
        }
        
        showAlert = true
    }
    
    private func saveIngredient() {
        let newIngredient = Ingredient(
            name: name,
            quantity: quantity,
            unit: unit,
            category: category,
            freshnessLevel: freshnessLevel,
            supplier: supplier,
            origin: origin,
            purchaseDate: purchaseDate,
            expiryDate: expiryDate,
            storageLocation: storageLocation,
            tags: tags.split(separator: ",").map { $0.trimmingCharacters(in: .whitespacesAndNewlines) },
            caloriesPer100g: Int(caloriesPer100g) ?? 0,
            costPerUnit: Double(costPerUnit) ?? 0.0,
            isOrganic: isOrganic,
            isLocal: isLocal,
            isAllergen: isAllergen,
            allergenType: allergenType,
            replacementSuggestions: replacementSuggestions.split(separator: ",").map { $0.trimmingCharacters(in: .whitespacesAndNewlines) },
            color: color,
            texture: texture,
            aroma: aroma,
            taste: taste,
            usedInRecipes: [],
            preferredBrand: preferredBrand,
            moistureLevel: moistureLevel,
            density: Double(density) ?? 0.0,
            nutritionGrade: nutritionGrade,
            seasonality: seasonality,
            handlingTips: handlingTips,
            preparationSteps: preparationSteps.split(separator: ".").map { $0.trimmingCharacters(in: .whitespacesAndNewlines) + "." },
            rating: Double(rating) ?? 0.0,
            barcode: barcode,
            shelfLifeDays: Int(shelfLifeDays) ?? 0,
            availabilityStatus: availabilityStatus
        )
        
        dataStore.addIngredient(newIngredient)
    }
    
    var body: some View {
        ZStack(alignment: .top) {
            Color(.systemGray6).edgesIgnoringSafeArea(.all)
            
            ScrollView {
                VStack(spacing: 25) {
                    
                    IngredientAddSectionHeaderView(title: "Core Identification", iconName: "tag.circle.fill", color: .blue)
                    
                    VStack(spacing: 20) {
                        IngredientAddFieldView(
                            title: "Name",
                            placeholder: "e.g., Organic Basil",
                            text: $name,
                            iconName: "leaf.fill"
                        )
                        IngredientAddFieldView(
                            title: "Category",
                            placeholder: "e.g., Herb or Spice",
                            text: $category,
                            iconName: "folder.fill"
                        )
                        IngredientAddFieldView(
                            title: "Preferred Brand",
                            placeholder: "Optional",
                            text: $preferredBrand,
                            iconName: "star.circle.fill"
                        )
                        IngredientAddFieldView(
                            title: "Barcode",
                            placeholder: "Scan or enter code",
                            text: $barcode,
                            iconName: "barcode"
                        )
                    }
                    .modifier(IngredientAddSectionStyle())
                    
                    IngredientAddSectionHeaderView(title: "Quantity & Cost", iconName: "dollarsign.circle.fill", color: .green)
                    
                    VStack(spacing: 20) {
                        HStack(spacing: 15) {
                            IngredientAddFieldView(
                                title: "Quantity",
                                placeholder: "e.g., 100",
                                text: $quantity,
                                iconName: "number.circle.fill",
                                keyboardType: .decimalPad
                            )
                            IngredientAddFieldView(
                                title: "Unit",
                                placeholder: "e.g., grams",
                                text: $unit,
                                iconName: "ruler.fill"
                            )
                        }
                        
                        IngredientAddFieldView(
                            title: "Cost Per Unit",
                            placeholder: "e.g., 5.99",
                            text: $costPerUnit,
                            iconName: "dollarsign.circle.fill",
                            keyboardType: .decimalPad
                        )
                        IngredientAddFieldView(
                            title: "Shelf Life (Days)",
                            placeholder: "e.g., 7",
                            text: $shelfLifeDays,
                            iconName: "timelapse",
                            keyboardType: .numberPad
                        )
                        IngredientAddPickerView(
                            title: "Availability Status",
                            selection: $availabilityStatus,
                            options: availabilityOptions,
                            iconName: "checkmark.circle.fill"
                        )
                    }
                    .modifier(IngredientAddSectionStyle())
                    
                    IngredientAddSectionHeaderView(title: "Source & Inventory", iconName: "map.fill", color: .orange)
                    
                    VStack(spacing: 20) {
                        HStack(spacing: 15) {
                            IngredientAddFieldView(
                                title: "Origin",
                                placeholder: "e.g., USA",
                                text: $origin,
                                iconName: "globe"
                            )
                            IngredientAddFieldView(
                                title: "Supplier",
                                placeholder: "e.g., Trader Joe's",
                                text: $supplier,
                                iconName: "cart.fill"
                            )
                        }
                        
                        IngredientAddPickerView(
                            title: "Freshness Level",
                            selection: $freshnessLevel,
                            options: freshnessOptions,
                            iconName: "bolt.fill"
                        )
                        IngredientAddPickerView(
                            title: "Storage Location",
                            selection: $storageLocation,
                            options: storageOptions,
                            iconName: "house.fill"
                        )
                        IngredientAddDatePickerView(
                            title: "Purchase Date",
                            date: $purchaseDate,
                            iconName: "calendar.badge.plus"
                        )
                        IngredientAddDatePickerView(
                            title: "Expiry Date",
                            date: $expiryDate,
                            iconName: "clock.badge.xmark.fill"
                        )
                    }
                    .modifier(IngredientAddSectionStyle())
                    
                    IngredientAddSectionHeaderView(title: "Nutrition & Status", iconName: "heart.circle.fill", color: .red)
                    
                    VStack(spacing: 20) {
                        HStack(spacing: 15) {
                            IngredientAddFieldView(
                                title: "Calories/100g",
                                placeholder: "e.g., 18",
                                text: $caloriesPer100g,
                                iconName: "flame.fill",
                                keyboardType: .numberPad
                            )
                            IngredientAddPickerView(
                                title: "Nutrition Grade",
                                selection: $nutritionGrade,
                                options: nutritionGradeOptions,
                                iconName: "star.fill"
                            )
                        }
                        
                        HStack {
                            IngredientAddToggleView(
                                title: "Is Organic",
                                isOn: $isOrganic,
                                iconName: "goforward"
                            )
                            IngredientAddToggleView(
                                title: "Is Local",
                                isOn: $isLocal,
                                iconName: "mappin.and.ellipse"
                            )
                        }
                        
                        IngredientAddToggleView(
                            title: "Is Allergen",
                            isOn: $isAllergen,
                            iconName: "exclamationmark.triangle.fill"
                        )
                        
                        if isAllergen {
                            IngredientAddFieldView(
                                title: "Allergen Type",
                                placeholder: "e.g., Nut, Soy, Dairy",
                                text: $allergenType,
                                iconName: "staroflife.fill"
                            )
                        }
                        
                        IngredientAddFieldView(
                            title: "Tags (Comma Separated)",
                            placeholder: "e.g., fresh, organic, bulk",
                            text: $tags,
                            iconName: "tag"
                        )
                        
                        IngredientAddFieldView(
                            title: "Moisture Level",
                            placeholder: "e.g., Low, Medium, High",
                            text: $moistureLevel,
                            iconName: "drop.fill"
                        )
                        
                        IngredientAddFieldView(
                            title: "Density (g/cm³)",
                            placeholder: "e.g., 0.9",
                            text: $density,
                            iconName: "cube.fill",
                            keyboardType: .decimalPad
                        )
                    }
                    .modifier(IngredientAddSectionStyle())
                    
                    IngredientAddSectionHeaderView(title: "Sensory & Use", iconName: "eyedropper.full.fill", color: .pink)
                    
                    VStack(spacing: 20) {
                        IngredientAddFieldView(
                            title: "Color",
                            placeholder: "e.g., Red, Green",
                            text: $color,
                            iconName: "paintbrush.fill"
                        )
                        IngredientAddFieldView(
                            title: "Texture",
                            placeholder: "e.g., Smooth, Crunchy",
                            text: $texture,
                            iconName: "hand.raised.fill"
                        )
                        IngredientAddFieldView(
                            title: "Aroma",
                            placeholder: "e.g., Mild, Pungent",
                            text: $aroma,
                            iconName: "leaf.fill"
                        )
                        IngredientAddFieldView(
                            title: "Taste",
                            placeholder: "e.g., Tangy, Sweet",
                            text: $taste,
                            iconName: "mouth.fill"
                        )
                        IngredientAddPickerView(
                            title: "Seasonality",
                            selection: $seasonality,
                            options: seasonalityOptions,
                            iconName: "cloud.sun.fill"
                        )
                        IngredientAddFieldView(
                            title: "Handling Tips",
                            placeholder: "Brief tips for handling",
                            text: $handlingTips,
                            iconName: "hand.tap.fill"
                        )
                        IngredientAddFieldView(
                            title: "Preparation Steps (Separate by '.')",
                            placeholder: "e.g., Wash thoroughly. Chop finely.",
                            text: $preparationSteps,
                            iconName: "list.number"
                        )
                        IngredientAddFieldView(
                            title: "Replacement Suggestions (Comma Separated)",
                            placeholder: "e.g., Canned Tomato, Tomato Paste",
                            text: $replacementSuggestions,
                            iconName: "repeat"
                        )
                    }
                    .modifier(IngredientAddSectionStyle())
                    
                    Button(action: {
                        validateAndSave()
                    }) {
                        Text("Save Ingredient")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.accentColor)
                            .cornerRadius(15)
                            .shadow(color: Color.accentColor.opacity(0.4), radius: 10, x: 0, y: 5)
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 50)
                }
                .padding(.top, 20)
            }
            .navigationTitle("Add New Ingredient")
            .navigationBarTitleDisplayMode(.inline)
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text(alertTitle),
                    message: Text(alertMessage),
                    dismissButton: .default(Text("OK"), action: {
                        if alertTitle == "Success!" {
                            presentationMode.wrappedValue.dismiss()
                        }
                    })
                )
            }
        }
    }
}

@available(iOS 14.0, *)
struct IngredientAddSectionHeaderView: View {
    let title: String
    let iconName: String
    let color: Color
    
    var body: some View {
        HStack {
            Image(systemName: iconName)
                .foregroundColor(color)
                .font(.title3)
            Text(title)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.primary)
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.top, 10)
    }
}

@available(iOS 14.0, *)
struct IngredientAddSectionStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(15)
            .background(Color.white)
            .cornerRadius(20)
            .shadow(color: Color.black.opacity(0.08), radius: 10, x: 0, y: 5)
            .padding(.horizontal, 15)
    }
}

@available(iOS 14.0, *)
struct IngredientAddFieldView: View {
    let title: String
    let placeholder: String
    @Binding var text: String
    let iconName: String
    var keyboardType: UIKeyboardType = .default
    
    private var isFloating: Bool {
        !text.isEmpty
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            
            Text(title)
                .font(.caption)
                .foregroundColor(isFloating ? .accentColor : .secondary)
                .offset(y: isFloating ? -28 : 0)
                .scaleEffect(isFloating ? 1.0 : 1.1, anchor: .leading)
                .animation(.easeOut(duration: 0.2), value: isFloating)
            
            HStack {
                Image(systemName: iconName)
                    .foregroundColor(.secondary)
                    .frame(width: 20)
                
                TextField(placeholder, text: $text)
                    .keyboardType(keyboardType)
                    .disableAutocorrection(true)
            }
            
            Divider().background(Color.secondary.opacity(0.5))
        }
    }
}

@available(iOS 14.0, *)
struct IngredientAddDatePickerView: View {
    let title: String
    @Binding var date: Date
    let iconName: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            HStack {
                Image(systemName: iconName)
                    .foregroundColor(.accentColor)
                    .frame(width: 20)
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.medium)
                Spacer()
            }
            
            DatePicker("", selection: $date, displayedComponents: .date)
                .datePickerStyle(CompactDatePickerStyle())
                .labelsHidden()
                .frame(maxWidth: .infinity, alignment: .trailing)
        }
    }
}

@available(iOS 14.0, *)
struct IngredientAddPickerView: View {
    let title: String
    @Binding var selection: String
    let options: [String]
    let iconName: String
    
    var body: some View {
        HStack {
            Image(systemName: iconName)
                .foregroundColor(.accentColor)
                .frame(width: 20)
            
            Text(title)
                .font(.subheadline)
                .fontWeight(.medium)
            
            Spacer()
            
            Picker(title, selection: $selection) {
                ForEach(options, id: \.self) { option in
                    Text(option).tag(option)
                }
            }
            .pickerStyle(MenuPickerStyle())
            .labelsHidden()
        }
    }
}

@available(iOS 14.0, *)
struct IngredientAddToggleView: View {
    let title: String
    @Binding var isOn: Bool
    let iconName: String
    
    var body: some View {
        HStack {
            Image(systemName: iconName)
                .foregroundColor(.accentColor)
                .frame(width: 20)
            
            Text(title)
                .font(.subheadline)
                .fontWeight(.medium)
            
            Spacer()
            
            Toggle("", isOn: $isOn)
                .labelsHidden()
                .toggleStyle(SwitchToggleStyle(tint: .accentColor))
        }
    }
}

@available(iOS 14.0, *)
struct IngredientListView: View {
    @ObservedObject var dataStore: SoupDataStore
    
    @State private var searchText: String = ""
    
    var filteredIngredients: [Ingredient] {
        if searchText.isEmpty {
            return dataStore.ingredients
        } else {
            return dataStore.ingredients.filter {
                $0.name.localizedCaseInsensitiveContains(searchText) ||
                $0.category.localizedCaseInsensitiveContains(searchText) ||
                $0.supplier.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    var body: some View {
        ZStack {
            Color(.systemGray6).edgesIgnoringSafeArea(.all)
            
            VStack {
                IngredientSearchBarView(searchText: $searchText)
                    .padding(.horizontal, 15)
                    .padding(.top, 5)
                
                if filteredIngredients.isEmpty {
                    IngredientNoDataView(
                        title: "No Ingredients Found",
                        subtitle: "Try a different search term or add a new ingredient.",
                        iconName: "magnifyingglass.circle"
                    )
                } else {
                    List {
                        ForEach(filteredIngredients) { ingredient in
                            ZStack {
                                NavigationLink(destination: IngredientDetailView(ingredient: ingredient)) {
                                    EmptyView()
                                }
                                .opacity(0)
                                
                                IngredientListRowView(ingredient: ingredient)
                            }
                            .listRowInsets(EdgeInsets(top: 8, leading: 0, bottom: 8, trailing: 0))
                            .background(Color(.systemGray6))
                        }
                        .onDelete(perform: deleteIngredient)
                        .listRowBackground(Color(.systemGray6))
                    }
                    .listStyle(InsetGroupedListStyle())
                }
            }
            .navigationTitle("Ingredient Inventory")
            .navigationBarItems(trailing:
                                    NavigationLink(destination: IngredientAddView(dataStore: dataStore)) {
                    Image(systemName: "plus.circle.fill")
                        .font(.title2)
                        .foregroundColor(.accentColor)
                }
            )
        }
    }
    
    private func deleteIngredient(at offsets: IndexSet) {
        let ingredientsToDelete = offsets.map { filteredIngredients[$0] }
        
        for ingredient in ingredientsToDelete {
            if let index = dataStore.ingredients.firstIndex(where: { $0.id == ingredient.id }) {
                dataStore.deleteIngredient(at: IndexSet(integer: index))
            }
        }
    }
}

@available(iOS 14.0, *)
struct IngredientSearchBarView: View {
    @Binding var searchText: String
    @State private var isEditing = false
    
    var body: some View {
        HStack {
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
                
                TextField("Search ingredients, categories...", text: $searchText, onEditingChanged: { isEditing in
                    withAnimation {
                        self.isEditing = isEditing
                    }
                })
                .foregroundColor(.primary)
                .autocapitalization(.none)
                .disableAutocorrection(true)
                
                if !searchText.isEmpty {
                    Button(action: {
                        searchText = ""
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.gray)
                    }
                }
            }
            .padding(10)
            .background(Color(.systemGray5))
            .cornerRadius(10)
            .padding(.trailing, isEditing ? 0 : 10)
            .transition(.move(edge: .leading))
            
            if isEditing {
                Button("Cancel") {
                    searchText = ""
                    withAnimation {
                        isEditing = false
                    }
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                }
                .transition(.move(edge: .trailing))
            }
        }
    }
}
@available(iOS 14.0, *)
struct IngredientListRowView: View {
    let ingredient: Ingredient
    
    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            
            // MARK: - Header
            HStack {
                Text(ingredient.name)
                    .font(.system(.title3, design: .rounded))
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                    .lineLimit(1)
                
                Spacer()
                
                Text(ingredient.freshnessLevel)
                    .font(.caption2)
                    .fontWeight(.semibold)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(freshnessColor(ingredient.freshnessLevel).opacity(0.15))
                    .foregroundColor(freshnessColor(ingredient.freshnessLevel))
                    .cornerRadius(5)
            }
            
            // MARK: - Basic Details Row
            HStack(spacing: 18) {
                IngredientListDetailPill(
                    iconName: "tag.fill",
                    label: ingredient.category,
                    value: "\(ingredient.quantity) \(ingredient.unit)",
                    color: .orange
                )
                
                Divider().frame(height: 30)
                
                IngredientListDetailPill(
                    iconName: "dollarsign.circle.fill",
                    label: "Cost",
                    value: String(format: "$%.2f", ingredient.costPerUnit),
                    color: .green
                )
                
                Divider().frame(height: 30)
                
                IngredientListDetailPill(
                    iconName: "flame.fill",
                    label: "Calories/100g",
                    value: "\(ingredient.caloriesPer100g) kcal",
                    color: .red
                )
            }
            .padding(.horizontal, 5)
            
            Divider()
            
            // MARK: - Origin & Supplier Info
            HStack {
                Label("Origin: \(ingredient.origin)", systemImage: "globe.asia.australia.fill")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Spacer()
                
                Label("Supplier: \(ingredient.supplier)", systemImage: "shippingbox.fill")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            // MARK: - Storage & Expiry Info
            HStack {
                Label("Expires: \(expiryDateFormatter.string(from: ingredient.expiryDate ?? Date()))", systemImage: "calendar.badge.exclamationmark.fill")
                    .foregroundColor(.red)
                
                Spacer()
                
                Label("Stored: \(ingredient.storageLocation)", systemImage: "house.fill")
                    .foregroundColor(.blue)
                
                Spacer()
                
                Label("\(ingredient.shelfLifeDays) Days", systemImage: "timelapse")
                    .foregroundColor(.gray)
            }
            .font(.caption)
            .foregroundColor(.secondary)
            
            Divider()
            
            // MARK: - Sensory Info (Aroma, Taste, Texture, Moisture)
            HStack(spacing: 15) {
                Label(ingredient.aroma, systemImage: "nose.fill")
                    .font(.caption2)
                    .foregroundColor(.purple)
                
                Label(ingredient.taste, systemImage: "fork.knife")
                    .font(.caption2)
                    .foregroundColor(.orange)
                
                Label(ingredient.texture, systemImage: "square.grid.3x3.fill")
                    .font(.caption2)
                    .foregroundColor(.blue)
                
                Label(ingredient.moistureLevel, systemImage: "drop.fill")
                    .font(.caption2)
                    .foregroundColor(.green)
            }
            
            HStack {
                IngredientListStatusPill(label: "Organic", isTrue: ingredient.isOrganic, trueColor: .green)
                IngredientListStatusPill(label: "Local", isTrue: ingredient.isLocal, trueColor: .blue)
                IngredientListStatusPill(label: "Allergen", isTrue: ingredient.isAllergen, trueColor: .red)
                
                Spacer()
                
                Text("Grade: \(ingredient.nutritionGrade)")
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(.secondary)
            }
            
            Divider()
            
            VStack(alignment: .leading, spacing: 6) {
                if !ingredient.tags.isEmpty {
                    Text("Tags: \(ingredient.tags.joined(separator: ", "))")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                if !ingredient.replacementSuggestions.isEmpty {
                    Text("Replacements: \(ingredient.replacementSuggestions.joined(separator: ", "))")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                if !ingredient.seasonality.isEmpty {
                    Label("Seasonality: \(ingredient.seasonality)", systemImage: "leaf.fill")
                        .font(.caption)
                        .foregroundColor(.green)
                }
            }
            
            HStack {
                HStack(spacing: 4) {
                    Image(systemName: "star.fill")
                        .foregroundColor(.yellow)
                    Text(String(format: "%.1f", ingredient.rating))
                }
                .font(.caption)
                .foregroundColor(.secondary)
                
                Spacer()
                
                if let lastUpdated = ingredient.lastUpdated {
                    Text("Updated: \(expiryDateFormatter.string(from: lastUpdated))")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
            }
            
        }
        .padding()
        .background(Color.white)
        .cornerRadius(15)
        .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 4)
        .padding(.horizontal)
    }
    
    private func freshnessColor(_ level: String) -> Color {
        switch level {
        case "Fresh": return .green
        case "Frozen": return .blue
        case "Dried": return .orange
        default: return .gray
        }
    }
    
    private var expiryDateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter
    }
}


@available(iOS 14.0, *)
struct IngredientListDetailPill: View {
    let iconName: String
    let label: String
    let value: String
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack(spacing: 4) {
                Image(systemName: iconName)
                    .font(.caption2)
                    .foregroundColor(color)
                Text(label)
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
            Text(value)
                .font(.callout)
                .fontWeight(.semibold)
                .foregroundColor(.primary)
                .lineLimit(1)
        }
    }
}

@available(iOS 14.0, *)
struct IngredientListStatusPill: View {
    let label: String
    let isTrue: Bool
    let trueColor: Color
    
    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: isTrue ? "checkmark.circle.fill" : "xmark.circle")
                .foregroundColor(isTrue ? trueColor : .gray)
            Text(label)
        }
        .font(.caption)
        .foregroundColor(.secondary)
        .padding(.horizontal, 6)
        .padding(.vertical, 3)
        .background(Color(.systemGray5))
        .cornerRadius(5)
    }
}

@available(iOS 14.0, *)
struct IngredientNoDataView: View {
    let title: String
    let subtitle: String
    let iconName: String
    
    var body: some View {
        VStack(spacing: 15) {
            Image(systemName: iconName)
                .font(.system(size: 80))
                .foregroundColor(.gray)
                .padding(.bottom, 10)
            
            Text(title)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.primary)
            
            Text(subtitle)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

@available(iOS 14.0, *)
struct IngredientDetailView: View {
    let ingredient: Ingredient
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 25) {
                
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        VStack(alignment: .leading, spacing: 5) {
                            Text(ingredient.name)
                                .font(.system(.largeTitle, design: .serif))
                                .fontWeight(.heavy)
                                .foregroundColor(.white)
                            
                            HStack {
                                Image(systemName: "tag.fill").foregroundColor(.yellow)
                                Text(ingredient.category)
                                    .font(.headline)
                                    .foregroundColor(.white.opacity(0.8))
                            }
                        }
                        Spacer()
                        Image(systemName: "basket.fill")
                            .font(.system(size: 60))
                            .foregroundColor(.white.opacity(0.9))
                    }
                    
                    HStack(spacing: 10) {
                        IngredientDetailStatusPill(label: "Organic", value: ingredient.isOrganic ? "Yes" : "No", color: .green)
                        IngredientDetailStatusPill(label: "Local", value: ingredient.isLocal ? "Yes" : "No", color: .blue)
                        IngredientDetailStatusPill(label: "Allergen", value: ingredient.isAllergen ? "Yes" : "No", color: .red)
                        IngredientDetailStatusPill(label: "Grade", value: ingredient.nutritionGrade, color: .purple)
                    }
                    .padding(.top, 10)
                }
                .padding(25)
                .background(
                    LinearGradient(
                        gradient: Gradient(colors: [Color.accentColor, Color.accentColor.opacity(0.8)]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .cornerRadius(25)
                .shadow(color: Color.accentColor.opacity(0.5), radius: 15, x: 0, y: 8)
                .padding(.horizontal, 20)
                .padding(.bottom, 10)
                
                IngredientDetailGroup(title: "Inventory & Quantities", iconName: "archivebox.fill", color: .purple) {
                    VStack(spacing: 15) {
                        HStack {
                            IngredientDetailFieldRow(label: "Quantity", value: "\(ingredient.quantity) \(ingredient.unit)", icon: "ruler.fill")
                            IngredientDetailFieldRow(label: "Cost Per Unit", value: String(format: "$%.2f", ingredient.costPerUnit), icon: "dollarsign.circle.fill")
                        }
                        HStack {
                            IngredientDetailFieldRow(label: "Freshness Level", value: ingredient.freshnessLevel, icon: "bolt.fill")
                            IngredientDetailFieldRow(label: "Storage Location", value: ingredient.storageLocation, icon: "house.fill")
                        }
                        HStack {
                            IngredientDetailFieldRow(label: "Shelf Life", value: "\(ingredient.shelfLifeDays) Days", icon: "timelapse")
                            IngredientDetailFieldRow(label: "Availability", value: ingredient.availabilityStatus, icon: "checkmark.circle.fill")
                        }
                        IngredientDetailFieldRow(label: "Barcode", value: ingredient.barcode.isEmpty ? "N/A" : ingredient.barcode, icon: "barcode")
                        IngredientDetailFieldRow(label: "Preferred Brand", value: ingredient.preferredBrand.isEmpty ? "N/A" : ingredient.preferredBrand, icon: "star.circle.fill")
                    }
                }
                
                IngredientDetailGroup(title: "Source & Dates", iconName: "calendar.badge.clock.fill", color: .orange) {
                    VStack(spacing: 15) {
                        HStack {
                            IngredientDetailFieldRow(label: "Supplier", value: ingredient.supplier.isEmpty ? "N/A" : ingredient.supplier, icon: "cart.fill")
                            IngredientDetailFieldRow(label: "Origin", value: ingredient.origin.isEmpty ? "N/A" : ingredient.origin, icon: "globe")
                        }
                        IngredientHeaderFieldRow(label: "Purchase Date", value: self.dateFormatter.string(from: ingredient.purchaseDate ?? Date()), icon: "calendar.badge.plus")
                        IngredientHeaderFieldRow(label: "Expiry Date", value: self.dateFormatter.string(from: ingredient.expiryDate ?? Date()), icon: "clock.badge.xmark.fill")
                        IngredientHeaderFieldRow(label: "Last Updated", value: self.dateFormatter.string(from: ingredient.lastUpdated ?? Date()), icon: "arrow.clockwise.circle.fill")
                    }
                }
                
                IngredientDetailGroup(title: "Nutritional Data", iconName: "flame.fill", color: .red) {
                    VStack(spacing: 15) {
                        HStack {
                            IngredientDetailFieldRow(label: "Calories (per 100g)", value: "\(ingredient.caloriesPer100g) kcal", icon: "bolt.heart.fill")
                            IngredientDetailFieldRow(label: "Density (g/cm³)", value: String(format: "%.2f", ingredient.density), icon: "cube.fill")
                        }
                        HStack {
                            IngredientDetailFieldRow(label: "Moisture Level", value: ingredient.moistureLevel.isEmpty ? "N/A" : ingredient.moistureLevel, icon: "drop.fill")
                            IngredientDetailFieldRow(label: "Seasonality", value: ingredient.seasonality.isEmpty ? "N/A" : ingredient.seasonality, icon: "cloud.sun.fill")
                        }
                        
                        if ingredient.isAllergen {
                            IngredientDetailFieldRow(label: "Allergen Type", value: ingredient.allergenType, icon: "exclamationmark.triangle.fill")
                        }
                    }
                }
                
                IngredientDetailGroup(title: "Sensory Profile", iconName: "wand.and.stars", color: .pink) {
                    VStack(spacing: 15) {
                        HStack {
                            IngredientDetailFieldRow(label: "Color", value: ingredient.color.isEmpty ? "N/A" : ingredient.color, icon: "paintbrush.fill")
                            IngredientDetailFieldRow(label: "Texture", value: ingredient.texture.isEmpty ? "N/A" : ingredient.texture, icon: "hand.raised.fill")
                        }
                        HStack {
                            IngredientDetailFieldRow(label: "Aroma", value: ingredient.aroma.isEmpty ? "N/A" : ingredient.aroma, icon: "leaf.fill")
                            IngredientDetailFieldRow(label: "Taste", value: ingredient.taste.isEmpty ? "N/A" : ingredient.taste, icon: "mouth.fill")
                        }
                    }
                }
                
                IngredientDetailGroup(title: "Tips & Suggestions", iconName: "lightbulb.fill", color: .orange) {
                    VStack(alignment: .leading, spacing: 10) {
                        IngredientDetailLargeTextField(label: "Handling Tips", text: ingredient.handlingTips.isEmpty ? "No specific tips provided." : ingredient.handlingTips)
                        IngredientDetailLargeTextField(label: "Preparation Steps", text: ingredient.preparationSteps.isEmpty ? "No specific steps provided." : ingredient.preparationSteps.joined(separator: ", "))
                        IngredientDetailLargeTextField(label: "Replacement Suggestions", text: ingredient.replacementSuggestions.isEmpty ? "None" : ingredient.replacementSuggestions.joined(separator: ", "))
                    }
                }
                
                Spacer().frame(height: 50)
            }
            .padding(.top, 10)
            
        }
        .navigationTitle(ingredient.name)
        .navigationBarTitleDisplayMode(.inline)
        .background(Color(.systemGray6).edgesIgnoringSafeArea(.all))
    }
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }
}

@available(iOS 14.0, *)
struct IngredientDetailStatusPill: View {
    let label: String
    let value: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 5) {
            Image(systemName: value == "Yes" || value.count == 1 ? "checkmark.circle.fill" : "xmark.circle.fill")
            Text("\(label): \(value)")
        }
        .font(.caption)
        .padding(.horizontal, 10)
        .padding(.vertical, 5)
        .background(color.opacity(0.8))
        .foregroundColor(.white)
        .cornerRadius(10)
    }
}

@available(iOS 14.0, *)
struct IngredientDetailGroup<Content: View>: View {
    let title: String
    let iconName: String
    let color: Color
    let content: Content
    
    init(title: String, iconName: String, color: Color, @ViewBuilder content: () -> Content) {
        self.title = title
        self.iconName = iconName
        self.color = color
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            HStack(spacing: 10) {
                Image(systemName: iconName)
                    .font(.title3)
                    .foregroundColor(color)
                Text(title)
                    .font(.title2)
                    .fontWeight(.bold)
            }
            .padding(.bottom, 5)
            
            VStack(spacing: 15) {
                content
            }
            .padding()
            .background(Color.white)
            .cornerRadius(15)
            .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 3)
        }
        .padding(.horizontal, 20)
    }
}

@available(iOS 14.0, *)
struct IngredientDetailFieldRow: View {
    let label: String
    let value: String
    let icon: String
    
    var body: some View {
        HStack(alignment: .top) {
            Image(systemName: icon)
                .frame(width: 20)
                .foregroundColor(.secondary)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(label)
                    .font(.caption)
                    .foregroundColor(.gray)
                
                Text(value)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(.primary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

@available(iOS 14.0, *)
struct IngredientHeaderFieldRow: View {
    let label: String
    let value: String
    let icon: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.accentColor)
                .frame(width: 20)
            
            VStack(alignment: .leading) {
                Text(label)
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Text(value)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
            }
            Spacer()
        }
    }
}

@available(iOS 14.0, *)
struct IngredientDetailLargeTextField: View {
    let label: String
    let text: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(label)
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(.primary)
            
            Text(text)
                .font(.body)
                .foregroundColor(.secondary)
                .padding(.all, 10)
                .background(Color(.systemGray6))
                .cornerRadius(8)
        }
        .padding(.bottom, 5)
    }
}
