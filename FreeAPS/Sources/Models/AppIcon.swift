import Foundation

struct AppIcon: JSON, Equatable {
    var createdAt: Date?
    let basalProfile: [BasalProfileEntry]
    let sensitivity: Decimal
    let carbRatio: Decimal
}

extension AppIcon {
    private enum CodingKeys: String, CodingKey {
        case createdAt = "created_at"
        case basalProfile = "basalprofile"
        case sensitivity = "sens"
        case carbRatio = "carb_ratio"
    }
}
