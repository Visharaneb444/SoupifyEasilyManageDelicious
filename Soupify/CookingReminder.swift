
import SwiftUI
import Foundation
import Combine

@available(iOS 14.0, *)
extension Color {
    static let reminderPrimary = Color(red: 0.1, green: 0.5, blue: 0.9)
    static let reminderAccent = Color(red: 0.95, green: 0.7, blue: 0.2)
    static let reminderBackground = Color(.systemGroupedBackground)
    static let cardBackground = Color(.systemBackground)
}

@available(iOS 14.0, *)
extension DateFormatter {
    static let shortDateTime: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter
    }()
}

@available(iOS 14.0, *)
enum CookingReminderRepeatDay: String, CaseIterable, Identifiable {
    case mon = "Monday"
    case tue = "Tuesday"
    case wed = "Wednesday"
    case thu = "Thursday"
    case fri = "Friday"
    case sat = "Saturday"
    case sun = "Sunday"
    
    var id: String { self.rawValue }
    
    var shortName: String {
        switch self {
        case .mon: return "M"
        case .tue: return "T"
        case .wed: return "W"
        case .thu: return "Th"
        case .fri: return "F"
        case .sat: return "Sa"
        case .sun: return "Su"
        }
    }
}

@available(iOS 14.0, *)
struct CookingReminderFloatingTextField: View {
    let title: String
    let iconName: String
    @Binding var text: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack(spacing: 8) {
                Image(systemName: iconName)
                    .foregroundColor(.reminderPrimary)
                    .frame(width: 20)
                
                TextField("", text: $text)
                    .padding(.vertical, 10)
                    .foregroundColor(Color.primary)
            }
            .padding(.horizontal)
            .background(Color.cardBackground)
            .cornerRadius(12)
            .shadow(color: Color.black.opacity(0.05), radius: 3, x: 0, y: 3)
            .overlay(
                Text(title)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .padding(.horizontal, 8)
                    .background(Color.cardBackground)
                    .offset(x: 30, y: text.isEmpty ? 0 : -25)
                    .animation(.spring(), value: text.isEmpty)
                , alignment: .topLeading
            )
        }
    }
}


@available(iOS 14.0, *)
struct CookingReminderAddSectionHeaderView: View {
    let title: String
    let iconName: String
    
    var body: some View {
        HStack {
            Image(systemName: iconName)
                .font(.title3)
                .foregroundColor(.reminderAccent)
            Text(title)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.primary)
            Spacer()
        }
        .padding(.top, 10)
        .padding(.horizontal)
    }
}

@available(iOS 14.0, *)
struct CookingReminderRepeatDaysPicker: View {
    @Binding var repeatDays: [String]
    
    let allDays: [CookingReminderRepeatDay] = CookingReminderRepeatDay.allCases
    
    func toggleDay(_ day: CookingReminderRepeatDay) {
        if let index = repeatDays.firstIndex(of: day.rawValue) {
            repeatDays.remove(at: index)
        } else {
            repeatDays.append(day.rawValue)
        }
    }
    
    func isSelected(_ day: CookingReminderRepeatDay) -> Bool {
        repeatDays.contains(day.rawValue)
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Repeat Days")
                .font(.headline)
                .foregroundColor(.secondary)
            
            HStack(spacing: 8) {
                ForEach(allDays) { day in
                    Text(day.shortName)
                        .font(.caption)
                        .fontWeight(.bold)
                        .frame(width: 24, height: 24)
                        .background(
                            Circle()
                                .fill(self.isSelected(day) ? Color.reminderPrimary : Color.clear)
                                .overlay(
                                    Circle().stroke(Color.secondary.opacity(0.5), lineWidth: 1)
                                )
                        )
                        .foregroundColor(self.isSelected(day) ? Color.white : Color.secondary)
                        .onTapGesture {
                            self.toggleDay(day)
                        }
                }
                Spacer()
            }
            .padding(.vertical, 8)
        }
        .padding()
        .background(Color.cardBackground)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 3, x: 0, y: 3)
    }
}

@available(iOS 14.0, *)
struct CookingReminderAddToggle: View {
    let title: String
    let iconName: String
    @Binding var isOn: Bool
    
    var body: some View {
        HStack {
            Image(systemName: iconName)
                .foregroundColor(.reminderPrimary)
                .frame(width: 20)
            Text(title)
                .foregroundColor(.primary)
            Spacer()
            Toggle("", isOn: $isOn)
                .labelsHidden()
        }
        .padding()
        .background(Color.cardBackground)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 3, x: 0, y: 3)
    }
}

