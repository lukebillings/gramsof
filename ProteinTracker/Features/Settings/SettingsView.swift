import SwiftUI

struct SettingsView: View {
    @Bindable var viewModel: SettingsViewModel

    var body: some View {
        NavigationStack {
            Form {
                Section("Daily goal") {
                    Stepper(value: $viewModel.dailyGoal, in: viewModel.goalRange, step: 5) {
                        HStack {
                            Text("Protein target")
                            Spacer()
                            Text("\(viewModel.dailyGoal)g")
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

                Section("About") {
                    LabeledContent("Version", value: "1.0")
                }
            }
            .scrollContentBackground(.hidden)
            .background(AppTheme.background)
            .navigationTitle("Settings")
        }
    }
}

#Preview {
    SettingsView(viewModel: SettingsViewModel(store: .seeded))
}
