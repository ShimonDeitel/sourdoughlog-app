import Foundation
import Combine

@MainActor
final class Store: ObservableObject {
    static let freeLimit = 30

    @Published var items: [Feeding] = []
    @Published var enabledCategories: Set<String> = ["All"]

    private let fileURL: URL

    init() {
        let dir = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)[0]
            .appendingPathComponent("sourdoughlog", isDirectory: true)
        try? FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true)
        fileURL = dir.appendingPathComponent("items.json")
        load()
    }

    func load() {
        guard let data = try? Data(contentsOf: fileURL),
              let decoded = try? JSONDecoder().decode([Feeding].self, from: data) else {
            items = Self.seedData()
            save()
            return
        }
        items = decoded
    }

    func save() {
        guard let data = try? JSONEncoder().encode(items) else { return }
        try? data.write(to: fileURL)
    }

    func canAddMore(isPro: Bool) -> Bool {
        isPro || items.count < Self.freeLimit
    }

    @discardableResult
    func add(_ item: Feeding, isPro: Bool) -> Bool {
        guard canAddMore(isPro: isPro) else { return false }
        items.insert(item, at: 0)
        save()
        return true
    }

    func update(_ item: Feeding) {
        guard let idx = items.firstIndex(where: { $0.id == item.id }) else { return }
        items[idx] = item
        save()
    }

    func delete(at offsets: IndexSet) {
        items.remove(atOffsets: offsets)
        save()
    }

    func delete(id: UUID) {
        items.removeAll { $0.id == id }
        save()
    }

    static func seedData() -> [Feeding] {
        [
            Feeding(title: "Morning feed", hydrationRatio: 75.0, riseTimeHours: 6.0),
            Feeding(title: "Evening feed", hydrationRatio: 80.0, riseTimeHours: 8.0),
            Feeding(title: "Weekend feed", hydrationRatio: 70.0, riseTimeHours: 5.0)
        ]
    }
}
