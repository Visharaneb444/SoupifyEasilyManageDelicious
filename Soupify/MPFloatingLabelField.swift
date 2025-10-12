

import SwiftUI
import Combine

@available(iOS 14.0, *)
struct MPFloatingLabelField: View {
    @Binding var text: String
    var title: String
    var iconName: String
    var keyboardType: UIKeyboardType = .default
    var isRequired: Bool = false

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            HStack(spacing: 8) {
                Image(systemName: iconName)
                    .foregroundColor(.accentColor)
                    .frame(width: 20)
                
                TextField("", text: $text)
                    .keyboardType(keyboardType)
                    .padding(.vertical, 8)
                    .overlay(
                        Text(title + (isRequired ? "*" : ""))
                            .font(text.isEmpty ? .body : .caption)
                            .foregroundColor(.gray)
                            .offset(y: text.isEmpty ? 0 : -25)
                            .animation(.easeOut(duration: 0.15), value: text.isEmpty)
                        , alignment: .leading
                    )
            }
            Divider()
                .background(text.isEmpty ? Color.gray.opacity(0.5) : Color.accentColor)
        }
        .padding(.top, text.isEmpty ? 0 : 25)
        .padding(.horizontal, 10)
    }
}

@available(iOS 14.0, *)
struct MPAddSectionHeader: View {
    let title: String
    let iconName: String
    
    var body: some View {
        HStack {
            Image(systemName: iconName)
                .font(.title3)
                .foregroundColor(.white)
                .padding(6)
                .background(Color.accentColor.opacity(0.8))
                .clipShape(Circle())
            
            Text(title)
                .font(.headline)
                .foregroundColor(.primary)
            
            Spacer()
        }
        .padding(.horizontal)
        .padding(.vertical, 10)
        .background(Color(.systemGray6))
        .cornerRadius(10)
    }
}

@available(iOS 14.0, *)
struct MPAddStepperField: View {
    @Binding var value: Int
    let title: String
    let iconName: String
    let unit: String
    let range: ClosedRange<Int>
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Image(systemName: iconName)
                    .foregroundColor(.accentColor)
                    .frame(width: 20)
                
                Text(title)
                    .foregroundColor(.primary)
                
                Spacer()
                
                Stepper(value: $value, in: range) {
                    Text("\(value) \(unit)")
                        .fontWeight(.medium)
                        .foregroundColor(.secondary)
                }
                .frame(width: 150)
            }
            Divider()
        }
        .padding(.horizontal, 10)
    }
}

@available(iOS 14.0, *)
struct MPAddToggleField: View {
    @Binding var isOn: Bool
    let title: String
    let iconName: String
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Image(systemName: iconName)
                    .foregroundColor(.accentColor)
                    .frame(width: 20)
                
                Text(title)
                    .foregroundColor(.primary)
                
                Spacer()
                
                Toggle("", isOn: $isOn)
                    .labelsHidden()
            }
            Divider()
        }
        .padding(.horizontal, 10)
    }
}

@available(iOS 14.0, *)
struct MPDetailFieldRow: View {
    let label: String
    let value: String
    let icon: String
    
    var body: some View {
        HStack(alignment: .top) {
            HStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.caption)
                    .foregroundColor(Color.accentColor)
                    .frame(width: 20)
                Text(label)
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            .frame(width: 150, alignment: .leading)
            
            Text(value)
                .font(.callout)
                .fontWeight(.medium)
                .foregroundColor(.primary)
                .lineLimit(2)
            
            Spacer()
        }
        .padding(.vertical, 5)
    }
}

@available(iOS 14.0, *)
struct MPSearchBarView: View {
    @Binding var searchText: String
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(Color.accentColor)
                .padding(.leading, 8)
                .opacity(searchText.isEmpty ? 0.5 : 1.0)
            
            TextField("Search Preferences...", text: $searchText)
                .padding(.vertical, 10)
                .transition(.opacity)
            
