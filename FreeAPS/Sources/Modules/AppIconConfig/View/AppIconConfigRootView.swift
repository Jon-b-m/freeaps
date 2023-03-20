import SwiftUI
import Swinject

class NamesOfIcon: ObservableObject {
    var namesOfIcon: [String?] = [nil]

    @Published var iconCount = 0

    init() {
        getAlternateIcons()

        if let currentIcon = UIApplication.shared.alternateIconName {
            // if let currentIcon = Bundle.main.infoDictionary?["CFBundleIcons"] as? [String: Any] {
            iconCount = namesOfIcon.firstIndex(of: currentIcon) ?? 0
        }
    }

    func getAlternateIcons()
    {
        // looking into our info.plist file to locate the specific Bundle with our icons
        if let icons = Bundle.main.object(forInfoDictionaryKey: "CFBundleIcons") as? [String: Any],
           let alternateIcons = icons["CFBundleAlternateIcons"] as? [String: Any]
        {
            for (_, value) in alternateIcons {
                // Accessing the name of icon list inside the dictionary
                guard let iconList = value as? [String: Any] else { return }
                // Accessing the name of icon files
                // guard let iconFiles = iconList["CFBundleIconFiles"] as? [String]
                /* guard let iconFiles = iconList["CFBundleIconName"] as? [String]
                 else { return } */
                // Accessing the name of the icon
                // guard let icon = iconFiles.first else { return }
                namesOfIcon.append(iconList.values.first as! String)
            }
        }
    }
}

