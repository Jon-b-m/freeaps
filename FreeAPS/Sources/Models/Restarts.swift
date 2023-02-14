import Foundation

struct Restarts: JSON, Equatable {
    var created_at: Date
    var Build_Version: String
    var Build_Number: String
    var Build_Date: Date

    init(
        created_at: Date,
        Build_Version: String,
        Build_Number: String,
        Build_Date: Date
    ) {
        self.created_at = created_at
        self.Build_Version = Build_Version
        self.Build_Number = Build_Number
        self.Build_Date = Build_Date
    }

    static func == (lhs: Restarts, rhs: Restarts) -> Bool {
        lhs.created_at == rhs.created_at
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(created_at)
    }
}

extension Restarts {
    private enum CodingKeys: String, CodingKey {
        case created_at
        case Build_Version
        case Build_Number
        case Build_Date
    }
}
