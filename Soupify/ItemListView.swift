
import SwiftUI
import Foundation

struct Item: Identifiable {
    let id = UUID()
    var name: String
    var detail: String
    var priority: Priority
    var dueDate: Date
}

enum Priority: String, CaseIterable, Identifiable {
    case high = "High"
    case medium = "Medium"
    case low = "Low"
    var id: String { self.rawValue }

    var color: Color {
        switch self {
        case .high:
            return .red
        case .medium:
            return .orange
        case .low:
            return .green
        }
    }
}

@available(iOS 14.0, *)
struct ItemListView: View {
    @State private var items = [
        Item(name: "Buy Milk", detail: "Check expiration date", priority: .high, dueDate: Date()),
        Item(name: "Walk Dog", detail: "Take to the park", priority: .medium, dueDate: Calendar.current.date(byAdding: .day, value: 1, to: Date())!),
        Item(name: "Write Code", detail: "Finish SwiftUI project", priority: .low, dueDate: Calendar.current.date(byAdding: .day, value: 3, to: Date())!)
    ]

    @State private var showingAddItemView = false

    var body: some View {
        NavigationView {
            List {
                ForEach(items) { item in
                    NavigationLink(destination: ItemDetailView(item: item)) {
                        ItemRow(item: item)
                    }
                }
                .onDelete(perform: deleteItems)
            }
            .navigationTitle("My Tasks")
            .toolbar {
                #if os(iOS)
                ToolbarItem(placement: .navigationBarLeading) {
                    EditButton()
                }
                #endif
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showingAddItemView = true
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .imageScale(.large)
                            .foregroundColor(.accentColor)
                    }
                }
            }
            .sheet(isPresented: $showingAddItemView) {
                AddItemView(items: $items)
            }
        }
    }

    func deleteItems(offsets: IndexSet) {
        items.remove(atOffsets: offsets)
    }
}

@available(iOS 14.0, *)
struct ItemRow: View {
    let item: Item
    
    var body: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 5) {
                Text(item.name)
                    .font(.headline)
                    .foregroundColor(.primary)
                Text(item.detail)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            Spacer()

            VStack(alignment: .trailing, spacing: 5) {
                Text(item.priority.rawValue)
                    .font(.caption)
                    .fontWeight(.bold)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 3)
                    .background(item.priority.color.opacity(0.2))
                    .cornerRadius(8)
                    .foregroundColor(item.priority.color)

                Text(dateFormatter.string(from: item.dueDate))
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.vertical, 5)
    }

    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        return formatter
    }
}

@available(iOS 14.0, *)
struct ItemDetailView: View {
    let item: Item

    var body: some View {
        List {
            Section(header: Text("Task Information")) {
                HStack {
                    Text("Name")
                        .foregroundColor(.secondary)
                    Spacer()
                    Text(item.name)
                        .foregroundColor(.primary)
                }
                HStack {
                    Text("Detail")
                        .foregroundColor(.secondary)
                    Spacer()
                    Text(item.detail)
                        .multilineTextAlignment(.trailing)
                        .foregroundColor(.primary)
                }
            }

            Section(header: Text("Status")) {
                HStack {
                    Text("Priority")
                        .foregroundColor(.secondary)
                    Spacer()
                    Text(item.priority.rawValue)
                        .fontWeight(.semibold)
                        .foregroundColor(item.priority.color)
                }

                HStack {
                    Text("Due Date")
                        .foregroundColor(.secondary)
                    Spacer()
                    Text(dateFormatter.string(from: item.dueDate))
                        .foregroundColor(.primary)
                }
            }
        }
        .listStyle(GroupedListStyle())
        .navigationTitle(item.name)
        .navigationBarTitleDisplayMode(.inline)
    }

    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .short
        return formatter
    }
}

@available(iOS 14.0, *)
struct AddItemView: View {
    @Environment(\.presentationMode) var presentationMode

    @Binding var items: [Item]

    @State private var name: String = ""
    @State private var detail: String = ""
    @State private var priority: Priority = .medium
    @State private var dueDate: Date = Date()

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Task Details")) {
                    TextField("Task Name", text: $name)
                    TextField("Details (Optional)", text: $detail)
                }

                Section(header: Text("Schedule & Priority")) {
                    Picker("Priority", selection: $priority) {
                        ForEach(Priority.allCases) { priority in
                            Text(priority.rawValue)
                                .foregroundColor(priority.color)
                                .tag(priority)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())

                    DatePicker("Due Date", selection: $dueDate, displayedComponents: .date)
                }

                Section {
                    Button("Save Task") {
                        saveItem()
                    }
                    .frame(maxWidth: .infinity)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
                    .disabled(name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
                .listRowBackground(Color.clear)
            }
            .navigationTitle("Add New Task")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                    }
                }
            }
        }
    }

    private func saveItem() {
        let newItem = Item(name: name.trimmingCharacters(in: .whitespacesAndNewlines), detail: detail, priority: priority, dueDate: dueDate)
        items.append(newItem)
    }
}
