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

    init(store: ProteinStore) {
        self.store = store
    }

    var goal: Int { store.dailyGoal }

    var totals: [DayTotal] {
        store.dailyTotals(forLast: range.days)
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
        var count = 0
        for day in totals.reversed() {
            guard day.grams >= goal else { break }
            count += 1
        }
        return count
    }

    func entries(on date: Date) -> [ProteinEntry] {
        store.entries(on: date)
    }
}
