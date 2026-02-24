import Foundation

enum ExportFormat: String, CaseIterable, Identifiable {
    case text = "Text"
    case json = "JSON"

    var id: String { rawValue }
}
