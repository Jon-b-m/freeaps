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
        case .day: return "24hr "
        case .week: return "7d  "
        case .month: return "30d "
        case .total: return "All data "
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
