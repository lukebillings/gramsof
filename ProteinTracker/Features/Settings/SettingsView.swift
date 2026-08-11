import StoreKit
import SwiftUI

struct SettingsView: View {
    @Bindable var viewModel: SettingsViewModel
    @Environment(\.requestReview) private var requestReview
    @State private var confirmResetToday = false
    @State private var confirmResetAll = false

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

                Section("Reminders") {
                    Toggle("Daily logging reminder", isOn: $viewModel.remindersEnabled)
                }

                Section("Share & feedback") {
                    ShareLink(item: viewModel.shareText) {
                        Label("Share today's progress", systemImage: "square.and.arrow.up")
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

                Section {
                    LabeledContent("Your goal", value: viewModel.onboardingGoalName)

                    Button("Restart onboarding") {
                        viewModel.restartOnboarding()
                    }
                } header: {
                    Text("Onboarding")
                } footer: {
                    Text("Runs you back through goal setup and the plan options. Your logged entries stay where they are.")
                }

                Section("About") {
                    LabeledContent("Version", value: "1.0")
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
                }
                Button("Cancel", role: .cancel) {}
            } message: {
                Text("This clears all logged entries and custom foods, and restores the default daily goal.")
            }
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