@available(iOS 14.0, *)
struct CookingReminderAddView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var dataStore: SoupDataStore
    
    @State private var recipeId: String = UUID().uuidString
    @State private var title: String = ""
    @State private var fireDate: Date = Date().addingTimeInterval(3600)
    @State private var repeatIntervalMinutes: String = ""
    @State private var isActive: Bool = true
    @State private var reminderMessage: String = ""
    @State private var soundName: String = "Default"
    @State private var vibrationEnabled: Bool = true
    @State private var alertType: String = "Standard"
    @State private var snoozeMinutes: String = "10"
    @State private var repeatDays: [String] = []
    @State private var isPersistent: Bool = false
    @State private var priorityLevel: String = "Medium"
    @State private var reminderCategory: String = "Cooking"
    @State private var recipeName: String = ""
    @State private var durationMinutes: String = "30"
    @State private var colorCode: String = "blue"
    @State private var iconName: String = "bell.fill"
    @State private var showOnLockScreen: Bool = true
    @State private var isSilent: Bool = false
    @State private var autoDeleteAfterTrigger: Bool = true
    @State private var isRecurring: Bool = false
    @State private var kitchenZone: String = "Stovetop"
    @State private var assignedUser: String = "Self"
    @State private var displayOrder: String = "1"
    @State private var locationContext: String = "Home Kitchen"
    @State private var notes: String = ""
    @State private var completed: Bool = false
    
    // 5 Extended fields
    @State private var recipeCategory: String = "Soup"
    @State private var mealType: String = "Lunch"
    @State private var cuisineType: String = "Italian"
    @State private var temperatureSetting: String = "Medium Heat"
    @State private var cookingTool: String = "Saucepan"
    
    // Alerts
    @State private var showingAlert = false
    @State private var alertMessage = ""
    @State private var alertTitle = ""
    
    // MARK: - Constants for Pickers
    let priorityLevels = ["Low", "Medium", "High", "Critical"]
    let kitchenZones = ["Stovetop", "Oven", "Prep Area", "Fridge/Freezer"]
    let alertTypes = ["Standard", "Critical Alert", "Banner"]
    let reminderCategories = ["Cooking", "Baking", "Meal Prep"]

    // MARK: - Validation
    private var isFormValid: (Bool, [String]) {
        var errors: [String] = []
        if title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            errors.append("Title cannot be empty.")
        }
        if recipeName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            errors.append("Recipe Name cannot be empty.")
        }
        if Int(repeatIntervalMinutes) == nil && !repeatIntervalMinutes.isEmpty {
            errors.append("Repeat Interval must be a number.")
        }
        if Int(snoozeMinutes) == nil {
            errors.append("Snooze Minutes must be a number.")
        }
        if Int(durationMinutes) == nil {
            errors.append("Duration Minutes must be a number.")
        }
        if Int(displayOrder) == nil {
            errors.append("Display Order must be a number.")
        }
        return (errors.isEmpty, errors)
    }
    
    // MARK: - Save Logic
    private func saveReminder() {
        let (isValid, errors) = isFormValid
        
        if isValid {
            let duration = Int(durationMinutes) ?? 30
            let estimatedCompletion = fireDate.addingTimeInterval(Double(duration) * 60)
            
            let reminder = CookingReminder(
                recipeId: UUID(uuidString: recipeId) ?? UUID(),
                title: title,
                fireDate: fireDate,
                repeatIntervalMinutes: Int(repeatIntervalMinutes),
                isActive: isActive,
                reminderMessage: reminderMessage,
                soundName: soundName,
                vibrationEnabled: vibrationEnabled,
                alertType: alertType,
                snoozeMinutes: Int(snoozeMinutes) ?? 10,
                repeatDays: repeatDays,
                isPersistent: isPersistent,
                priorityLevel: priorityLevel,
                reminderCategory: reminderCategory,
                recipeName: recipeName,
                durationMinutes: duration,
                estimatedCompletion: estimatedCompletion,
                colorCode: colorCode,
                iconName: iconName,
                showOnLockScreen: showOnLockScreen,
                isSilent: isSilent,
                autoDeleteAfterTrigger: autoDeleteAfterTrigger,
                linkedTimerId: nil,
                isRecurring: isRecurring,
                startCookingTime: fireDate,
                endCookingTime: nil,
                kitchenZone: kitchenZone,
                assignedUser: assignedUser,
                displayOrder: Int(displayOrder) ?? 1,
                locationContext: locationContext,
                notes: notes,
                completed: completed
            )

            dataStore.addReminder(reminder)
            alertTitle = "Reminder Saved"
            alertMessage = "✅ Success! The reminder '\(title)' has been saved."
        } else {
            alertTitle = "Validation Error"
            alertMessage = "Please correct the following:\n\n" + errors.joined(separator: "\n")
        }
        showingAlert = true
    }
    
    // MARK: - View
    var body: some View {
        NavigationView {
            Form {
                // --- Core Reminder Details ---
                Section(header: Text("Core Details")) {
                    TextField("Title (e.g., 'Stir Soup')", text: $title)
                    TextField("Recipe Name (e.g., 'Tomato Soup')", text: $recipeName)
                    DatePicker("Start Time", selection: $fireDate)
                    TextField("Duration (minutes)", text: $durationMinutes)
                        .keyboardType(.numberPad)
                    Toggle("Active", isOn: $isActive)
                    Toggle("Recurring", isOn: $isRecurring)
                }

                // --- Cooking Specifics ---
                Section(header: Text("Cooking Specifics")) {
                    TextField("Recipe Category", text: $recipeCategory)
                    TextField("Meal Type", text: $mealType)
                    TextField("Cuisine Type", text: $cuisineType)
                    TextField("Temperature Setting", text: $temperatureSetting)
                    TextField("Cooking Tool", text: $cookingTool)
                    
                    Picker("Kitchen Zone", selection: $kitchenZone) {
                        ForEach(kitchenZones, id: \.self) {
                            Text($0)
                        }
                    }
                }
                
                // --- Advanced Settings ---
                Section(header: Text("Advanced Settings")) {
                    Picker("Priority", selection: $priorityLevel) {
                        ForEach(priorityLevels, id: \.self) {
                            Text($0)
                        }
                    }
                    
                    TextField("Reminder Message", text: $reminderMessage)
                    
                    Toggle("Vibration", isOn: $vibrationEnabled)
                    Toggle("Silent (No Sound)", isOn: $isSilent)
                    TextField("Snooze (minutes)", text: $snoozeMinutes)
                        .keyboardType(.numberPad)
                }
                
                // --- Metadata & Notes ---
                Section(header: Text("Metadata & Notes")) {
                    TextEditor(text: $notes)
                        .frame(height: 100)
                        .overlay(
                            Text(notes.isEmpty ? "Additional notes..." : "")
                                .foregroundColor(.gray)
                                .padding(.all, 8)
                                .opacity(notes.isEmpty ? 1 : 0),
                            alignment: .topLeading
                        )
                    
                    TextField("Location Context", text: $locationContext)
                    TextField("Assigned User", text: $assignedUser)
                }
                
                // --- Save Button ---
                Section {
                    Button(action: saveReminder) {
                        Text("SAVE NEW REMINDER")
                            .font(.headline)
                            .fontWeight(.heavy)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.blue)
                            .cornerRadius(10)
                    }
                    .listRowInsets(EdgeInsets()) // Removes default padding for the button
                }
            }
            .navigationTitle("Add Cooking Reminder")
            .alert(isPresented: $showingAlert) {
                Alert(
                    title: Text(alertTitle),
                    message: Text(alertMessage),
                    dismissButton: .default(Text("OK")) {
                        if alertTitle == "Reminder Saved" {
                            presentationMode.wrappedValue.dismiss()
                        }
                    }
                )
            }
        }
    }
}


