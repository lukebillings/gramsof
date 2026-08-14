import SwiftUI

struct HomeView: View {
    @Bindable var viewModel: HomeViewModel
    var engagement: AppEngagement
    @Environment(\.requestReview) private var requestReview
    @FocusState private var isDraftFocused: Bool
    @State private var entryPendingAction: ProteinEntry?
    @State private var entryBeingEdited: ProteinEntry?
    @State private var editedGramsText = ""
    @State private var customNamePending: String?
    @State private var customProteinText = ""
    @State private var showsGoalCelebration = false
    @State private var showsEditQuickAdd = false

    private let favouriteColumns = Array(repeating: GridItem(.flexible(), spacing: 8), count: 2)

    var body: some View {
        homeContent
            .alert("Edit grams", isPresented: isEditingEntry) {
                editGramsAlert
            } message: {
                editGramsMessage
            }
            .alert("Protein in this food", isPresented: isCustomFoodPending) {
                customFoodAlert
            } message: {
                customFoodMessage
            }
            .confirmationDialog(
                entryPendingAction.map { "\($0.name)" } ?? "Entry",
                isPresented: isEntryActionPending,
                titleVisibility: .visible
            ) {
                entryActionButtons
            } message: {
                Text("Update the protein amount or remove this entry.")
            }
            .sheet(isPresented: $showsEditQuickAdd) {
                EditQuickAddView(directory: viewModel.quickAdd, customFoods: viewModel.customFoods)
            }
    }

    private var homeContent: some View {
        scrollContent
            .background(AppTheme.background)
            .scrollDismissesKeyboard(.interactively)
            .onChange(of: viewModel.hasReachedGoal, handleGoalReachedChange)
            .overlay { goalCelebrationOverlay }
            .animation(.smooth(duration: 0.3), value: showsGoalCelebration)
    }

    private var scrollContent: some View {
        ScrollView {
            VStack(spacing: 24) {
                header
                ringCard
                quickAddSection
                searchSection
                todaySection
            }
            .padding(.horizontal, 20)
            .padding(.top, 4)
            .padding(.bottom, 32)
        }
    }

    @ViewBuilder
    private var goalCelebrationOverlay: some View {
        if showsGoalCelebration {
            GoalReachedCelebrationView(streak: viewModel.streak, onDismiss: dismissGoalCelebration)
                .transition(.opacity)
        }
    }

    private var isEditingEntry: Binding<Bool> {
        Binding(
            get: { entryBeingEdited != nil },
            set: { if !$0 { entryBeingEdited = nil } }
        )
    }

    private var isCustomFoodPending: Binding<Bool> {
        Binding(
            get: { customNamePending != nil },
            set: { if !$0 { customNamePending = nil } }
        )
    }

    private var isEntryActionPending: Binding<Bool> {
        Binding(
            get: { entryPendingAction != nil },
            set: { if !$0 { entryPendingAction = nil } }
        )
    }

    @ViewBuilder
    private var editGramsAlert: some View {
        TextField("Grams", text: $editedGramsText)
            .keyboardType(.numberPad)

        Button("Save", action: saveEditedGrams)
        Button("Cancel", role: .cancel) {
            entryBeingEdited = nil
        }
    }

    @ViewBuilder
    private var editGramsMessage: some View {
        if let entry = entryBeingEdited {
            Text("Update protein for \(entry.name).")
        }
    }

    @ViewBuilder
    private var customFoodAlert: some View {
        TextField("Protein grams", text: $customProteinText)
            .keyboardType(.numberPad)

        Button("Add", action: saveCustomFood)
        Button("Cancel", role: .cancel) {
            customNamePending = nil
        }
    }

    @ViewBuilder
    private var customFoodMessage: some View {
        if let name = customNamePending {
            Text("How much protein is in one serving of \(name)?")
        }
    }

    @ViewBuilder
    private var entryActionButtons: some View {
        Button("Update grams") {
            guard let entry = entryPendingAction else { return }
            entryPendingAction = nil
            Task { @MainActor in
                beginEditing(entry)
            }
        }

        Button("Delete", role: .destructive) {
            if let entry = entryPendingAction {
                viewModel.delete(entry)
            }
            entryPendingAction = nil
        }

        Button("Cancel", role: .cancel) {
            entryPendingAction = nil
        }
    }

    private var header: some View {
        HStack(alignment: .center, spacing: 12) {
            HStack(spacing: 10) {
                Image("AppLogo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 36, height: 36)
                    .clipShape(.rect(cornerRadius: 9))

                Text("Gramsof")
                    .font(.title2.bold())
                    .foregroundStyle(AppTheme.ink)
            }

            Spacer(minLength: 8)

            HStack(spacing: 6) {
                Image(systemName: "flame.fill")
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(AppTheme.emerald)

                Text("\(viewModel.streak)")
                    .font(.headline.weight(.bold).monospacedDigit())
                    .foregroundStyle(AppTheme.ink)

                Text(viewModel.streak == 1 ? "day" : "days")
                    .font(.caption.weight(.medium))
                    .foregroundStyle(AppTheme.ink.opacity(0.55))
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .glassEffect(.regular, in: .capsule)
            .accessibilityLabel("Streak \(viewModel.streak) days")
        }
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
                     ? "You have reached your daily target!"
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
            HStack(alignment: .top) {
                sectionHeader("Quick add", subtitle: "Tap a portion to log it.")

                Spacer(minLength: 8)

                Button("Edit") {
                    showsEditQuickAdd = true
                }
                .font(.caption.weight(.semibold))
                .foregroundStyle(AppTheme.forest)
                .padding(.horizontal, 10)
                .padding(.vertical, 7)
                .glassEffect(.regular.interactive(), in: .capsule)
            }

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
            HStack(alignment: .top) {
                sectionHeader("Today's log", subtitle: "Tap an entry to edit grams or delete.")

                Spacer(minLength: 8)

                Menu {
                    Picker("Sort", selection: $viewModel.foodLogSort) {
                        ForEach(FoodLogSort.allCases) { sort in
                            Text(sort.title).tag(sort)
                        }
                    }
                } label: {
                    Label(viewModel.foodLogSort.title, systemImage: "arrow.up.arrow.down")
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(AppTheme.forest)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 7)
                        .glassEffect(.regular.interactive(), in: .capsule)
                }
                .onChange(of: viewModel.foodLogSort) { _, _ in
                    AppHaptics.selection()
                }
            }

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
                            entryPendingAction = entry
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

    private func handleGoalReachedChange(_: Bool, _ reached: Bool) {
        guard reached, engagement.consumeGoalCelebration() else { return }
        withAnimation(.smooth(duration: 0.3)) {
            showsGoalCelebration = true
        }
    }

    private func dismissGoalCelebration() {
        withAnimation(.smooth(duration: 0.3)) {
            showsGoalCelebration = false
        }

        guard engagement.noteGoalReached() else { return }
        Task { @MainActor in
            try? await Task.sleep(for: .milliseconds(400))
            requestReview()
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
    HomeView(viewModel: HomeViewModel(store: .seeded), engagement: .preview)
}
