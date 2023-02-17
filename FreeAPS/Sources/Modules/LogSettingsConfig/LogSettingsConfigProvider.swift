import Foundation

extension LogSettingsConfig {
    final class Provider: BaseProvider, LogSettingsConfigProvider {
        @Injected() private var settingsManager: SettingsManager!
        private let processQueue = DispatchQueue(label: "LogSettingsProvider.processQueue")

        var logSettings: LogSettings {
            settingsManager.logSettings
        }

        func saveLogSettingsConfig(_ logSettings: LogSettings) {
            processQueue.async {
                self.storage.save(logSettings, as: OpenAPS.Settings.logsettings)
            }
        }
    }
}