@available(iOS 14.0, *)
struct CookingReminderListRowView: View {
    let reminder: CookingReminder
    
    private func dateText(_ date: Date?) -> String {
        if let date = date {
            return DateFormatter.shortDateTime.string(from: date)
        }
        return "N/A"
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            
            // MARK: Header Section
            HStack(alignment: .top, spacing: 10) {
                Image(systemName: reminder.iconName)
                    .font(.title)
                    .foregroundColor(.reminderAccent)
                    .padding(6)
                    .background(Color.reminderPrimary.opacity(0.1))
                    .cornerRadius(10)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(reminder.title)
                        .font(.headline)
                        .fontWeight(.bold)
                    
                    Text("Recipe: \(reminder.recipeName)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    Text(reminder.reminderMessage)
                        .font(.caption)
                        .foregroundColor(.gray)
                        .lineLimit(1)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 6) {
                    Text(reminder.priorityLevel.uppercased())
                        .font(.caption2)
                        .fontWeight(.bold)
                        .padding(.vertical, 4)
                        .padding(.horizontal, 8)
                        .background(Color.reminderPrimary.opacity(0.15))
                        .cornerRadius(6)
                        .foregroundColor(.reminderPrimary)
                    
                    Image(systemName: reminder.isActive ? "bell.fill" : "bell.slash.fill")
                        .foregroundColor(reminder.isActive ? .green : .red)
                }
            }
            
            Divider()
            
            // MARK: Schedule Section
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Label("\(DateFormatter.shortDateTime.string(from: reminder.fireDate))", systemImage: "clock.fill")
                    Spacer()
                    Label("\(reminder.durationMinutes) min", systemImage: "timer")
                }
                .font(.subheadline)
                
