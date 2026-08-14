import Foundation
import Observation

/// User-customised quick-add tiles, persisted between launches.
@Observable
final class QuickAddDirectory {
    static let maxItems = 8

    private enum Key {
        static let items = "foods.quickAddItems"
    }

    private let defaults: UserDefaults
    var items: [QuickAddItem]

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
        if let data = defaults.data(forKey: Key.items),
           let decoded = try? JSONDecoder().decode([QuickAddItem].self, from: data),
           !decoded.isEmpty {
            items = decoded
        } else {
            items = QuickAddItem.defaults
        }
    }

    var canAdd: Bool { items.count < Self.maxItems }

    func add(_ item: QuickAddItem) {
        guard canAdd else { return }
        items.append(item)
        persist()
    }

    func update(_ item: QuickAddItem) {
        guard let index = items.firstIndex(where: { $0.id == item.id }) else { return }
        items[index] = item
        persist()
    }

    func remove(_ item: QuickAddItem) {
        items.removeAll { $0.id == item.id }
        if items.isEmpty {
            items = QuickAddItem.defaults
        }
        persist()
    }

    func move(from source: IndexSet, to destination: Int) {
        items.move(fromOffsets: source, toOffset: destination)
        persist()
    }

    func resetToDefaults() {
        items = QuickAddItem.defaults
        persist()
    }

    private func persist() {
        guard let data = try? JSONEncoder().encode(items) else { return }
        defaults.set(data, forKey: Key.items)
    }

    static var preview: QuickAddDirectory {
        QuickAddDirectory(defaults: UserDefaults(suiteName: "preview.quickAdd") ?? .standard)
    }
}
