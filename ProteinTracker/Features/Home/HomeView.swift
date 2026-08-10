import SwiftUI

struct HomeView: View {
    @Bindable var viewModel: HomeViewModel
    @FocusState private var isDraftFocused: Bool
    @State private var entryBeingEdited: ProteinEntry?
    @State private var editedGramsText = ""
    @State private var customNamePending: String?
    @State private var customProteinText = ""

    private let favouriteColumns = Array(repeating: GridItem(.flexible(), spacing: 8), count: 4)

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                title
                ringCard
                quickAddSection
                searchSection
                todaySection
            }
            .padding(.horizontal, 20)
            .padding(.top, 4)
            .padding(.bottom, 32)
        }
        .background(AppTheme.background)
        .scrollDismissesKeyboard(.interactively)
        .alert("Edit grams", isPresented: Binding(
            get: { entryBeingEdited != nil },
            set: { if !$0 { entryBeingEdited = nil } }
        )) {
            TextField("Grams", text: $editedGramsText)
                .keyboardType(.numberPad)

            Button("Save") {
                saveEditedGrams()
            }

            Button("Cancel", role: .cancel) {
                entryBeingEdited = nil
            }
        } message: {
            if let entry = entryBeingEdited {
                Text("Update protein for \(entry.name).")
            }
        }
        .alert("Protein in this food", isPresented: Binding(
            get: { customNamePending != nil },
            set: { if !$0 { customNamePending = nil } }
        )) {
            TextField("Protein grams", text: $customProteinText)
                .keyboardType(.numberPad)

            Button("Add") {
                saveCustomFood()
            }

            Button("Cancel", role: .cancel) {
                customNamePending = nil
            }
        } message: {
            if let name = customNamePending {
                Text("How much protein is in one serving of \(name)?")
            }
        }
    }

    private var title: some View {
        Text("Log Protein")
            .font(.largeTitle.bold())
            .foregroundStyle(AppTheme.ink)
            .frame(maxWidth: .infinity, alignment: .leading)
    }

    // MARK: - Ring

    private var ringCard: some View {
        VStack(spacing: 16) {
            ProteinRingView(
                total: viewModel.total,
                goal: viewModel.goal,
                progress: viewModel.progress
            )

            if viewModel.showsRemaining {
                Text(viewModel.hasReachedGoal
                     ? "Goal smashed. Nice work."
                     : "\(viewModel.remaining)g to go today")
                    .font(.subheadline.weight(.medium))
                    .foregroundStyle(AppTheme.ink.opacity(0.6))
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 28)
        .glassEffect(.regular, in: .rect(cornerRadius: 32))
    }

    // MARK: - Quick add

    private var quickAddSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            sectionHeader("Quick add", subtitle: "One tap. Under 10 seconds.")

            LazyVGrid(columns: favouriteColumns, spacing: 8) {
                ForEach(viewModel.favourites) { item in
                    QuickAddTile(item: item) {
                        viewModel.add(item)
                    }
                }
            }
        }
    }

    // MARK: - Search

    private var searchSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            sectionHeader("Add by searching", subtitle: "Try “chicken”, “2 eggs” or “200g salmon”.")

            HStack(spacing: 10) {
                TextField("Search foods", text: $viewModel.draft)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                    .submitLabel(.done)
                    .focused($isDraftFocused)
                    .onSubmit(viewModel.submitDraft)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 14)
                    .glassEffect(.regular, in: .capsule)

                Button {
                    viewModel.submitDraft()
                    isDraftFocused = false
                } label: {
                    Image(systemName: "arrow.up")
                        .font(.body.weight(.bold))
                        .padding(6)
                }
                .buttonStyle(.glassProminent)
                .tint(AppTheme.emerald)
                .disabled(!viewModel.canSubmitDraft)
                .accessibilityLabel("Log entry")
            }

            if !viewModel.suggestions.isEmpty || viewModel.customFoodCandidate != nil {
                VStack(spacing: 10) {
                    ForEach(viewModel.suggestions) { suggestion in
                        FoodSuggestionRow(suggestion: suggestion) {
                            viewModel.log(suggestion)
                        }
                    }

                    if let customName = viewModel.customFoodCandidate {
                        Button {
                            isDraftFocused = false
                            customProteinText = ""
                            customNamePending = customName
                        } label: {
                            HStack(spacing: 12) {
                                Image(systemName: "plus.circle.fill")
                                    .font(.title3)
                                    .foregroundStyle(AppTheme.emerald)
                                    .frame(width: 38, height: 38)

                                VStack(alignment: .leading, spacing: 2) {
                                    Text("Add “\(customName)” as custom")
                                        .font(.body.weight(.semibold))
                                        .foregroundStyle(AppTheme.ink)
                                        .multilineTextAlignment(.leading)

                                    Text("Save it to your food directory")
                                        .font(.caption)
                                        .foregroundStyle(AppTheme.ink.opacity(0.5))
                                }

                                Spacer(minLength: 0)
                            }
                            .padding(.horizontal, 16)
                            .padding(.vertical, 12)
                            .contentShape(.rect)
                        }
                        .buttonStyle(.plain)
                        .glassEffect(.regular.interactive(), in: .rect(cornerRadius: 20))
                    }
                }
            }
        }
    }

    // MARK: - Today's log

    private var todaySection: some View {
        VStack(alignment: .leading, spacing: 12) {
            sectionHeader("Today's log", subtitle: "Tap the grams to edit.")

            if viewModel.todayEntries.isEmpty {
                Text("Nothing logged yet.")
                    .font(.subheadline)
                    .foregroundStyle(AppTheme.ink.opacity(0.5))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 28)
                    .glassEffect(.regular, in: .rect(cornerRadius: 24))
            } else {
                VStack(spacing: 0) {
                    ForEach(viewModel.todayEntries) { entry in
                        LoggedEntryRow(entry: entry) {
                            beginEditing(entry)
                        }
                        .contextMenu {
                            Button("Edit grams", systemImage: "pencil") {
                                beginEditing(entry)
                            }

                            Button("Delete", systemImage: "trash", role: .destructive) {
                                viewModel.delete(entry)
                            }
                        }

                        if entry != viewModel.todayEntries.last {
                            Divider().padding(.leading, 16)
                        }
                    }
                }
                .glassEffect(.regular, in: .rect(cornerRadius: 24))
            }
        }
    }

    private func sectionHeader(_ title: String, subtitle: String?) -> some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(title)
                .font(.title3.weight(.bold))
                .foregroundStyle(AppTheme.ink)

            if let subtitle {
                Text(subtitle)
                    .font(.caption)
                    .foregroundStyle(AppTheme.ink.opacity(0.5))
            }
        }
    }

    private func beginEditing(_ entry: ProteinEntry) {
        editedGramsText = "\(entry.grams)"
        entryBeingEdited = entry
    }

    private func saveEditedGrams() {
        guard let entry = entryBeingEdited,
              let grams = Int(editedGramsText.trimmingCharacters(in: .whitespacesAndNewlines)),
              grams > 0
        else {
            entryBeingEdited = nil
            return
        }

        viewModel.updateGrams(for: entry, to: grams)
        entryBeingEdited = nil
    }

    private func saveCustomFood() {
        guard let name = customNamePending,
              let grams = Int(customProteinText.trimmingCharacters(in: .whitespacesAndNewlines)),
              grams > 0
        else {
            customNamePending = nil
            return
        }

        viewModel.addCustomFood(named: name, proteinGrams: grams)
        customNamePending = nil
    }
}

#Preview {
    HomeView(viewModel: HomeViewModel(store: .seeded))
}
