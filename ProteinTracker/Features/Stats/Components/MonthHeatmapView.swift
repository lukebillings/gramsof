import SwiftUI

/// GitHub-style contribution grid: solid emerald the closer a day is to the goal.
struct MonthHeatmapView: View {
    let totals: [DayTotal]
    let goal: Int
    var onSelectDay: ((DayTotal) -> Void)? = nil

    private let columns = Array(repeating: GridItem(.flexible(), spacing: 6), count: 7)
    private let weekdayLabels = ["S", "M", "T", "W", "T", "F", "S"]

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            LazyVGrid(columns: columns, spacing: 6) {
                ForEach(Array(weekdayLabels.enumerated()), id: \.offset) { _, label in
                    Text(label)
                        .font(.caption2.weight(.semibold))
                        .foregroundStyle(AppTheme.ink.opacity(0.4))
                        .frame(maxWidth: .infinity)
                        .multilineTextAlignment(.center)
                }
            }

            LazyVGrid(columns: columns, spacing: 6) {
                ForEach(Array(paddedCells.enumerated()), id: \.offset) { _, cell in
                    square(for: cell)
                }
            }

            legend
        }
    }

    private var legend: some View {
        HStack(spacing: 8) {
            Text("Less")
                .font(.caption2)
                .foregroundStyle(AppTheme.ink.opacity(0.4))

            ForEach(legendSteps, id: \.progress) { step in
                VStack(spacing: 4) {
                    RoundedRectangle(cornerRadius: 4, style: .continuous)
                        .fill(fill(for: step.progress))
                        .frame(width: 14, height: 14)
                        .overlay {
                            if step.progress == 0 {
                                RoundedRectangle(cornerRadius: 4, style: .continuous)
                                    .strokeBorder(AppTheme.ink.opacity(0.12), lineWidth: 1)
                            }
                        }

                    Text(step.label)
                        .font(.system(size: 9, weight: .medium).monospacedDigit())
                        .foregroundStyle(AppTheme.ink.opacity(0.4))
                        .lineLimit(1)
                }
                .frame(width: 36)
            }

            Text("Goal")
                .font(.caption2)
                .foregroundStyle(AppTheme.ink.opacity(0.4))
        }
        .frame(maxWidth: .infinity)
        .padding(.top, 4)
    }

    private var legendSteps: [(progress: Double, label: String)] {
        [
            (0.0, "0%"),
            (0.25, "25%"),
            (0.5, "50%"),
            (0.75, "75%"),
            (1.0, "100%")
        ]
    }

    @ViewBuilder
    private func square(for cell: HeatmapCell) -> some View {
        switch cell {
        case .empty:
            Color.clear
                .aspectRatio(1, contentMode: .fit)
        case .day(let total):
            let progress = progress(for: total)
            Button {
                onSelectDay?(total)
            } label: {
                RoundedRectangle(cornerRadius: 6, style: .continuous)
                    .fill(fill(for: progress))
                    .overlay {
                        if progress == 0 {
                            RoundedRectangle(cornerRadius: 6, style: .continuous)
                                .strokeBorder(AppTheme.ink.opacity(0.12), lineWidth: 1)
                        }
                    }
                    .aspectRatio(1, contentMode: .fit)
                    .contentShape(.rect)
            }
            .buttonStyle(.plain)
            .disabled(onSelectDay == nil)
            .accessibilityLabel(accessibilityLabel(for: total))
            .accessibilityHint("Shows the food log for this day")
        }
    }

    private func progress(for day: DayTotal) -> Double {
        guard goal > 0 else { return 0 }
        return min(Double(day.grams) / Double(goal), 1)
    }

    /// Five clearly stepped greens so partial days don't all read the same.
    private func fill(for progress: Double) -> Color {
        AppTheme.progressFill(for: progress)
    }

    private func accessibilityLabel(for day: DayTotal) -> String {
        let percent = Int((progress(for: day) * 100).rounded())
        let date = day.date.formatted(.dateTime.weekday(.abbreviated).month(.abbreviated).day())
        return "\(date), \(day.grams) grams, \(percent) percent of goal"
    }

    /// Leading blank cells so the first logged day lines up with its weekday.
    private var paddedCells: [HeatmapCell] {
        guard let first = totals.first else { return [] }

        let weekday = Calendar.current.component(.weekday, from: first.date)
        // weekday is 1...7 starting Sunday — matches our column order.
        let leadingBlanks = weekday - 1

        var cells: [HeatmapCell] = Array(repeating: .empty, count: leadingBlanks)
        cells.append(contentsOf: totals.map { .day($0) })
        return cells
    }
}

private enum HeatmapCell {
    case empty
    case day(DayTotal)
}

#Preview {
    MonthHeatmapView(
        totals: ProteinStore.seeded.dailyTotals(forLast: 30),
        goal: 150
    )
    .padding()
    .background(AppTheme.background)
}