                HStack {
                    Label("Zone: \(reminder.kitchenZone)", systemImage: "location.fill")
                    Spacer()
                    Label("Snooze: \(reminder.snoozeMinutes)m", systemImage: "zzz")
                }
                .font(.subheadline)
            }
            .foregroundColor(.primary)
            
            VStack(alignment: .leading, spacing: 6) {
                HStack(spacing: 6) {
                    CookingReminderTag(text: reminder.isRecurring ? "RECURRING" : "ONE-TIME",
                                       color: Color.purple.opacity(0.1), textColor: .purple)
                    
                    if reminder.vibrationEnabled {
                        CookingReminderTag(text: "VIBRATE", color: Color.red.opacity(0.1), textColor: .orange)
                    }
                    
                    if reminder.isSilent {
                        CookingReminderTag(text: "SILENT", color: Color.gray.opacity(0.1), textColor: .gray)
                    }
                    
                    if reminder.repeatDays.count > 0 {
                        CookingReminderTag(text: "\(reminder.repeatDays.count) DAYS",
                                           color: Color.yellow.opacity(0.1), textColor: .green)
                    }
                    
                    if reminder.autoDeleteAfterTrigger {
                        CookingReminderTag(text: "AUTO DELETE", color: Color.red.opacity(0.1), textColor: .red)
                    }
                }
            }
            
            Divider()
            
            VStack(alignment: .leading, spacing: 4) {
                HStack(spacing: 12) {
                    Label("Created: \(dateText(reminder.createdAt))", systemImage: "calendar.badge.clock")
                    Spacer()
                    if let updated = reminder.updatedAt {
                        Label("Updated: \(dateText(updated))", systemImage: "pencil.circle")
                    }
                }
                .font(.caption)
                .foregroundColor(.gray)
                
                HStack(spacing: 12) {
                    Label("User: \(reminder.assignedUser)", systemImage: "person.fill")
                    Spacer()
                    Label("Order: #\(reminder.displayOrder)", systemImage: "list.number")
                }
                .font(.caption)
                .foregroundColor(.gray)
                
                HStack(spacing: 12) {
                    Label("Category: \(reminder.reminderCategory)", systemImage: "tag.fill")
                    Spacer()
                    Label("Sound: \(reminder.soundName)", systemImage: "speaker.wave.2.fill")
                }
                .font(.caption)
                .foregroundColor(.gray)
                
                HStack(spacing: 12) {
                    Label("Location: \(reminder.locationContext)", systemImage: "mappin.and.ellipse")
                    Spacer()
                    Label("Zone: \(reminder.kitchenZone)", systemImage: "flame.fill")
                }
                .font(.caption)
                .foregroundColor(.gray)
                
                if !reminder.notes.isEmpty {
                    Text("📝 \(reminder.notes)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .lineLimit(2)
                }
            }
        }
        .padding()
        .background(Color.cardBackground)
        .cornerRadius(15)
        .shadow(color: Color.black.opacity(0.08), radius: 8, x: 0, y: 3)
        .padding(.horizontal, 10)
        .padding(.vertical, 6)
    }
}


@available(iOS 14.0, *)
struct CookingReminderTag: View {
    var text: String
    var color: Color
    var textColor: Color
    
    var body: some View {
        Text(text)
            .font(.caption2)
            .fontWeight(.semibold)
            .padding(.vertical, 4)
            .padding(.horizontal, 8)
            .background(color)
            .cornerRadius(6)
            .foregroundColor(textColor)
    }
}

