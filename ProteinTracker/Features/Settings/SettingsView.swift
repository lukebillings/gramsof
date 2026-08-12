import StoreKit
import SwiftUI
import UniformTypeIdentifiers

struct SettingsView: View {
    @Bindable var viewModel: SettingsViewModel
    @Environment(\.requestReview) private var requestReview
    @State private var confirmResetToday = false
    @State private var confirmResetAll = false
    @State private var resetConfirmation: ResetConfirmation?
    @State private var isImportingCSV = false
    @State private var importMerges = true
    @State private var shareItem: ShareableExport?

    private struct ShareableExport: Identifiable {
        let id = UUID()
        let url: URL
    }

    private enum ResetConfirmation: Identifiable {
        case today
        case all

        var id: String {
            switch self {
            case .today: "today"
            case .all: "all"
            }
        }

        var title: String {
            switch self {
            case .today: "Today's data reset"
            case .all: "All data reset"
            }
        }

        var message: String {
            switch self {
            case .today: "Every entry logged today has been cleared."
            case .all: "All logged entries and custom foods have been removed."
            }
        }
    }

    var body: some View {
        NavigationStack {
            formContent
                .scrollContentBackground(.hidden)
                .background(AppTheme.background)
                .scrollDismissesKeyboard(.interactively)
                .navigationTitle("Settings")
                .fileImporter(
                    isPresented: $isImportingCSV,
                    allowedContentTypes: [.commaSeparatedText, .plainText],
                    allowsMultipleSelection: false
                ) { result in
                    switch result {
                    case .success(let urls):
                        guard let url = urls.first else { return }
                        viewModel.importCSV(from: url, merging: importMerges)
                    case .failure(let error):
                        viewModel.importErrorMessage = error.localizedDescription
                    }
                }
                .sheet(item: $shareItem) { item in
                    ActivityShareSheet(items: [item.url])
                }
                .confirmationDialog(
                    "Reset today's data?",
                    isPresented: $confirmResetToday,
                    titleVisibility: .visible
                ) {
                    Button("Reset today", role: .destructive) {
                        viewModel.resetToday()
                        presentResetConfirmation(.today)
                    }
                    Button("Cancel", role: .cancel) {}
                } message: {
                    Text("This removes every entry logged today. Older days stay put.")
                }
                .confirmationDialog(
                    "Reset all data?",
                    isPresented: $confirmResetAll,
                    titleVisibility: .visible
                ) {
                    Button("Reset everything", role: .destructive) {
                        viewModel.resetAllData()
                        presentResetConfirmation(.all)
                    }
                    Button("Cancel", role: .cancel) {}
                } message: {
                    Text("This clears all logged entries and custom foods, and restores the default daily goal.")
                }
                .alert(
                    resetConfirmation?.title ?? "",
                    isPresented: Binding(
                        get: { resetConfirmation != nil },
                        set: { if !$0 { resetConfirmation = nil } }
                    )
                ) {
                    Button("OK", role: .cancel) {
                        resetConfirmation = nil
                    }
                } message: {
                    Text(resetConfirmation?.message ?? "")
                }
                .alert(
                    "Import failed",
                    isPresented: Binding(
                        get: { viewModel.importErrorMessage != nil },
                        set: { if !$0 { viewModel.importErrorMessage = nil } }
                    )
                ) {
                    Button("OK", role: .cancel) {
                        viewModel.importErrorMessage = nil
                    }
                } message: {
                    Text(viewModel.importErrorMessage ?? "")
                }
                .alert(
                    "Import complete",
                    isPresented: Binding(
                        get: { viewModel.importSuccessMessage != nil },
                        set: { if !$0 { viewModel.importSuccessMessage = nil } }
                    )
                ) {
                    Button("OK", role: .cancel) {
                        viewModel.importSuccessMessage = nil
                    }
                } message: {
                    Text(viewModel.importSuccessMessage ?? "")
                }
        }
    }

    private var formContent: some View {
        Form {
            goalSection
            appearanceSection
            remindersSection
            shareSection
            dataSection
            onboardingSection
            legalSection
        }
    }

