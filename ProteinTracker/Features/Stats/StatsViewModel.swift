import Foundation
import Observation

@Observable
final class StatsViewModel {
    enum Range: String, CaseIterable, Identifiable {
        case week = "Week"
        case month = "Month"

        var id: String { rawValue }

        var days: Int {
            switch self {
            case .week: 7
            case .month: 30
            }
        }
    }

    let store: ProteinStore
    var range: Range = .week
    /// First day of the month shown in the heatmap. Defaults to this month.
    var displayedMonth: Date = StatsViewModel.startOfMonth(containing: .now)

    init(store: ProteinStore) {
        self.store = store
    }

    var goal: Int { store.dailyGoal }

    var totals: [DayTotal] {
        switch range {
        case .week:
            store.dailyTotals(forLast: range.days)
        case .month:
            store.dailyTotals(inMonth: displayedMonth)
        }
    }

    var displayedMonthTitle: String {
        displayedMonth.formatted(.dateTime.month(.wide).year())
    }

    var canGoToNextMonth: Bool {
        let calendar = Calendar.current
        guard let next = calendar.date(byAdding: .month, value: 1, to: displayedMonth) else { return false }
        return calendar.compare(next, to: .now, toGranularity: .month) != .orderedDescending
    }

    func goToPreviousMonth() {
        guard let previous = Calendar.current.date(byAdding: .month, value: -1, to: displayedMonth) else { return }
        displayedMonth = Self.startOfMonth(containing: previous)
    }

    func goToNextMonth() {
        guard canGoToNextMonth,
              let next = Calendar.current.date(byAdding: .month, value: 1, to: displayedMonth)
        else { return }
        displayedMonth = Self.startOfMonth(containing: next)
    }

    private static func startOfMonth(containing date: Date) -> Date {
        Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: date)) ?? date
    }

    var averagePerDay: Int {
        let days = totals
        guard !days.isEmpty else { return 0 }
        return days.reduce(0) { $0 + $1.grams } / days.count
    }

    var daysHitGoal: Int {
        totals.filter { $0.grams >= goal }.count
    }

    var hitRate: String {
        "\(daysHitGoal)/\(totals.count)"
    }

    /// Day with the most protein in the selected range.
    var highestProteinDay: DayTotal? {
        totals.max(by: { $0.grams < $1.grams })
    }

    var highestProteinIntakeLabel: String {
        guard let day = highestProteinDay else { return "0g" }
        return "\(day.grams)g"
    }

    var highestProteinIntakeDate: String? {
        guard let day = highestProteinDay, day.grams > 0 else { return nil }
        return day.date.formatted(.dateTime.weekday(.abbreviated).month(.abbreviated).day())
    }

    /// Consecutive days ending today where the goal was met.
    var streak: Int {
        store.currentStreak
    }

    func entries(on date: Date) -> [ProteinEntry] {
        store.entries(on: date)
    }
}