@available(iOS 14.0, *)
struct CookingReminderSearchBarView: View {
    @Binding var searchText: String
    @State private var isEditing: Bool = false
    
    var body: some View {
        HStack {
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.secondary)
                
                TextField("Search Reminders...", text: $searchText, onEditingChanged: { isEditing = $0 })
                    .foregroundColor(.primary)
                
                if isEditing || !searchText.isEmpty {
                    Button(action: {
                        self.searchText = ""
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.gray)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .padding(EdgeInsets(top: 8, leading: 6, bottom: 8, trailing: 6))
            .background(Color(.secondarySystemGroupedBackground))
            .cornerRadius(10)
            .animation(.easeInOut, value: isEditing)
            .padding(.horizontal, 10)
            
            if isEditing {
                Button(action: {
                    self.searchText = ""
                    UIApplication.shared.endEditing()
                    self.isEditing = false
                }) {
                    Text("Cancel")
                        .foregroundColor(.reminderPrimary)
                }
                .transition(.move(edge: .trailing).combined(with: .opacity))
            }
        }
        .padding(.horizontal, 5)
    }
}

@available(iOS 14.0, *)
extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

@available(iOS 14.0, *)
struct CookingReminderNoDataView: View {
    let message: String
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "bell.slash.fill")
                .font(.system(size: 80))
                .foregroundColor(Color.gray.opacity(0.4))
            
            Text("No Reminders Found")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.secondary)
            
            Text(message)
                .font(.body)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
        }
        .padding(.top, 50)
        .frame(maxWidth: .infinity)
    }
}

@available(iOS 14.0, *)
struct CookingReminderListView: View {
    @ObservedObject var dataStore: SoupDataStore
    @State private var searchText: String = ""
    @State private var showingAddView = false
    
    var filteredReminders: [CookingReminder] {
        if searchText.isEmpty {
            return dataStore.reminders.sorted { $0.fireDate < $1.fireDate }
        } else {
            return dataStore.reminders.filter {
                $0.title.localizedCaseInsensitiveContains(searchText) ||
                $0.recipeName.localizedCaseInsensitiveContains(searchText)
            }
            .sorted { $0.fireDate < $1.fireDate }
        }
    }
    
    var body: some View {
            ZStack {
                Color.reminderBackground.edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 0) {
                    CookingReminderSearchBarView(searchText: $searchText)
                        .padding(.vertical, 10)
                    
                    if filteredReminders.isEmpty {
                        CookingReminderNoDataView(
                            message: searchText.isEmpty ?
                            "You haven't set any cooking reminders yet. Tap the '+' to get started!" :
                            "No reminders match your search criteria: '\(searchText)'."
                        )
                        Spacer()
                    } else {
                        List {
                            ForEach(filteredReminders) { reminder in
                                NavigationLink(destination: CookingReminderDetailView(reminder: reminder)) {
                                    CookingReminderListRowView(reminder: reminder)
                                }
                                .listRowInsets(EdgeInsets())
                                .listRowBackground(Color.reminderBackground)
                            }
                            .onDelete(perform: deleteReminder)
                        }
                        .listStyle(PlainListStyle())
                        .id(UUID())
                    }
                }
                .navigationTitle("Reminders")
                .toolbar {
                    Button(action: {
                        showingAddView = true
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .font(.title)
                            .foregroundColor(.reminderPrimary)
                    }
                }
                .sheet(isPresented: $showingAddView) {
                    NavigationView {
                        CookingReminderAddView(dataStore : dataStore)
                    }
                }
            }
        
    }
    
    func deleteReminder(at offsets: IndexSet) {
        let remindersToDelete = offsets.map { filteredReminders[$0] }
        dataStore.reminders.removeAll { reminder in
            remindersToDelete.contains(where: { $0.id == reminder.id })
        }
    }
}

@available(iOS 14.0, *)
struct CookingReminderDetailFieldRow: View {
    let label: String
    let value: String
    let iconName: String
    
    var body: some View {
        HStack(alignment: .top) {
            HStack(spacing: 8) {
                Image(systemName: iconName)
                    .foregroundColor(.reminderPrimary)
                    .frame(width: 20)
                Text(label)
                    .font(.callout)
                    .fontWeight(.medium)
                    .foregroundColor(.secondary)
            }
            Spacer()
            Text(value)
                .font(.callout)
                .fontWeight(.regular)
                .foregroundColor(.primary)
                .multilineTextAlignment(.trailing)
        }
        .padding(.vertical, 8)
    }
}

