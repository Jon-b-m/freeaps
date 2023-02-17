import Foundation

struct LogSettings: JSON {
    var omniBLEDebug: Bool = false
}

extension LogSettings {
    private enum CodingKeys: String, CodingKey {
        case omniBLEDebug = "omnible_debug"
    }
}