            if !searchText.isEmpty {
                Button(action: {
                    withAnimation {
                        searchText = ""
                    }
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.secondary)
                }
                .padding(.trailing, 8)
            }
        }
        .background(Color(.systemGray6))
        .cornerRadius(12)
        .padding(.horizontal)
        .padding(.bottom, 5)
    }
}

@available(iOS 14.0, *)
struct MPNoDataView: View {
    let title: String
    let message: String
    
    var body: some View {
        VStack(spacing: 15) {
            Image(systemName: "slider.horizontal.3")
                .resizable()
                .scaledToFit()
                .frame(width: 80, height: 80)
                .foregroundColor(.gray)
                .opacity(0.6)
            
            Text(title)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.secondary)
            
            Text(message)
                .font(.body)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
                .foregroundColor(.gray)
        }
        .padding(.top, 50)
    }
}

@available(iOS 14.0, *)
struct MPAddView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var dataStore: SoupDataStore

    @State private var unitSystem: String = "Metric"
    @State private var decimalPlaces: Int = 2
    @State private var weightUnit: String = "grams"
    @State private var volumeUnit: String = "ml"
    @State private var temperatureUnit: String = "Celsius"
    @State private var pressureUnit: String = "bar"
    @State private var preferredLanguage: String = "English"
    @State private var defaultCurrency: String = "USD"
    @State private var roundingMode: String = "nearest"
    @State private var conversionPrecision: Int = 2
    @State private var autoConvertEnabled: Bool = true
    @State private var showFractionUnits: Bool = false
    @State private var displayAbbreviations: Bool = true
    @State private var fontScale: Double = 1.0
    @State private var theme: String = "System"
    @State private var showTips: Bool = true
    @State private var quickEntryMode: Bool = false
    @State private var includeScientificUnits: Bool = false
    @State private var temperatureDisplayFormat: String = "°C"
    @State private var ingredientSortOption: String = "Alphabetical"
    @State private var recipeDisplayMode: String = "Card"
    @State private var rememberLastChoice: Bool = true
    @State private var vibrationFeedback: Bool = true
    @State private var hapticLevel: Int = 1
    @State private var preferredDateFormat: String = "MM/dd/yyyy"
    @State private var colorScheme: String = "system"
    @State private var accessibilityTextSize: Int = 16
    @State private var highContrastEnabled: Bool = false
    @State private var autoSaveSettings: Bool = true
    @State private var defaultPortionSize: Int = 1
    @State private var useLocalFormatting: Bool = true
    @State private var region: String = "US"
    @State private var backupEnabled: Bool = false
    @State private var appVersion: String = "1.0"
    @State private var developerMode: Bool = false

    @State private var showAlert = false
    @State private var alertMessage = ""
    
    private func validateAndSave() {
        var errors: [String] = []

        if unitSystem.isEmpty { errors.append("Unit System is required.") }
        if weightUnit.isEmpty { errors.append("Weight Unit is required.") }
        if volumeUnit.isEmpty { errors.append("Volume Unit is required.") }
        if temperatureUnit.isEmpty { errors.append("Temperature Unit is required.") }
        if preferredLanguage.isEmpty { errors.append("Preferred Language is required.") }
        if defaultCurrency.isEmpty { errors.append("Default Currency is required.") }
        if roundingMode.isEmpty { errors.append("Rounding Mode is required.") }
        if theme.isEmpty { errors.append("Theme is required.") }
        if temperatureDisplayFormat.isEmpty { errors.append("Temp Format is required.") }
        if ingredientSortOption.isEmpty { errors.append("Sort Option is required.") }
        if recipeDisplayMode.isEmpty { errors.append("Display Mode is required.") }
        if preferredDateFormat.isEmpty { errors.append("Date Format is required.") }
        if colorScheme.isEmpty { errors.append("Color Scheme is required.") }
        if region.isEmpty { errors.append("Region is required.") }
        if appVersion.isEmpty { errors.append("App Version is required.") }
        
        if decimalPlaces < 0 || decimalPlaces > 5 { errors.append("Decimal Places must be 0-5.") }
        if conversionPrecision < 0 || conversionPrecision > 5 { errors.append("Conversion Precision must be 0-5.") }
        if fontScale < 0.5 || fontScale > 3.0 { errors.append("Font Scale must be 0.5-3.0.") }
        if hapticLevel < 1 || hapticLevel > 5 { errors.append("Haptic Level must be 1-5.") }
        if accessibilityTextSize < 10 || accessibilityTextSize > 30 { errors.append("Text Size must be 10-30.") }
        if defaultPortionSize < 1 || defaultPortionSize > 10 { errors.append("Portion Size must be 1-10.") }
        
        if errors.isEmpty {
            let newPref = MeasurementPreference(
                unitSystem: unitSystem,
                decimalPlaces: decimalPlaces,
                weightUnit: weightUnit,
                volumeUnit: volumeUnit,
                temperatureUnit: temperatureUnit,
                pressureUnit: pressureUnit,
                preferredLanguage: preferredLanguage,
                defaultCurrency: defaultCurrency,
                roundingMode: roundingMode,
                conversionPrecision: conversionPrecision,
                autoConvertEnabled: autoConvertEnabled,
                showFractionUnits: showFractionUnits,
                displayAbbreviations: displayAbbreviations,
                fontScale: fontScale,
                theme: theme,
                showTips: showTips,
                quickEntryMode: quickEntryMode,
                includeScientificUnits: includeScientificUnits,
                temperatureDisplayFormat: temperatureDisplayFormat,
                ingredientSortOption: ingredientSortOption,
                recipeDisplayMode: recipeDisplayMode,
                rememberLastChoice: rememberLastChoice,
                vibrationFeedback: vibrationFeedback,
                hapticLevel: hapticLevel,
                preferredDateFormat: preferredDateFormat,
                colorScheme: colorScheme,
                accessibilityTextSize: accessibilityTextSize,
                highContrastEnabled: highContrastEnabled,
                autoSaveSettings: autoSaveSettings,
                defaultPortionSize: defaultPortionSize,
                useLocalFormatting: useLocalFormatting,
                region: region,
                backupEnabled: backupEnabled,
                appVersion: appVersion,
                developerMode: developerMode
            )
            
            dataStore.addMeasurementPref(newPref)
            alertMessage = "Success: New Measurement Preference saved."
            showAlert = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            }
        } else {
            alertMessage = "Validation Failed:\n\n• " + errors.joined(separator: "\n• ")
            showAlert = true
        }
    }

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 25) {
                    
                    MPAddSectionHeader(title: "General & Core Units", iconName: "gearshape.fill")
                    
                    MPFloatingLabelField(text: $unitSystem, title: "Unit System*", iconName: "ruler.fill", isRequired: true)
                    MPFloatingLabelField(text: $weightUnit, title: "Weight Unit*", iconName: "chart.bar", isRequired: true)
                    MPFloatingLabelField(text: $volumeUnit, title: "Volume Unit*", iconName: "drop.fill", isRequired: true)
                    MPFloatingLabelField(text: $temperatureUnit, title: "Temperature Unit*", iconName: "thermometer", isRequired: true)
                    MPFloatingLabelField(text: $pressureUnit, title: "Pressure Unit*", iconName: "gauge", isRequired: true)
                    
                    MPAddSectionHeader(title: "Language & Locale", iconName: "globe")

                    MPFloatingLabelField(text: $preferredLanguage, title: "Language*", iconName: "character.book.fill", isRequired: true)
                    MPFloatingLabelField(text: $defaultCurrency, title: "Currency*", iconName: "dollarsign.circle.fill", isRequired: true)
                    MPFloatingLabelField(text: $region, title: "Region*", iconName: "map.fill", isRequired: true)
                    MPFloatingLabelField(text: $preferredDateFormat, title: "Date Format*", iconName: "calendar", isRequired: true)
                    
                    MPAddToggleField(isOn: $useLocalFormatting, title: "Use Local Formatting", iconName: "textformat")

                    MPAddSectionHeader(title: "Precision & Rounding", iconName: "scalemass.fill")
                    
                    MPAddStepperField(value: $decimalPlaces, title: "Decimal Places*", iconName: "number.circle.fill", unit: "places", range: 0...5)
                    MPAddStepperField(value: $conversionPrecision, title: "Conv. Precision*", iconName: "slider.horizontal.3", unit: "digits", range: 0...5)
                    MPFloatingLabelField(text: $roundingMode, title: "Rounding Mode*", iconName: "arrow.up.arrow.down", isRequired: true)
                    MPAddToggleField(isOn: $includeScientificUnits, title: "Include Scientific Units", iconName: "x.squareroot")

                    MPAddSectionHeader(title: "Display & Aesthetics", iconName: "paintbrush.fill")
                    
                    MPFloatingLabelField(text: $theme, title: "Theme*", iconName: "paintpalette.fill", isRequired: true)
                    MPFloatingLabelField(text: $colorScheme, title: "Color Scheme*", iconName: "circle.lefthalf.fill", isRequired: true)
                    MPFloatingLabelField(text: Binding(
                        get: { String(format: "%.1f", self.fontScale) },
                        set: { if let value = Double($0) { self.fontScale = value } }
                    ), title: "Font Scale (0.5-3.0)*", iconName: "text.cursor", keyboardType: .decimalPad, isRequired: true)
                    MPFloatingLabelField(text: $temperatureDisplayFormat, title: "Temp Display Format*", iconName: "thermometer.sun.fill", isRequired: true)
                    MPAddToggleField(isOn: $displayAbbreviations, title: "Display Abbreviations", iconName: "a.square.fill")
                    MPAddToggleField(isOn: $showFractionUnits, title: "Show Fraction Units", iconName: "divide.circle.fill")
                    MPFloatingLabelField(text: $recipeDisplayMode, title: "Recipe Display Mode*", iconName: "square.grid.2x2", isRequired: true)


                    MPAddSectionHeader(title: "Functionality & Behavior", iconName: "bolt.fill")
                    
                    MPAddToggleField(isOn: $autoConvertEnabled, title: "Auto Convert Units", iconName: "repeat.circle.fill")
                    MPAddToggleField(isOn: $rememberLastChoice, title: "Remember Last Choice", iconName: "lock.fill")
                    MPAddToggleField(isOn: $vibrationFeedback, title: "Vibration Feedback", iconName: "speaker.wave.2.fill")
                    MPAddStepperField(value: $hapticLevel, title: "Haptic Level*", iconName: "waveform.path.ecg", unit: "level", range: 1...5)
                    MPAddToggleField(isOn: $showTips, title: "Show Tips", iconName: "lightbulb.fill")
                    MPAddToggleField(isOn: $quickEntryMode, title: "Quick Entry Mode", iconName: "speedometer")
                    MPFloatingLabelField(text: $ingredientSortOption, title: "Ingredient Sort Option*", iconName: "arrow.up.arrow.down.circle.fill", isRequired: true)
                    
                    MPAddSectionHeader(title: "Accessibility & System", iconName: "person.circle.fill")
                    
                    MPAddStepperField(value: $accessibilityTextSize, title: "Accessibility Text Size*", iconName: "text.magnifyingglass", unit: "pt", range: 10...30)
                    MPAddToggleField(isOn: $highContrastEnabled, title: "High Contrast Enabled", iconName: "circle.lefthalf.filled")
                    MPAddToggleField(isOn: $autoSaveSettings, title: "Auto Save Settings", iconName: "square.and.arrow.down.fill")
                    MPAddStepperField(value: $defaultPortionSize, title: "Default Portion Size*", iconName: "person.3.fill", unit: "serving(s)", range: 1...10)
                    MPFloatingLabelField(text: $appVersion, title: "App Version*", iconName: "tag.fill", isRequired: true)
                    MPAddToggleField(isOn: $backupEnabled, title: "Backup Enabled", iconName: "cloud.fill")
                    MPAddToggleField(isOn: $developerMode, title: "Developer Mode", iconName: "hammer.fill")
                    
                    Button(action: validateAndSave) {
                        Text("Save Preference")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.accentColor.opacity(0.85))
                            .cornerRadius(15)
                            .shadow(radius: 5)
                            .padding()
                    }
                }
                .padding(.top, 10)
            }
            .navigationTitle("New Preferences")
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Preference Status"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
        }
        .accentColor(.green)
    }
}

