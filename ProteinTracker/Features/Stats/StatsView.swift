import Charts
import SwiftUI

struct StatsView: View {
    @Bindable var viewModel: StatsViewModel

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    rangePicker
                    summaryTiles
                    chartCard
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 32)
            }
            .background(AppTheme.background)
            .navigationTitle("Stats")
        }
    }

    private var rangePicker: some View {
        Picker("Range", selection: $viewModel.range) {
            ForEach(StatsViewModel.Range.allCases) { range in
                Text(range.rawValue).tag(range)
            }
        }
        .pickerStyle(.segmented)
    }

    private var summaryTiles: some View {
        VStack(spacing: 12) {
            HStack(spacing: 12) {
                StatTile(label: "Avg / day", value: "\(viewModel.averagePerDay)g")
                StatTile(label: "Hit rate", value: viewModel.hitRate)
            }
            HStack(spacing: 12) {
                StatTile(label: "Best day", value: "\(viewModel.bestDay)g")
                StatTile(label: "Streak", value: "\(viewModel.streak) days")
            }
        }
    }

    private var chartCard: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                Text(viewModel.range == .month ? "Month at a glance" : "Daily protein")
                    .font(.headline)
                    .foregroundStyle(AppTheme.ink)

                Spacer()

                Text("Goal \(viewModel.goal)g")
                    .font(.caption.weight(.medium))
                    .foregroundStyle(AppTheme.ink.opacity(0.5))
            }

            if viewModel.range == .month {
                MonthHeatmapView(totals: viewModel.totals, goal: viewModel.goal)
            } else {
                weekChart
            }
        }
        .padding(18)
        .glassEffect(.regular, in: .rect(cornerRadius: 28))
    }

    private var weekChart: some View {
        Chart {
            ForEach(viewModel.totals) { day in
                BarMark(
                    x: .value("Day", day.date, unit: .day),
                    y: .value("Grams", day.grams)
                )
                .foregroundStyle(AppTheme.barGradient)
                .cornerRadius(6)
            }

            RuleMark(y: .value("Goal", viewModel.goal))
                .lineStyle(StrokeStyle(lineWidth: 1, dash: [5, 4]))
                .foregroundStyle(AppTheme.forest.opacity(0.5))
        }
        .chartXAxis {
            AxisMarks(values: .stride(by: .day)) { _ in
                AxisValueLabel(format: .dateTime.weekday(.narrow))
            }
        }
        .chartYAxis {
            AxisMarks(position: .leading)
        }
        .frame(height: 240)
    }
}

#Preview {
    StatsView(viewModel: StatsViewModel(store: .seeded))
}
