import Charts
import SwiftUI

struct StatsView: View {
    @Bindable var viewModel: StatsViewModel
    @State private var selectedDay: DayTotal?

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
            .sheet(item: $selectedDay) { day in
                DayDetailView(
                    date: day.date,
                    entries: viewModel.entries(on: day.date),
                    total: day.grams,
                    goal: viewModel.goal
                )
                .presentationDetents([.medium, .large])
                .presentationDragIndicator(.visible)
            }
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
                StatTile(label: "Average protein intake per day", value: "\(viewModel.averagePerDay)g")
                StatTile(label: "Days reached goal", value: viewModel.hitRate)
            }
            HStack(spacing: 12) {
                StatTile(
                    label: "Highest protein intake",
                    value: viewModel.highestProteinIntakeLabel,
                    detail: viewModel.highestProteinIntakeDate
                )
                StatTile(label: "Goal reached streak", value: "\(viewModel.streak) days")
            }
        }
    }

    private var chartCard: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                if viewModel.range == .month {
                    monthNavigator
                } else {
                    Text("Daily protein")
                        .font(.headline)
                        .foregroundStyle(AppTheme.ink)
                }

                Spacer(minLength: 8)

                Text("Goal \(viewModel.goal)g")
                    .font(.caption.weight(.medium))
                    .foregroundStyle(AppTheme.ink.opacity(0.5))
            }

            if viewModel.range == .month {
                MonthHeatmapView(totals: viewModel.totals, goal: viewModel.goal) { day in
                    selectedDay = day
                }
            } else {
                weekChart
            }
        }
        .padding(18)
        .glassEffect(.regular, in: .rect(cornerRadius: 28))
    }

    private var monthNavigator: some View {
        HStack(spacing: 4) {
            Button {
                viewModel.goToPreviousMonth()
                AppHaptics.selection()
            } label: {
                Image(systemName: "chevron.left")
                    .font(.caption.weight(.bold))
                    .frame(width: 28, height: 28)
            }
            .buttonStyle(.plain)
            .foregroundStyle(AppTheme.forest)
            .accessibilityLabel("Previous month")

            Text(viewModel.displayedMonthTitle)
                .font(.headline)
                .foregroundStyle(AppTheme.ink)
                .lineLimit(1)
                .minimumScaleFactor(0.8)
                .accessibilityAddTraits(.isHeader)

            Button {
                viewModel.goToNextMonth()
                AppHaptics.selection()
            } label: {
                Image(systemName: "chevron.right")
                    .font(.caption.weight(.bold))
                    .frame(width: 28, height: 28)
            }
            .buttonStyle(.plain)
            .foregroundStyle(viewModel.canGoToNextMonth ? AppTheme.forest : AppTheme.ink.opacity(0.25))
            .disabled(!viewModel.canGoToNextMonth)
            .accessibilityLabel("Next month")
        }
    }

    private var weekChart: some View {
        Chart {
            ForEach(viewModel.totals) { day in
                BarMark(
                    x: .value("Day", day.date, unit: .day),
                    y: .value("Grams", day.grams)
                )
                .foregroundStyle(AppTheme.progressFill(grams: day.grams, goal: viewModel.goal))
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
