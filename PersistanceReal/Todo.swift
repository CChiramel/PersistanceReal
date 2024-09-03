//
//  Todo.swift
//  PersistanceReal
//
//  Created by Chris K. Chiramel on 9/3/24.
//

import SwiftUI
import SwiftData

// Model for the To-Do item
@Model
class TodoItem: Identifiable {
    var id = UUID()
    var title: String
    var timestamp: Date
    var isCompleted: Bool = false
    
    init(title: String, timestamp: Date) {
        self.title = title
        self.timestamp = timestamp
    }
}

struct Todo: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [TodoItem]

    @State private var newItemTitle = ""
    @State private var newItemDate = Date()
    @State private var showAddItemSheet = false

    var body: some View {
        NavigationSplitView {
            List {
                ForEach(items) { item in
                    HStack {
                        Button(action: {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                completeItem(item)
                            }
                        }) {
                            Image(systemName: item.isCompleted ? "checkmark.circle.fill" : "circle")
                                .foregroundColor(item.isCompleted ? .green : .gray)
                        }
                        Text(item.title)
                            .strikethrough(item.isCompleted)
                        Spacer()
                        Text(item.timestamp, format: Date.FormatStyle(date: .numeric, time: .shortened))
                            .foregroundColor(.secondary)
                    }
                    .transition(.slide)
                }
                .onDelete(perform: deleteItems)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
                ToolbarItem {
                    Button(action: { showAddItemSheet.toggle() }) {
                        Label("Add Item", systemImage: "plus")
                    }
                }
            }
            .sheet(isPresented: $showAddItemSheet) {
                VStack {
                    TextField("Task Title", text: $newItemTitle)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()

                    DatePicker("Due Date", selection: $newItemDate, displayedComponents: [.date, .hourAndMinute])
                        .datePickerStyle(WheelDatePickerStyle())
                        .padding()

                    Button("Save") {
                        addItem()
                        showAddItemSheet.toggle()
                    }
                    .padding()
                    .buttonStyle(.borderedProminent)
                }
                .padding()
            }
        } detail: {
            Text("Select an item")
        }
    }

    private func addItem() {
        withAnimation {
            let newItem = TodoItem(title: newItemTitle, timestamp: newItemDate)
            modelContext.insert(newItem)
            newItemTitle = ""
            newItemDate = Date()
        }
    }

    private func completeItem(_ item: TodoItem) {
        withAnimation {
            item.isCompleted.toggle()
            if item.isCompleted {
                // Animate the removal of the completed item
                modelContext.delete(item)
            }
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(items[index])
            }
        }
    }
}

#Preview {
    Todo()
        .modelContainer(for: TodoItem.self, inMemory: true)
}
