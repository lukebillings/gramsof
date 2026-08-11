import Foundation
import Observation

/// In-memory source of truth for logged protein. Swap the seeding for a persistence
/// layer without touching the view models that read from it.
@Observable
final class ProteinStore {
    var entries: [ProteinEntry]
    var dailyGoal: Int
    var showsRemainingOnRing = true

    private let calendar = Calendar.current

    init(entries: [ProteinEntry] = [], dailyGoal: Int = 150) {
        self.entries = entries
        self.dailyGoal = dailyGoal
    }

    // MARK: - Mutations

    func add(_ entry: ProteinEntry) {
        entries.append(entry)
    }

    func remove(_ entry: ProteinEntry) {
        entries.removeAll { $0.id == entry.id }
    }

    func removeToday() {
        let todayIDs = Set(todayEntries.map(\.id))
        entries.removeAll { todayIDs.contains($0.id) }
    }

    func removeAllEntries() {
        entries.removeAll()
    }

    func updateGrams(for entry: ProteinEntry, to grams: Int) {
        guard grams > 0, let index = entries.firstIndex(where: { $0.id == entry.id }) else { return }
        entries[index].grams = grams
    }

    // MARK: - Today

    var todayEntries: [ProteinEntry] {
        entries
            .filter { calendar.isDateInToday($0.loggedAt) }
            .sorted { $0.loggedAt > $1.loggedAt }
    }

    var todayTotal: Int {
        todayEntries.reduce(0) { $0 + $1.grams }
    }

    // MARK: - History

    func total(on date: Date) -> Int {
        entries(on: date).reduce(0) { $0 + $1.grams }
    }

    func entries(on date: Date) -> [ProteinEntry] {
        entries
            .filter { calendar.isDate($0.loggedAt, inSameDayAs: date) }
            .sorted { $0.loggedAt > $1.loggedAt }
    }

    /// Daily totals ending today, oldest first.
    func dailyTotals(forLast days: Int) -> [DayTotal] {
        let today = calendar.startOfDay(for: .now)
        return (0..<days).reversed().compactMap { offset in
            guard let date = calendar.date(byAdding: .day, value: -offset, to: today) else { return nil }
            return DayTotal(date: date, grams: total(on: date))
        }
    }

    // MARK: - Sample data

    static var seeded: ProteinStore {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: .now)
        let goal = 150
        let templates = QuickAddItem.favourites
        var entries: [ProteinEntry] = []

        for offset in 1...45 {
            guard let day = calendar.date(byAdding: .day, value: -offset, to: today) else { continue }
            // Weekends run lighter so the goal line is met roughly five days in seven.
            let isWeekend = calendar.isDateInWeekend(day)
            let dayTarget = isWeekend
                ? Int.random(in: 95...140)
                : Int.random(in: 145...195)

            let meals = Int.random(in: 3...4)
            var remaining = dayTarget

            for meal in 0..<meals {
                let isLast = meal == meals - 1
                let grams = isLast ? remaining : max(15, remaining / (meals - meal) + Int.random(in: -8...8))
                remaining -= grams

                let template = templates[(offset + meal) % templates.count]
                let loggedAt = calendar.date(byAdding: .hour, value: 8 + meal * 4, to: day) ?? day
                entries.append(ProteinEntry(name: template.name, grams: grams, loggedAt: loggedAt))
            }
        }

        entries.append(ProteinEntry(name: "Greek yogurt", grams: 17, loggedAt: .now.addingTimeInterval(-9000)))
        entries.append(ProteinEntry(name: "Protein shake", grams: 25, loggedAt: .now.addingTimeInterval(-5400)))
        entries.append(ProteinEntry(name: "Chicken breast", grams: 36, loggedAt: .now.addingTimeInterval(-1800)))

        return ProteinStore(entries: entries, dailyGoal: goal)
    }
}
