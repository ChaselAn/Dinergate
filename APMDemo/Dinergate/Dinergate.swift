import Foundation
import DinergateBrain

public class Dinergate {
    
    struct Test: Decodable {
        let value: Int
    }
    
    public static var appInfo: String = _appInfo
    
    private static var _appInfo: String {
        var str = ""
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            str += "app version: \(version)"
        }
        
        if let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String {
            str += "- build: \(build)"
        }
        return str
    }

    public static func start(items: DinergateBrain.Items = .all) {
        DinergateBrain.shared.start(items: items)
        FloatManager.shared.show(items: .fps)
        DBManager.shared.config()
        
        CrashMonitor.shared.crashHappening = { type in
            switch type {
            case .exception(let exception):
                let callStack = exception.callStackSymbols.joined(separator: "\n")
                DBManager.shared.insertCrash(title: exception.name.rawValue, desc: exception.reason, callStack: callStack, date: Date(), appInfo: appInfo)
            case .singal(let code, let name):
                let callStack = Thread.callStackSymbols.joined(separator: "\n")
                DBManager.shared.insertCrash(title: name, desc: "\(code)", callStack: callStack, date: Date(), appInfo: appInfo)
            }
        }
    }

    public static func stop() {
        FloatManager.shared.close()
        DinergateBrain.shared.stop()
    }
    
    public static func showMenu() {
        Menu.shared.show()
    }
}

//// MARK: - Configuration
//extension Dinergate {
//    public struct Configuration {
//
//        public var monitorItem: MonitorItem
//        public var monitorStyle: MonitorStyle
//
//        public static var `default`: Configuration {
//            return Configuration(monitorItem: [.mainThreadStuck], monitorStyle: [])
//        }
//    }
//}
//
//// MARK: - MonitorItem
extension Dinergate {
    public struct FloatItem: OptionSet {

        public static let cpu = FloatItem(rawValue: 1 << 0)
        public static let fps = FloatItem(rawValue: 1 << 1)

        public static var allItems: FloatItem = [.cpu, .fps]
        var count: Int {
            var _count = 0
            if contains(.cpu) {
                _count += 1
            }
            if contains(.fps) {
                _count += 1
            }
            return _count
        }

        public let rawValue: Int
        public init(rawValue: Int) {
            self.rawValue = rawValue
        }
    }
}
//
//// MARK: - MonitorStyle
//extension Dinergate {
//    public struct MonitorStyle: OptionSet {
//
//        public static let float = MonitorStyle(rawValue: 1 << 0)
//
//        public static var allItems: MonitorStyle = [.float]
//
//        public let rawValue: Int
//        public init(rawValue: Int) {
//            self.rawValue = rawValue
//        }
//    }
//}
//
//// MARK: - MonitorChangeHandler
//extension Dinergate {
//    public enum MonitorChangeType {
//
//        case cpu(Float) // percent
//        case fps(Int)
//        case mainThreadStuck(StuckMonitor.StuckType)
//    }
//}
