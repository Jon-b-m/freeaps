import SwiftUI

enum durationState {
    case day
    case week
    case month
    case total

    var nextStatus: durationState {
        switch self {
        case .day: return .week
        case .week: return .month
        case .month: return .total
        case .total: return .day
        }
    }

    var title: String {
        switch self {
        case .day: return NSLocalizedString("24 hours ", comment: "timeframe for statsitics in hours")
        case .week: return NSLocalizedString("7 days ", comment: "timeframe for statsitics in days")
        case .month: return NSLocalizedString("30 days ", comment: "timeframe for statsitics in days")
        case .total: return NSLocalizedString("All data ", comment: "timeframe for statsitics in days")
        }
    }

    var color: Color {
        switch self {
        case .day: return .loopYellow
        case .week: return .insulin
        case .month: return .loopGreen
        case .total: return .loopGray
        }
    }
}

struct durationButton: View {
    @Binding var selectedState: durationState

    var body: some View {
        Button {
            selectedState = selectedState.nextStatus
        }
        label: {
            Text(selectedState.title)
                .foregroundColor(selectedState.color)
                .font(.caption)
        }
        .buttonBorderShape(.automatic)
        .controlSize(.mini)
        .buttonStyle(.bordered)
    }
}
