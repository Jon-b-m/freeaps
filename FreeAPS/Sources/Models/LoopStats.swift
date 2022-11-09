import Foundation

struct LoopStats: JSON, Equatable {
    var createdAt: Date
    var loopStatus: String

    init(
        createdAt: Date,
        loopStatus: String
    ) {
        self.createdAt = createdAt
        self.loopStatus = loopStatus
    }

    static func == (lhs: LoopStats, rhs: LoopStats) -> Bool {
        lhs.createdAt == rhs.createdAt
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(createdAt)
    }
}

extension LoopStats {
    private enum CodingKeys: String, CodingKey {
        case createdAt
        case loopStatus
    }
}