@available(iOS 14.0, *)
struct MPListRowView: View {
    let preference: MeasurementPreference
    
    private func formattedValue(_ label: String, _ value: String, icon: String, color: Color = .gray) -> some View {
        HStack(spacing: 4) {
            Image(systemName: icon)
                .font(.system(size: 10, weight: .bold))
                .foregroundColor(.white)
            Text(value)
                .font(.caption2)
                .fontWeight(.semibold)
                .foregroundColor(.white)
        }
        .padding(.horizontal, 6)
        .padding(.vertical, 3)
        .background(color.opacity(0.7))
        .cornerRadius(6)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            
            // MARK: Header Section
            HStack(alignment: .center) {
                Image(systemName: "ruler.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 35, height: 35)
                    .foregroundColor(.orange)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(preference.unitSystem.uppercased())
                        .font(.headline)
                        .fontWeight(.heavy)
                        .foregroundColor(.primary)
                    
                    Text("Theme: \(preference.theme) • Lang: \(preference.preferredLanguage)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .lineLimit(1)
                }
                Spacer()
                
                VStack(spacing: 3) {
                    Text("\(String(format: "%.1f", preference.fontScale))x")
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(.orange)
                    Text("Font Scale")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
            }
            .padding([.horizontal, .top], 15)
            
            Divider()
                .padding(.horizontal)
            
            // MARK: Units Section
            VStack(alignment: .leading, spacing: 8) {
                Text("Units & Format")
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(.secondary)
                
                HStack(spacing: 8) {
                    formattedValue("Weight", preference.weightUnit, icon: "scalemass", color: .orange)
                    formattedValue("Volume", preference.volumeUnit, icon: "drop.fill", color: .blue)
                    formattedValue("Temp", "\(preference.temperatureUnit)", icon: "thermometer", color: .red)
                    formattedValue("Pressure", preference.pressureUnit, icon: "gauge.medium", color: .purple)
                    formattedValue("Currency", preference.defaultCurrency, icon: "dollarsign.circle.fill", color: .green)
                }
                
                HStack(spacing: 8) {
                    formattedValue("Region", preference.region, icon: "map.fill", color: .yellow)
                    formattedValue("Format", preference.preferredDateFormat, icon: "calendar", color: .blue)
                    formattedValue("Abbrev", preference.displayAbbreviations ? "On" : "Off", icon: "textformat", color: .gray)
                    formattedValue("Fractions", preference.showFractionUnits ? "Yes" : "No", icon: "divide", color: .green)
                    formattedValue("Decimals", "\(preference.decimalPlaces)", icon: "ruler", color: .orange)
                }
            }
            .padding(.horizontal, 15)
            
            // MARK: Conversion & Behavior Section
            VStack(alignment: .leading, spacing: 8) {
                Text("Conversion & Behavior")
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(.secondary)
                
                HStack(spacing: 8) {
                    formattedValue("AutoConvert", preference.autoConvertEnabled ? "Yes" : "No", icon: "arrow.2.circlepath", color: .green)
                    formattedValue("Precision", "\(preference.conversionPrecision)", icon: "slider.horizontal.3", color: .pink)
                    formattedValue("Rounding", preference.roundingMode, icon: "arrow.triangle.2.circlepath", color: .orange)
                    formattedValue("Haptic", "Lvl \(preference.hapticLevel)", icon: "speaker.wave.3", color: .blue)
                    formattedValue("Tips", preference.showTips ? "Yes" : "No", icon: "lightbulb.fill", color: .yellow)
                }
                
                HStack(spacing: 8) {
                    formattedValue("QuickEntry", preference.quickEntryMode ? "On" : "Off", icon: "bolt.fill", color: .orange)
                    formattedValue("Scientific", preference.includeScientificUnits ? "Yes" : "No", icon: "atom", color: .purple)
                    formattedValue("Sort", preference.ingredientSortOption, icon: "arrow.up.arrow.down", color: .blue)
                    formattedValue("Remember", preference.rememberLastChoice ? "Yes" : "No", icon: "bookmark", color: .purple)
                    formattedValue("Vibration", preference.vibrationFeedback ? "Yes" : "No", icon: "waveform", color: .pink)
                }
            }
            .padding(.horizontal, 15)
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Display & Accessibility")
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(.secondary)
                
                HStack(spacing: 8) {
                    formattedValue("Contrast", preference.highContrastEnabled ? "High" : "Normal", icon: "circle.lefthalf.filled", color: .gray)
                    formattedValue("Text Size", "\(preference.accessibilityTextSize)pt", icon: "textformat.size", color: .orange)
                    formattedValue("ColorScheme", preference.colorScheme, icon: "paintpalette.fill", color: .purple)
                    formattedValue("LocalFmt", preference.useLocalFormatting ? "Yes" : "No", icon: "globe", color: .blue)
                    formattedValue("AutoSave", preference.autoSaveSettings ? "Yes" : "No", icon: "tray.and.arrow.down", color: .green)
                }
            }
            .padding(.horizontal, 15)
            
            VStack(alignment: .leading, spacing: 8) {
                Text("System Info")
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(.secondary)
                
                HStack(spacing: 8) {
                    formattedValue("Backup", preference.backupEnabled ? "Yes" : "No", icon: "icloud.fill", color: .orange)
                    formattedValue("Portion", "\(preference.defaultPortionSize)", icon: "person.3", color: .orange)
                    formattedValue("Version", preference.appVersion, icon: "info.circle", color: .gray)
                    formattedValue("Developer", preference.developerMode ? "On" : "Off", icon: "hammer.fill", color: .red)
                    formattedValue("Updated", preference.lastUpdated?.formattedDate() ?? "N/A", icon: "clock", color: .green)
                }
            }
            .padding([.horizontal, .bottom], 15)
        }
        .background(Color(.systemBackground))
        .cornerRadius(20)
        .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 4)
        .padding(.horizontal, 10)
    }
}

