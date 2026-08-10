import SwiftUI

/// GitHub-style contribution grid: solid emerald the closer a day is to the goal.
struct MonthHeatmapView: View {
    let totals: [DayTotal]
    let goal: Int

    private let columns = Array(repeating: GridItem(.flexible(), spacing: 6), count: 7)
    private let weekdayLabels = ["S", "M", "T", "W", "T", "F", "S"]

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 6) {
                ForEach(Array(weekdayLabels.enumerated()), id: \.offset) { _, label in
                    Text(label)
                        .font(.caption2.weight(.semibold))
                        .foregroundStyle(AppTheme.ink.opacity(0.4))
                        .frame(maxWidth: .infinity)
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
        HStack(spacing: 6) {
            Text("Less")
                .font(.caption2)
                .foregroundStyle(AppTheme.ink.opacity(0.4))

            ForEach([0.0, 0.4, 0.65, 0.85, 1.0], id: \.self) { progress in
                RoundedRectangle(cornerRadius: 4, style: .continuous)
                    .fill(fill(for: progress))
                    .frame(width: 12, height: 12)
            }

            Text("Goal")
                .font(.caption2)
                .foregroundStyle(AppTheme.ink.opacity(0.4))
        }
        .frame(maxWidth: .infinity, alignment: .trailing)
        .padding(.top, 4)
    }

    @ViewBuilder
    private func square(for cell: HeatmapCell) -> some View {
        switch cell {
        case .empty:
            Color.clear
                .aspectRatio(1, contentMode: .fit)
        case .day(let total):
            RoundedRectangle(cornerRadius: 6, style: .continuous)
                .fill(fill(for: progress(for: total)))
                .aspectRatio(1, contentMode: .fit)
                .accessibilityLabel(accessibilityLabel(for: total))
        }
    }

    private func progress(for day: DayTotal) -> Double {
        guard goal > 0 else { return 0 }
        return min(Double(day.grams) / Double(goal), 1)
    }

    private func fill(for progress: Double) -> Color {
        switch progress {
        case 0:
            return AppTheme.mint.opacity(0.3)
        case ..<0.5:
            return AppTheme.emerald.opacity(0.28)
        case ..<0.75:
            return AppTheme.emerald.opacity(0.5)
        case ..<1:
            return AppTheme.emerald.opacity(0.72)
        default:
            return AppTheme.emerald
        }
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
