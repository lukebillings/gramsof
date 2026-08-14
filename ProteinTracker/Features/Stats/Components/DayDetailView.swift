import SwiftUI

/// Read-only breakdown for a single day tapped from the month heatmap.
struct DayDetailView: View {
    let date: Date
    let entries: [ProteinEntry]
    let total: Int
    let goal: Int

    private var percent: Int {
        guard goal > 0 else { return 0 }
        return Int((min(Double(total) / Double(goal), 1) * 100).rounded())
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    summaryCard
                    foodLog
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 32)
            }
            .background(AppTheme.background)
            .navigationTitle(date.formatted(.dateTime.weekday(.wide).month(.abbreviated).day()))
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    private var summaryCard: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(alignment: .firstTextBaseline, spacing: 6) {
                Text("\(total)g")
                    .font(.system(size: 40, weight: .bold, design: .rounded))
                    .foregroundStyle(AppTheme.ink)

                Text("of \(goal)g")
                    .font(.title3.weight(.semibold))
                    .foregroundStyle(AppTheme.ink.opacity(0.45))
            }

            HStack(spacing: 12) {
                summaryChip(label: "Target", value: "\(goal)g")
                summaryChip(label: "Reached", value: "\(percent)%")
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(18)
        .glassEffect(.regular, in: .rect(cornerRadius: 24))
    }

    private func summaryChip(label: String, value: String) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(label)
                .font(.caption.weight(.medium))
                .foregroundStyle(AppTheme.ink.opacity(0.45))
            Text(value)
                .font(.headline.weight(.semibold))
                .foregroundStyle(AppTheme.ink)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(14)
        .background(AppTheme.mint.opacity(0.35), in: .rect(cornerRadius: 16))
    }

    @ViewBuilder
    private var foodLog: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Food log")
                .font(.headline)
                .foregroundStyle(AppTheme.ink)

            if entries.isEmpty {
                Text("No foods logged this day.")
                    .font(.subheadline)
                    .foregroundStyle(AppTheme.ink.opacity(0.5))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(18)
                    .glassEffect(.regular, in: .rect(cornerRadius: 22))
            } else {
                VStack(spacing: 0) {
                    LoggedEntryColumnHeader()

                    ForEach(entries) { entry in
                        LoggedEntryRow(entry: entry)
                        if entry.id != entries.last?.id {
                            Divider()
                                .padding(.leading, 60)
                        }
                    }
                }
                .glassEffect(.regular, in: .rect(cornerRadius: 22))
            }
        }
    }
}

#Preview {
    DayDetailView(
        date: .now,
        entries: [
            ProteinEntry(name: "Greek yogurt", grams: 17, loggedAt: .now.addingTimeInterval(-9000)),
            ProteinEntry(name: "Protein shake", grams: 25, loggedAt: .now.addingTimeInterval(-5400)),
            ProteinEntry(name: "Chicken breast", grams: 36, loggedAt: .now.addingTimeInterval(-1800))
        ],
        total: 78,
        goal: 150
    )
}