extension AppIconConfig {
    // struct RootView: AppIconView.environmentObject(NamesOfIcon())
    /*     struct RootView: BaseView {
     let resolver: Resolver
     @StateObject var state = StateModel()

     func GetAppIcon(isPrimary: Bool) -> UIImage {
     var appIcon: UIImage! {
     if isPrimary == true {
     guard let iconsDictionary = Bundle.main.infoDictionary?["CFBundleIcons"] as? [String: Any],
     let primaryIconsDictionary = iconsDictionary["CFBundlePrimaryIcon"] as? [String: Any],
     let iconFiles = primaryIconsDictionary["CFBundleIconFiles"] as? [String],
     let lastIcon = iconFiles.last else { return nil }
     return UIImage(named: lastIcon)
     } else {
     guard let iconsDictionary = Bundle.main.infoDictionary?["CFBundleIcons"] as? [String: Any],
     let alternateIconsDictionary = iconsDictionary["CFBundleAlternateIcons"] as? [String: Any],
     let altIconName = alternateIconsDictionary["AppIconAlternate1"] as? [String: Any],
     let iconFiles = altIconName["CFBundleIconFiles"] as? [String],
     let lastIcon = iconFiles.last else { return nil }
     return UIImage(named: lastIcon)
     }
     }

     return appIcon
     }

     @AppStorage("active_icon") var activeAppIcon: String = "AppIcon"
     var body: some View {
     NavigationStack {
     Picker(selection: $activeAppIcon) {
     let customIcons: [String] = ["AppIcon", "AppIcon_BW"]
     ForEach(customIcons, id: \.self) { icon in
     Text(icon)
     .tag(icon)
     }
     } label: {}
     .navigationTitle("Alternative App Icon")
     }
     .onChange(of: activeAppIcon) { newValue in
     UIApplication.shared.setAlternateIconName(newValue)
     }

     /*
      Form {
      Section {
      // Toggle("Connect to Apple Health", isOn: $state.useAppIcon)

      HStack {
      // Image(systemName: "pencil.circle.fill")
      // Image(uiImage: UIImage(named: GetAppIcon().String) ?? UIImage())
      Image(uiImage: GetAppIcon(isPrimary: false))
      Text(
      "Default AppIcon"
      )
      // .font(.caption)
      }
      // .foregroundColor(Color.secondary)
      HStack {
      Image(systemName: "exclamationmark.circle.fill")
      Text("For write data to Apple Health you must give permissions in Settings > Health > Data Access")
      .font(.caption)
      }
      }*/
     }

     /* .onAppear(perform: configureView)
      .navigationTitle("AppIcon Change")
      .navigationBarTitleDisplayMode(.automatic)*/
     }
     } */
    /* func addItem() {
     // print("test")

     let iconsDictionary = Bundle.main.infoDictionary?["CFBundleIcons"] as? [String: Any]
     let alternateIconsDictionary = iconsDictionary!["CFBundleAlternateIcons"] as? [String: Any]
     let altIconName = alternateIconsDictionary!["AppIconAlternate1"] as? [String: Any]
     }*/

    struct ContentView: View {
        @AppStorage("active_icon") var activeAppIcon: String = "AppIcon"

        var body: some View {
            NavigationStack {
                Picker(selection: $activeAppIcon) {
                    let customIcons: [String] = ["AppIcon", "AppIcon_BW"]
                    ForEach(customIcons, id: \.self) { icon in
                        Text(icon)
                            .tag(icon)
                    }
                } label: {}
                    .navigationTitle("Alternative App Icon")
            }

            .onChange(of: activeAppIcon) {
                newValue in
                if newValue == "AppIcon" {
                    UIApplication.shared.setAlternateIconName(nil)
                } else {
                    UIApplication.shared.setAlternateIconName(newValue)
                }
            }
        }
    }

    struct AppIconView2: View {
        // @AppStorage("active_icon") var activeAppIcon: String = "AppIcon"
        var body: some View {
            /* Image("1024 2")
             .resizable()
             .scaledToFit()
             .cornerRadius(10)
             .padding() */
            Button(action: {
                let iconsDictionary = Bundle.main.infoDictionary?["CFBundleIcons"] as? [String: Any]
                print(iconsDictionary?.first?.value as Any)

            })
                {
                    Label { Text("Default Icon").font(.callout.bold()) }
                    icon: { Image(uiImage: UIImage(named: "AppIcon_RED") ?? UIImage())
                        .resizable()
                        .scaledToFit()
                        .padding()
                        .cornerRadius(10)
                        .frame(width: 80, height: 80)
                    }
                }
        }
    }

    // TODO: change font color when changing iOS to dark mode
    struct AppIconView3: View {
        @Environment(\.colorScheme) var colorScheme
        @StateObject var iconSettings = NamesOfIcon()
        var body: some View {
            Section {
                ForEach(0 ..< $iconSettings.namesOfIcon.count) { i in
                    Button(action: {
                        if self.iconSettings.namesOfIcon[i] == "AppIcon" {
                            UIApplication.shared.setAlternateIconName(nil)
                        } else {
                            UIApplication.shared.setAlternateIconName(self.iconSettings.namesOfIcon[i])
                        }

                    })
                        {
                            Label { Text(self.iconSettings.namesOfIcon[i] ?? "AppIcon") }
                            icon: { Image(uiImage: UIImage(named: self.iconSettings.namesOfIcon[i] ?? "AppIcon") ?? UIImage())
                                .resizable()
                                .scaledToFit()
                                // .border(.red)

                                // .frame(width: 80, height: 80, alignment: .topLeading)
                            }
                        }
                }.frame(width: 200, height: 45, alignment: .topLeading)
                // .border(.green)
            }
            .navigationTitle("Change App Icon")
            .foregroundColor(colorScheme == .dark ? .white : .black)

            .frame(alignment: .topLeading)
            // .padding(.top, -50)
            // .border(.yellow)

            // .scaledToFit()

            // .frame(alignment: .leading)
        }
    }

    // --------------------------------Final View--------------------------------------------------------
    struct RootView: BaseView {
        let resolver: Resolver
        @StateObject var state = StateModel()
        @StateObject var iconSettings = NamesOfIcon()
        var body: some View {
            Form {
                Section(
                    header: Text(
                        "This feature allows to change the AppIcon on FAX that you see on the Home Screen\n\nIt dynamically fetches all AppIcons that are available in FreeAPS->Resources->Assets.xcassets\nYou can add your own icon easilly with right-click. Select iOS->New iOS App Icon. Add one .png image with size 1024x1024. Done"
                    ).font(.body)
                )
                    {}
                VStack {
                    ForEach(0 ..< $iconSettings.namesOfIcon.count) { i in
                        Button(action: {
                            if self.iconSettings.namesOfIcon[i] == "AppIcon" {
                                UIApplication.shared.setAlternateIconName(nil)
                            } else {
                                UIApplication.shared.setAlternateIconName(self.iconSettings.namesOfIcon[i])
                            }

                        })
                            {
                                Label { Text(self.iconSettings.namesOfIcon[i] ?? "AppIcon") }
                                icon: { Image(uiImage: UIImage(named: self.iconSettings.namesOfIcon[i] ?? "AppIcon") ?? UIImage())
                                    .resizable()
                                    .scaledToFit()
                                    .border(.red)

                                    // .frame(width: 80, height: 80, alignment: .topLeading)
                                }
                            }
                    }.frame(width: 200, height: 40, alignment: .topLeading)
                        .border(.green)
                }
            }
            // }
            .onAppear(perform: configureView)
            // .alignmentGuide(HorizontalAlignment.leading) { _ in 80 }
            // .scaledToFit()
            .navigationTitle("Change App Icon")
            .navigationBarTitleDisplayMode(.automatic)
            // .foregroundColor(.black)
            // .frame(alignment: .topLeading)
            // .padding(.top, -200)
            // .border(.yellow)
            // .navigationViewStyle(.stack)
            // .scaledToFit()

            // .frame(alignment: .leading)
        }
    }

    // --------------------------------Final View--------------------------------------------------------
}

// }
