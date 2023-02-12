import SwiftUI
import Swinject

extension LogSettingsConfig {
    struct RootView: BaseView {
        let resolver: Resolver
        @StateObject var state = StateModel()

        var body: some View {
            Form {
                Section {
                    Toggle("Enable OmniBLE Debug Logs", isOn: $state.omniBLEDebug)
                }
            }
            .onAppear(perform: configureView)
            .navigationTitle("Log Settings")
            .navigationBarTitleDisplayMode(.automatic)
        }
    }
}
