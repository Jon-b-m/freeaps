import Foundation
import SwiftUI
import Swinject

@main struct FreeAPSApp: App {
    @Environment(\.scenePhase) var scenePhase
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    // Dependencies Assembler
    // contain all dependencies Assemblies
    // TODO: Remove static key after update "Use Dependencies" logic
    private static var assembler = Assembler([
        StorageAssembly(),
        ServiceAssembly(),
        APSAssembly(),
        NetworkAssembly(),
        UIAssembly(),
        SecurityAssembly()
    ], parent: nil, defaultObjectScope: .container)

    var resolver: Resolver {
        FreeAPSApp.assembler.resolver
    }

    // Temp static var
    // Use to backward compatibility with old Dependencies logic on Logger
    // TODO: Remove var after update "Use Dependencies" logic in Logger
    static var resolver: Resolver {
        FreeAPSApp.assembler.resolver
    }

    private func recordRestart() {
        let storage = resolver.resolve(FileStorage.self)!
        let file = OpenAPS.Monitor.restarts
        var testFile: [Restarts] = []

        debug(
            .default,
            "FreeAPS X Started: v\(Bundle.main.releaseVersionNumber ?? "")(\(Bundle.main.buildVersionNumber ?? "")) [buildDate: \(Bundle.main.buildDate)]"
        )

        storage.transaction { storage in
            testFile = storage.retrieve(file, as: [Restarts].self) ?? []
        }

        let restarts = Restarts(
            created_at: Date(),
            Build_Version: Bundle.main.releaseVersionNumber ?? "",
            Build_Number: Bundle.main.buildVersionNumber ?? "1",
            Build_Date: Bundle.main.buildDate
        )

        storage.transaction { storage in
            storage.append(restarts, to: file, uniqBy: \.created_at)
            var uniqeEvents: [Restarts] = storage.retrieve(file, as: [Restarts].self)?
                .filter { $0.created_at.addingTimeInterval(24.hours.timeInterval) > Date() }
                .sorted { $0.created_at > $1.created_at } ?? []

            storage.save(Array(uniqeEvents), as: file)
        }
    }

    private func loadServices() {
        resolver.resolve(AppearanceManager.self)!.setupGlobalAppearance()
        _ = resolver.resolve(DeviceDataManager.self)!
        _ = resolver.resolve(APSManager.self)!
        _ = resolver.resolve(FetchGlucoseManager.self)!
        _ = resolver.resolve(FetchTreatmentsManager.self)!
        _ = resolver.resolve(FetchAnnouncementsManager.self)!
        _ = resolver.resolve(CalendarManager.self)!
        _ = resolver.resolve(UserNotificationsManager.self)!
        _ = resolver.resolve(WatchManager.self)!
        _ = resolver.resolve(HealthKitManager.self)!
        _ = resolver.resolve(BluetoothStateManager.self)!
    }

    init() {
        recordRestart()
        loadServices()
    }

    var body: some Scene {
        WindowGroup {
            Main.RootView(resolver: resolver)
        }
        .onChange(of: scenePhase) { newScenePhase in
            debug(.default, "APPLICATION PHASE: \(newScenePhase)")
        }
    }
}
