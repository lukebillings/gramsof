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
            let migrated = Self.migratingEggsDefault(
                in: Self.migratingGreekYogurtDefault(in: decoded)
            )
            items = migrated
            if migrated != decoded {
                persist()
            }
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

    /// Older installs used a 170g pot; keep the shortcut on 100g unless the user changed it.
    private static func migratingGreekYogurtDefault(in items: [QuickAddItem]) -> [QuickAddItem] {
        var didMigrate = false
        let migrated = items.map { item -> QuickAddItem in
            guard item.name.caseInsensitiveCompare("Greek yogurt") == .orderedSame,
                  item.portionGrams == 170 else { return item }
            var updated = item
            updated.setPortionGrams(100)
            didMigrate = true
            return updated
        }
        return didMigrate ? migrated : items
    }

    /// Older installs used 2 large eggs; switch the default shortcut to 3 unless the user changed it.
    private static func migratingEggsDefault(in items: [QuickAddItem]) -> [QuickAddItem] {
        var didMigrate = false
        let migrated = items.map { item -> QuickAddItem in
            guard item.name.caseInsensitiveCompare("Eggs") == .orderedSame,
                  item.detail.caseInsensitiveCompare("2 large eggs") == .orderedSame else { return item }
            var updated = item
            updated.detail = "3 large eggs"
            updated.grams = 18
            updated.portionGrams = 150
            didMigrate = true
            return updated
        }
        return didMigrate ? migrated : items
    }

    private func persist() {
        guard let data = try? JSONEncoder().encode(items) else { return }
        defaults.set(data, forKey: Key.items)
    }

    static var preview: QuickAddDirectory {
        QuickAddDirectory(defaults: UserDefaults(suiteName: "preview.quickAdd") ?? .standard)
    }
}
