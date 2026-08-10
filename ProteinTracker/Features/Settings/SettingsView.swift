import SwiftUI

struct SettingsView: View {
    @Bindable var viewModel: SettingsViewModel

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

                Section("Reminders") {
                    Toggle("Daily logging reminder", isOn: $viewModel.remindersEnabled)
                }

                Section("Data") {
                    LabeledContent("Entries logged", value: "\(viewModel.loggedEntryCount)")

                    Button("Clear today's log", role: .destructive) {
                        viewModel.resetToday()
                    }
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
        }
    }
}

#Preview {
    SettingsView(viewModel: SettingsViewModel(store: .seeded, onboarding: .preview))
}
