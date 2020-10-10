import Foundation
import DinergateBrain

public class Dinergate {
    
    public static func start(items: DinergateBrain.Items = .all) {
        DinergateBrain.shared.start(items: items)
        FloatManager.shared.show(items: .fps)
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
