import SwiftUI

extension LogSettingsConfig {
    final class StateModel: BaseStateModel<Provider> {
        @Published var omniBLEDebug = false

        override func subscribe() {
            subscribeSetting(\.omniBLEDebug, on: $omniBLEDebug) { omniBLEDebug = $0 }
        }
    }
}