@available(iOS 14.0, *)
extension CookingReminderDetailFieldRow {
    
    init(label: String, value: Date?, format: DateFormatter, iconName: String) {
        self.label = label
        self.iconName = iconName
        self.value = value.map { format.string(from: $0) } ?? "N/A"
    }
    
    init(label: String, value: String?, iconName: String) {
        self.label = label
        self.iconName = iconName
        self.value = value ?? "N/A"
    }
    
    init(label: String, value: Date, format: DateFormatter, iconName: String) {
        self.label = label
        self.iconName = iconName
        self.value = format.string(from: value)
    }
}

@available(iOS 14.0, *)
struct CookingReminderDetailHeader: View {
    let reminder: CookingReminder
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Image(systemName: reminder.iconName)
                    .font(.largeTitle)
                    .foregroundColor(.white)
                
                Spacer()
                
                Text(reminder.priorityLevel)
                    .font(.headline)
                    .fontWeight(.heavy)
                    .padding(8)
                    .background(Color.white.opacity(0.2))
                    .cornerRadius(10)
                    .foregroundColor(.white)
            }
            
            Text(reminder.title)
                .font(.largeTitle)
                .fontWeight(.heavy)
                .foregroundColor(.white)
            
            Text("Recipe: \(reminder.recipeName)")
                .font(.title3)
                .foregroundColor(Color.white.opacity(0.8))
            
            Text(reminder.reminderMessage)
                .font(.body)
                .italic()
                .foregroundColor(Color.white.opacity(0.9))
                .padding(.top, 5)
        }
        .padding()
        .background(Color.reminderPrimary.opacity(0.95))
        .cornerRadius(20)
        .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 5)
    }
}

@available(iOS 14.0, *)
struct CookingReminderDetailView: View {
    let reminder: CookingReminder
    
