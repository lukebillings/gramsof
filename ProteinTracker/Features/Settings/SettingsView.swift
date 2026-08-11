import StoreKit
import SwiftUI

struct SettingsView: View {
    @Bindable var viewModel: SettingsViewModel
    @Environment(\.requestReview) private var requestReview
    @State private var confirmResetToday = false
    @State private var confirmResetAll = false
    @State private var resetConfirmation: ResetConfirmation?

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
            Form {
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
                }

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
                }

                Section {
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
                    Text("Reset today clears only this day's log. Reset all removes every entry and your custom foods.")
                }

                Section("Onboarding") {
                    Button("Restart onboarding") {
                        viewModel.restartOnboarding()
                    }
                }

                Section("Legal") {
                    Link("Terms and Conditions", destination: viewModel.termsAndConditionsURL)
                    Link("Privacy Policy", destination: viewModel.privacyPolicyURL)
                    Link("Terms of Service", destination: viewModel.termsOfServiceURL)
                }
            }
            .scrollContentBackground(.hidden)
            .background(AppTheme.background)
            .scrollDismissesKeyboard(.interactively)
            .navigationTitle("Settings")
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
        }
    }

    private func presentResetConfirmation(_ confirmation: ResetConfirmation) {
        // Wait for the destructive confirmation sheet to finish dismissing.
        Task { @MainActor in
            try? await Task.sleep(for: .milliseconds(350))
            resetConfirmation = confirmation
        }
    }
}

#Preview {
    SettingsView(
        viewModel: SettingsViewModel(
            store: .seeded,
            onboarding: .preview,
            customFoods: .preview,
            appearance: AppearanceSettings()
        )
    )
}
