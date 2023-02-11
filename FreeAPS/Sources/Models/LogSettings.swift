import Foundation

struct LogSettings: JSON {
    var checkpointLogging: Bool = false
}

extension LogSettings {
    private enum CodingKeys: String, CodingKey {
        case checkpointLogging = "checkpoint_logging"
    }
}
