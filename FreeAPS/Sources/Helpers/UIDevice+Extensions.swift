import SwiftUI

extension UIDevice {
    var getDeviceId: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }

        func mapToDevice(identifier: String) -> String {
            switch identifier {
            case "iPhone12,1":
                return "iPhone 11"
            case "iPhone12,8":
                return "iPhone SE (2nd Gen)"

            case "iPhone13,4":
                return "iPhone 12 Pro Max"

            case "iPhone14,4":
                return "iPhone 13 mini"
            case "iPhone14,6":
                return "iPhone SE (3rd Gen)"

            case "iPhone15,2":
                return "iPhone 14 Pro"

            default:
                return identifier
            }
        }

        return mapToDevice(identifier: identifier)
    }

    var getOSInfo: String {
        let os = ProcessInfo.processInfo.operatingSystemVersion
        return String(os.majorVersion) + "." + String(os.minorVersion) + "." + String(os.patchVersion)
    }
}
