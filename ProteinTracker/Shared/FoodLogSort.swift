import Foundation

enum FoodLogSort: String, CaseIterable, Identifiable {
    case newest
    case highestProtein

    var id: String { rawValue }

    var title: String {
        switch self {
        case .newest: "Newest"
        case .highestProtein: "Highest protein"
        }
    }
}
