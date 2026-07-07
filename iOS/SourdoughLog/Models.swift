import Foundation

struct Feeding: Identifiable, Codable, Equatable {
    var id: UUID = UUID()
    var title: String
    var hydrationRatio: Double = 0.0
    var riseTimeHours: Double = 0.0
    var notes: String = ""
    var dateAdded: Date = Date()
}