extension Date {
    func formattedDate() -> String {
        let df = DateFormatter()
        df.dateStyle = .medium
        df.timeStyle = .none
        return df.string(from: self)
    }
}

@available(iOS 14.0, *)
struct MPListView: View {
    @ObservedObject var dataStore: SoupDataStore
    @State private var searchText: String = ""
    
    var filteredPreferences: [MeasurementPreference] {
        if searchText.isEmpty {
            return dataStore.measurementPrefs
        } else {
            return dataStore.measurementPrefs.filter { pref in
                pref.unitSystem.localizedCaseInsensitiveContains(searchText) ||
                pref.preferredLanguage.localizedCaseInsensitiveContains(searchText) ||
                pref.theme.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    var body: some View {
            VStack(spacing: 0) {
                MPSearchBarView(searchText: $searchText)
                
                if filteredPreferences.isEmpty {
                    MPNoDataView(title: "No Preferences Found", message: "Try adjusting your search filters or add a new preference to get started.")
                } else {
                    List {
                        ForEach(filteredPreferences) { preference in
                            NavigationLink(destination: MPDetailView(preference: preference)) {
                                MPListRowView(preference: preference)
                                    .padding(.vertical, 5)
                            }
                            .listRowBackground(Color.clear)
                            .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                        }
                        .onDelete(perform: deletePreference)
                    }
                    .listStyle(PlainListStyle())
                }
            }
            .navigationTitle("Settings Profiles")
            .navigationBarItems(trailing:
                                    NavigationLink(destination: MPAddView(dataStore : dataStore)) {
                    Image(systemName: "plus.circle.fill")
                        .font(.title2)
                        .foregroundColor(.orange)
                }
            )
        
        .accentColor(.orange)
    }
    
    func deletePreference(at offsets: IndexSet) {
        for index in offsets {
            if let originalIndex = dataStore.measurementPrefs.firstIndex(where: { $0.id == filteredPreferences[index].id }) {
                dataStore.deleteMeasurementPref(at: IndexSet(integer: originalIndex))
            }
        }
    }
}

@available(iOS 14.0, *)
struct MPDetailView: View {
    let preference: MeasurementPreference
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 25) {
                
                VStack(spacing: 8) {
                    Image(systemName: "gauge.with.dots.needle.bottom.50percent")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 60, height: 60)
                        .foregroundColor(.blue)
                        .padding(.top, 10)
                    
                    Text("Measurement Preferences")
                        .font(.title3)
                        .fontWeight(.bold)
                    
                    if let date = preference.lastUpdated {
                        Text("Last updated: \(DateFormatter.shortDateTime.string(from: date))")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.bottom, 10)
                
                // MARK: - Units & Precision
                MPSectionCard(title: "Units & Precision", icon: "ruler.fill", color: .orange) {
                    MPDetailFieldRow(label: "Unit System", value: preference.unitSystem, icon: "ruler")
                    MPDetailFieldRow(label: "Weight Unit", value: preference.weightUnit, icon: "scalemass")
                    MPDetailFieldRow(label: "Volume Unit", value: preference.volumeUnit, icon: "drop")
                    MPDetailFieldRow(label: "Temperature Unit", value: preference.temperatureUnit, icon: "thermometer")
                    MPDetailFieldRow(label: "Pressure Unit", value: preference.pressureUnit, icon: "gauge")
                    MPDetailFieldRow(label: "Temp Format", value: preference.temperatureDisplayFormat, icon: "thermometer.sun.fill")
                    MPDetailFieldRow(label: "Decimal Places", value: "\(preference.decimalPlaces)", icon: "number")
                    MPDetailFieldRow(label: "Conversion Precision", value: "\(preference.conversionPrecision)", icon: "slider.horizontal.3")
                    MPDetailFieldRow(label: "Rounding Mode", value: preference.roundingMode, icon: "arrow.triangle.merge")
                }
                
                // MARK: - Display & Formatting
                MPSectionCard(title: "Display & Formatting", icon: "textformat.size.larger", color: .purple) {
                    MPDetailFieldRow(label: "Font Scale", value: String(format: "%.1f", preference.fontScale), icon: "textformat.size")
                    MPDetailFieldRow(label: "Accessibility Text Size", value: "\(preference.accessibilityTextSize)", icon: "a.circle.fill")
                    MPDetailFieldRow(label: "High Contrast", value: preference.highContrastEnabled ? "Enabled" : "Disabled", icon: preference.highContrastEnabled ? "eye.fill" : "eye.slash")
                    MPDetailFieldRow(label: "Display Abbreviations", value: preference.displayAbbreviations ? "Yes" : "No", icon: "character.textbox")
                    MPDetailFieldRow(label: "Color Scheme", value: preference.colorScheme, icon: "paintpalette.fill")
                    MPDetailFieldRow(label: "Theme", value: preference.theme, icon: "moon.circle.fill")
                    MPDetailFieldRow(label: "Preferred Date Format", value: preference.preferredDateFormat, icon: "calendar")
                    MPDetailFieldRow(label: "Default Currency", value: preference.defaultCurrency, icon: "dollarsign.circle")
                    MPDetailFieldRow(label: "Use Local Formatting", value: preference.useLocalFormatting ? "Yes" : "No", icon: "globe")
                }
                
                // MARK: - Functional Behavior
                MPSectionCard(title: "Functional Behavior", icon: "gearshape.fill", color: .green) {
                    MPDetailFieldRow(label: "Auto Convert", value: preference.autoConvertEnabled ? "Enabled" : "Disabled", icon: preference.autoConvertEnabled ? "checkmark.circle.fill" : "xmark.circle.fill")
                    MPDetailFieldRow(label: "Scientific Units", value: preference.includeScientificUnits ? "Yes" : "No", icon: "x.squareroot")
                    MPDetailFieldRow(label: "Show Fraction Units", value: preference.showFractionUnits ? "Yes" : "No", icon: "divide.circle")
                    MPDetailFieldRow(label: "Quick Entry Mode", value: preference.quickEntryMode ? "Enabled" : "Disabled", icon: "bolt.fill")
                    MPDetailFieldRow(label: "Remember Last Choice", value: preference.rememberLastChoice ? "Yes" : "No", icon: "clock.arrow.circlepath")
                    MPDetailFieldRow(label: "Auto Save Settings", value: preference.autoSaveSettings ? "Enabled" : "Disabled", icon: "externaldrive.badge.checkmark")
                    MPDetailFieldRow(label: "Backup Enabled", value: preference.backupEnabled ? "Yes" : "No", icon: "icloud.and.arrow.up.fill")
                    MPDetailFieldRow(label: "Developer Mode", value: preference.developerMode ? "Active" : "Off", icon: "terminal.fill")
                }
                
                // MARK: - User & Regional Settings
                MPSectionCard(title: "User & Regional Settings", icon: "person.crop.circle.badge.exclamationmark", color: .blue) {
                    MPDetailFieldRow(label: "Preferred Language", value: preference.preferredLanguage, icon: "globe")
                    MPDetailFieldRow(label: "Region", value: preference.region, icon: "map.fill")
                    MPDetailFieldRow(label: "Default Portion Size", value: "\(preference.defaultPortionSize)", icon: "takeoutbag.and.cup.and.straw.fill")
                    MPDetailFieldRow(label: "Ingredient Sort Option", value: preference.ingredientSortOption, icon: "line.3.horizontal.decrease.circle")
                    MPDetailFieldRow(label: "Recipe Display Mode", value: preference.recipeDisplayMode, icon: "book.fill")
                }
                
                // MARK: - Haptics & Feedback
                MPSectionCard(title: "Haptics & Feedback", icon: "waveform.path.ecg", color: .pink) {
                    MPDetailFieldRow(label: "Vibration Feedback", value: preference.vibrationFeedback ? "Enabled" : "Disabled", icon: preference.vibrationFeedback ? "iphone.radiowaves.left.and.right" : "iphone.slash")
                    MPDetailFieldRow(label: "Haptic Level", value: "\(preference.hapticLevel)", icon: "waveform.circle.fill")
                    MPDetailFieldRow(label: "Show Tips", value: preference.showTips ? "Enabled" : "Disabled", icon: "lightbulb.fill")
                }
                
                // MARK: - System Info
                MPSectionCard(title: "System Info", icon: "cpu.fill", color: .gray) {
                    MPDetailFieldRow(label: "App Version", value: preference.appVersion, icon: "app.badge")
                    if let lastUpdated = preference.lastUpdated {
                        MPDetailFieldRow(label: "Last Updated", value: DateFormatter.shortDateTime.string(from: lastUpdated), icon: "calendar.badge.clock")
                    }
                }
            }
            .padding()
        }
        .navigationTitle("Profile Details")
        .navigationBarTitleDisplayMode(.inline)
        .background(Color(.systemGroupedBackground))
    }
}

// MARK: - Section Card Helper
@available(iOS 14.0, *)
struct MPSectionCard<Content: View>: View {
    let title: String
    let icon: String
    let color: Color
    let content: Content
    
    init(title: String, icon: String, color: Color, @ViewBuilder content: () -> Content) {
        self.title = title
        self.icon = icon
        self.color = color
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(color)
                Text(title)
                    .font(.headline)
                    .fontWeight(.bold)
            }
            Divider()
            VStack(alignment: .leading, spacing: 6) {
                content
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(15)
        .shadow(color: Color.black.opacity(0.08), radius: 6, x: 0, y: 3)
    }
}