    private var goalSection: some View {
        Section("Daily goal") {
            LabeledContent("Protein target") {
                HStack(spacing: 4) {
                    TextField("150", value: $viewModel.dailyGoal, format: .number)
                        .keyboardType(.numberPad)
                        .multilineTextAlignment(.trailing)
                        .frame(minWidth: 56, alignment: .trailing)

                    Text("g")
                        .foregroundStyle(.secondary)
                }
            }

            Toggle("Show remaining on ring", isOn: $viewModel.showsRemainingOnRing)
        }
    }

    private var appearanceSection: some View {
        Section("Appearance") {
            Picker(
                "Theme",
                selection: Binding(
                    get: { viewModel.appearancePreference },
                    set: { viewModel.appearancePreference = $0 }
                )
            ) {
                ForEach(AppearancePreference.allCases) { preference in
                    Text(preference.title).tag(preference)
                }
            }
            .pickerStyle(.segmented)

            Toggle("Haptic feedback", isOn: $viewModel.hapticsEnabled)
        }
    }

    private var remindersSection: some View {
        Section {
            Toggle("Daily logging reminder", isOn: $viewModel.remindersEnabled)

            if viewModel.remindersEnabled {
                DatePicker(
                    "Remind me at",
                    selection: $viewModel.reminderTime,
                    displayedComponents: .hourAndMinute
                )
            }
        } header: {
            Text("Reminders")
        } footer: {
            if viewModel.remindersEnabled {
                Text("We'll send a daily notification at this time so you remember to log.")
            }
        }
    }

    private var shareSection: some View {
        Section("Share & feedback") {
            ShareLink(
                item: viewModel.appStoreURL,
                subject: Text("Gramsof"),
                message: Text(viewModel.appShareMessage)
            ) {
                Label("Share the app", systemImage: "square.and.arrow.up")
            }

            Button {
                requestReview()
            } label: {
                Label("Write a review", systemImage: "star")
            }

            Link(destination: viewModel.featureRequestURL) {
                Label("Request a feature", systemImage: "lightbulb")
            }
        }
    }

    private var dataSection: some View {
        Section {
            Button {
                importMerges = true
                isImportingCSV = true
            } label: {
                Label("Import CSV", systemImage: "square.and.arrow.down")
            }

            Button {
                prepareExport(csv: true)
            } label: {
                Label("Export CSV", systemImage: "tablecells")
            }

            Button {
                prepareExport(csv: false)
            } label: {
                Label("Export PDF", systemImage: "doc.richtext")
            }

            LabeledContent("Entries logged", value: "\(viewModel.loggedEntryCount)")

            Button("Reset today's data", role: .destructive) {
                confirmResetToday = true
            }

            Button("Reset all data", role: .destructive) {
                confirmResetAll = true
            }
        } header: {
            Text("Data")
        } footer: {
            Text("Import CSV merges matching rows by id. Export PDF is a printable food log. Reset today clears only this day's log. Reset all removes every entry and your custom foods.")
        }
    }

    private var onboardingSection: some View {
        Section("Onboarding") {
            Button("Restart onboarding") {
                viewModel.restartOnboarding()
            }
        }
    }

    private var legalSection: some View {
        Section("Legal") {
            Link("Terms and Conditions", destination: viewModel.termsAndConditionsURL)
            Link("Privacy Policy", destination: viewModel.privacyPolicyURL)
            Link("Terms of Use", destination: viewModel.termsOfUseURL)
        }
    }

    private func prepareExport(csv: Bool) {
        do {
            let url = try viewModel.writeExportFile(csv: csv)
            shareItem = ShareableExport(url: url)
            AppHaptics.impact(.light)
        } catch {
            viewModel.importErrorMessage = error.localizedDescription
            AppHaptics.notification(.error)
        }
    }

    private func presentResetConfirmation(_ confirmation: ResetConfirmation) {
        Task { @MainActor in
            try? await Task.sleep(for: .milliseconds(350))
            resetConfirmation = confirmation
        }
    }
}

private struct ActivityShareSheet: UIViewControllerRepresentable {
    let items: [Any]

    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: items, applicationActivities: nil)
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}

#Preview {
    SettingsView(
        viewModel: SettingsViewModel(
            store: .seeded,
            onboarding: .preview,
            customFoods: .preview,
            appearance: AppearanceSettings(),
            haptics: HapticSettings()
        )
    )
}
