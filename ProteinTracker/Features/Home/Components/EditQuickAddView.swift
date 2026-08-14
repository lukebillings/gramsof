import SwiftUI

struct EditQuickAddView: View {
    @Bindable var directory: QuickAddDirectory
    let customFoods: CustomFoodDirectory
    @Environment(\.dismiss) private var dismiss
    @State private var itemBeingEdited: QuickAddItem?
    @State private var showsAddFood = false

    var body: some View {
        NavigationStack {
            List {
                Section {
                    ForEach(directory.items) { item in
                        Button {
                            itemBeingEdited = item
                        } label: {
                            HStack(spacing: 12) {
                                Text(item.emoji)
                                    .font(.title3)
                                    .frame(width: 36, height: 36)
                                    .background(AppTheme.mint.opacity(0.45), in: .circle)

                                VStack(alignment: .leading, spacing: 2) {
                                    Text(item.name)
                                        .font(.body.weight(.semibold))
                                        .foregroundStyle(AppTheme.ink)
                                    Text(item.portionDescription)
                                        .font(.caption)
                                        .foregroundStyle(AppTheme.ink.opacity(0.5))
                                }

                                Spacer(minLength: 8)

                                Text("+\(item.grams)g")
                                    .font(.subheadline.weight(.semibold))
                                    .foregroundStyle(AppTheme.forest)
                            }
                        }
                    }
                    .onDelete(perform: delete)
                    .onMove(perform: directory.move)
                } header: {
                    Text("Your shortcuts")
                } footer: {
                    Text("These appear on Today. Tap one to change the portion, or drag to reorder.")
                }

                Section {
                    Button("Add a food") {
                        showsAddFood = true
                    }
                    .disabled(!directory.canAdd)

                    Button("Restore defaults") {
                        directory.resetToDefaults()
                    }
                } footer: {
                    if directory.canAdd {
                        Text("You can keep up to \(QuickAddDirectory.maxItems) shortcuts.")
                    } else {
                        Text("Remove one before adding another. Maximum is \(QuickAddDirectory.maxItems).")
                    }
                }
            }
            .navigationTitle("Quick add")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    EditButton()
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") { dismiss() }
                }
            }
            .sheet(item: $itemBeingEdited) { item in
                EditQuickAddItemView(item: item) { updated in
                    directory.update(updated)
                }
            }
            .sheet(isPresented: $showsAddFood) {
                AddQuickAddFoodView(customFoods: customFoods) { food in
                    directory.add(.from(food: food))
                    showsAddFood = false
                }
            }
        }
    }

    private func delete(at offsets: IndexSet) {
        let toRemove = offsets.map { directory.items[$0] }
        for item in toRemove {
            directory.remove(item)
        }
    }
}

private struct EditQuickAddItemView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var item: QuickAddItem
    @State private var portionText: String
    @State private var proteinText: String
    @State private var detailText: String
    @FocusState private var focusedField: Field?
    let onSave: (QuickAddItem) -> Void

    private enum Field: Hashable {
        case portion
        case protein
        case detail
    }

    init(item: QuickAddItem, onSave: @escaping (QuickAddItem) -> Void) {
        self.onSave = onSave
        _item = State(initialValue: item)
        _portionText = State(initialValue: item.portionGrams.map(String.init) ?? "")
        _proteinText = State(initialValue: "\(item.grams)")
        _detailText = State(initialValue: item.detail)
    }

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    LabeledContent("Food", value: item.name)

                    if item.canRecalculateProtein {
                        LabeledContent("Portion") {
                            HStack(spacing: 4) {
                                TextField("170", text: $portionText)
                                    .keyboardType(.numberPad)
                                    .multilineTextAlignment(.trailing)
                                    .focused($focusedField, equals: .portion)
                                    .onChange(of: portionText, applyPortion)

                                Text("g")
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }

                    LabeledContent("Protein") {
                        HStack(spacing: 4) {
                            TextField("17", text: $proteinText)
                                .keyboardType(.numberPad)
                                .multilineTextAlignment(.trailing)
                                .focused($focusedField, equals: .protein)
                                .onChange(of: proteinText, applyProtein)

                            Text("g")
                                .foregroundStyle(.secondary)
                        }
                    }

                    TextField("How it appears, e.g. 170g of Greek yogurt", text: $detailText, axis: .vertical)
                        .lineLimit(2...3)
                        .focused($focusedField, equals: .detail)
                        .onChange(of: detailText) { _, newValue in
                            item.detail = newValue
                        }
                } footer: {
                    Text("Today will show this portion, then add \(item.grams)g of protein when you tap it.")
                }
            }
            .navigationTitle("Edit portion")
            .navigationBarTitleDisplayMode(.inline)
            .scrollDismissesKeyboard(.immediately)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        onSave(item)
                        dismiss()
                    }
                    .disabled(item.grams < 1)
                }
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    Button("Done") { focusedField = nil }
                        .fontWeight(.semibold)
                }
            }
        }
        .presentationDetents([.medium, .large])
    }

    private func applyPortion(_: String, _ newValue: String) {
        guard let portion = Int(newValue), portion > 0 else { return }
        item.setPortionGrams(portion)
        proteinText = "\(item.grams)"
        detailText = item.detail
    }

    private func applyProtein(_: String, _ newValue: String) {
        guard let grams = Int(newValue), grams > 0 else { return }
        item.grams = grams
    }
}

private struct AddQuickAddFoodView: View {
    let customFoods: CustomFoodDirectory
    let onPick: (FoodItem) -> Void
    @Environment(\.dismiss) private var dismiss
    @State private var query = ""
    @FocusState private var isSearchFocused: Bool

    private var suggestions: [FoodSuggestion] {
        FoodLookup.suggestions(for: query, including: customFoods.foodItems, limit: 12)
    }

    var body: some View {
        NavigationStack {
            List {
                Section {
                    TextField("Search foods", text: $query)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                        .focused($isSearchFocused)
                }

                if !suggestions.isEmpty {
                    Section("Matches") {
                        ForEach(suggestions) { suggestion in
                            Button {
                                onPick(suggestion.food)
                            } label: {
                                HStack(spacing: 12) {
                                    Text(suggestion.emoji)
                                        .font(.title3)
                                        .frame(width: 36)

                                    VStack(alignment: .leading, spacing: 2) {
                                        Text(suggestion.name)
                                            .foregroundStyle(AppTheme.ink)
                                        Text(suggestion.portionLabel)
                                            .font(.caption)
                                            .foregroundStyle(.secondary)
                                    }

                                    Spacer()

                                    Text("+\(suggestion.grams)g")
                                        .font(.subheadline.weight(.semibold))
                                        .foregroundStyle(AppTheme.forest)
                                }
                            }
                        }
                    }
                } else if query.trimmingCharacters(in: .whitespaces).count >= 2 {
                    Section {
                        Text("No matching foods. Try a shorter name, or add it as a custom food from Today first.")
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .navigationTitle("Add a food")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    Button("Done") { isSearchFocused = false }
                        .fontWeight(.semibold)
                }
            }
            .onAppear { isSearchFocused = true }
        }
    }
}

#Preview {
    EditQuickAddView(directory: .preview, customFoods: .preview)
}
