import SwiftUI

struct HomeView: View {
    @Bindable var viewModel: HomeViewModel
    @FocusState private var isDraftFocused: Bool

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    ringCard
                    quickAddSection
                    typeToLogSection
                    todaySection
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 32)
            }
            .background(AppTheme.background)
            .scrollDismissesKeyboard(.interactively)
            .navigationTitle("Today")
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

            GlassEffectContainer(spacing: 12) {
                HStack(spacing: 12) {
                    ForEach(viewModel.quickAmounts, id: \.self) { amount in
                        Button {
                            viewModel.addAmount(amount)
                        } label: {
                            VStack(spacing: 2) {
                                Text("+\(amount)")
                                    .font(.title2.weight(.bold))
                                Text("grams")
                                    .font(.caption2)
                                    .foregroundStyle(AppTheme.ink.opacity(0.5))
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                        }
                        .buttonStyle(.glass)
                        .tint(AppTheme.emerald)
                    }
                }
            }

            VStack(spacing: 10) {
                ForEach(viewModel.favourites) { item in
                    QuickAddRow(item: item) {
                        viewModel.add(item)
                    }
                }
            }
        }
    }

    // MARK: - Type to log

    private var typeToLogSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            sectionHeader("Start typing", subtitle: "Try “chicken 40” or just “30”.")

            HStack(spacing: 10) {
                TextField("Add food and grams", text: $viewModel.draft)
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
        }
    }

    // MARK: - Today's log

    private var todaySection: some View {
        VStack(alignment: .leading, spacing: 12) {
            sectionHeader("Today's log", subtitle: nil)

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
                        LoggedEntryRow(entry: entry)
                            .contextMenu {
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
}

#Preview {
    HomeView(viewModel: HomeViewModel(store: .seeded))
}
