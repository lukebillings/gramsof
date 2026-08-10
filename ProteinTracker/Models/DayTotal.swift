import Foundation

struct DayTotal: Identifiable, Hashable {
    var id: Date { date }
    let date: Date
    let grams: Int
}