    var body: some View {
        ZStack {
            Color.reminderBackground.edgesIgnoringSafeArea(.all)
            
            ScrollView {
                VStack(spacing: 20) {
                    
                    CookingReminderDetailHeader(reminder: reminder)
                        .padding(.horizontal)
                    
                    VStack(alignment: .leading, spacing: 0) {
                        Text("Timing & Schedule")
                            .font(.title2)
                            .fontWeight(.bold)
                            .padding([.top, .horizontal])
                        
                        Divider().padding(.horizontal)
                        
                        VStack(spacing: 0) {
                            CookingReminderDetailFieldRow(label: "Fire Date", value: reminder.fireDate, format: .shortDateTime, iconName: "calendar.badge.clock")
                            CookingReminderDetailFieldRow(label: "Start Cooking Time", value: reminder.startCookingTime, format: .shortDateTime, iconName: "hourglass.start")
                            CookingReminderDetailFieldRow(label: "End Cooking Time", value: reminder.endCookingTime, format: .shortDateTime, iconName: "hourglass.end")
                            CookingReminderDetailFieldRow(label: "Estimated Completion", value: reminder.estimatedCompletion, format: .shortDateTime, iconName: "hourglass.badge.fill")
                            CookingReminderDetailFieldRow(label: "Duration", value: "\(reminder.durationMinutes) Minutes", iconName: "timer")
                            CookingReminderDetailFieldRow(label: "Snooze", value: "\(reminder.snoozeMinutes) Minutes", iconName: "bell.slash.fill")
                            CookingReminderDetailFieldRow(label: "Repeat Interval", value: reminder.repeatIntervalMinutes.map { "\($0) min" } ?? "None", iconName: "infinity.circle")
                            CookingReminderDetailFieldRow(label: "Repeat Days", value: reminder.repeatDays.isEmpty ? "None" : reminder.repeatDays.joined(separator: ", "), iconName: "arrow.clockwise")
                            CookingReminderDetailFieldRow(label: "Is Recurring", value: reminder.isRecurring ? "Yes" : "No", iconName: "repeat.circle")
                        }
                        .padding(.horizontal)
                    }
                    .background(Color.cardBackground)
                    .cornerRadius(15)
                    .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 3)
                    .padding(.horizontal)
                    
                    VStack(alignment: .leading, spacing: 0) {
                        Text("System Configuration")
                            .font(.title2)
                            .fontWeight(.bold)
                            .padding([.top, .horizontal])
                        
                        Divider().padding(.horizontal)
                        
                        VStack(spacing: 0) {
                            CookingReminderDetailFieldRow(label: "Is Active", value: reminder.isActive ? "Yes" : "No", iconName: "power")
                            CookingReminderDetailFieldRow(label: "Alert Type", value: reminder.alertType, iconName: "bell.fill")
                            CookingReminderDetailFieldRow(label: "Sound Name", value: reminder.soundName, iconName: "speaker.wave.3.fill")
                            CookingReminderDetailFieldRow(label: "Vibration Enabled", value: reminder.vibrationEnabled ? "Yes" : "No", iconName: "waveform.path")
                            CookingReminderDetailFieldRow(label: "Show on Lock Screen", value: reminder.showOnLockScreen ? "Yes" : "No", iconName: "lock.open.fill")
                            CookingReminderDetailFieldRow(label: "Is Silent", value: reminder.isSilent ? "Yes" : "No", iconName: "volume.slash.fill")
                            CookingReminderDetailFieldRow(label: "Auto-Delete", value: reminder.autoDeleteAfterTrigger ? "Yes" : "No", iconName: "trash.fill")
                            CookingReminderDetailFieldRow(label: "Is Persistent", value: reminder.isPersistent ? "Yes" : "No", iconName: "archivebox.fill")
                            CookingReminderDetailFieldRow(label: "Linked Timer ID", value: reminder.linkedTimerId?.uuidString, iconName: "link.circle.fill")
                        }
                        .padding(.horizontal)
                    }
                    .background(Color.cardBackground)
                    .cornerRadius(15)
                    .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 3)
                    .padding(.horizontal)
                    
                    VStack(alignment: .leading, spacing: 0) {
                        Text("Context & Metadata")
                            .font(.title2)
                            .fontWeight(.bold)
                            .padding([.top, .horizontal])
                        
                        Divider().padding(.horizontal)
                        
                        VStack(spacing: 0) {
                            HStack {
                                Group {
                                    VStack(alignment: .leading) {
                                        CookingReminderDetailFieldRow(label: "Category", value: reminder.reminderCategory, iconName: "folder")
                                        CookingReminderDetailFieldRow(label: "Kitchen Zone", value: reminder.kitchenZone, iconName: "stove.fill")
                                        CookingReminderDetailFieldRow(label: "Assigned User", value: reminder.assignedUser, iconName: "person.fill")
                                        CookingReminderDetailFieldRow(label: "Location Context", value: reminder.locationContext, iconName: "mappin.and.ellipse")
                                        CookingReminderDetailFieldRow(label: "Color Code", value: reminder.colorCode, iconName: "paintpalette.fill")
                                        CookingReminderDetailFieldRow(label: "Recipe ID", value: reminder.recipeId.uuidString, iconName: "doc.text.magnifyingglass")
                                        CookingReminderDetailFieldRow(label: "Notes", value: reminder.notes, iconName: "pencil.and.outline")
                                    }
                                }
                                
                                Spacer()
                                
                                Group {
                                    VStack(alignment: .leading) {
                                        CookingReminderDetailFieldRow(label: "Priority Level", value: reminder.priorityLevel, iconName: "exclamationmark.triangle.fill")
                                        CookingReminderDetailFieldRow(label: "Display Order", value: "\(reminder.displayOrder)", iconName: "list.number")
                                        CookingReminderDetailFieldRow(label: "Creation Date", value: reminder.createdAt, format: .shortDateTime, iconName: "doc.text")
                                        CookingReminderDetailFieldRow(label: "Last Updated", value: reminder.updatedAt, format: .shortDateTime, iconName: "arrow.up.doc.fill")
                                        CookingReminderDetailFieldRow(label: "Icon Name", value: reminder.iconName, iconName: "wand.and.stars")
                                        CookingReminderDetailFieldRow(label: "Completed", value: reminder.completed ? "Yes" : "No", iconName: "check.all")
                                    }
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                    .background(Color.cardBackground)
                    .cornerRadius(15)
                    .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 3)
                    .padding(.horizontal)
                    
                    Spacer(minLength: 40)
                }
            }
            .navigationTitle("Reminder Details")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

@available(iOS 14.0, *)
struct CookingReminderFeature: View {
    @StateObject var dataStore = SoupDataStore()

    var body: some View {
        CookingReminderListView(dataStore : dataStore)
    }
}
