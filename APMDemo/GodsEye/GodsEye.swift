import Foundation

public class GodsEye {

    public static func start(with config: Configuration) {
        if config.monitorItem.contains(.cpu) {
            CPUEye.shared.start()
        }
        if config.monitorItem.contains(.fps) {
//            FPSEye.start()
        }
        if config.monitorItem.contains(.runloopBlock) {
//            RunLoopBlockEye.start()
        }

        if config.monitorStyle.contains(.float) {
            FloatManager.shared.show(items: config.monitorItem)
        }
        if config.monitorStyle.contains(.console) {

        }
    }

    public static func stop() {
        FloatManager.shared.close()
    }
}

extension GodsEye {
    public struct Configuration {

        public var monitorItem: MonitorItem
        public var monitorStyle: MonitorStyle

        static var `default`: Configuration {
            return Configuration(monitorItem: MonitorItem.allItems, monitorStyle: MonitorStyle.allItems)
        }
    }

    public struct MonitorItem: OptionSet {

        public static let cpu = MonitorItem(rawValue: 1 << 0)
        public static let fps = MonitorItem(rawValue: 1 << 1)
        public static let runloopBlock = MonitorItem(rawValue: 1 << 2)

        public static var allItems: MonitorItem = [.cpu, .fps, .runloopBlock]

        public let rawValue: Int
        public init(rawValue: Int) {
            self.rawValue = rawValue
        }
    }

    public struct MonitorStyle: OptionSet {

        public static let float = MonitorStyle(rawValue: 1 << 0)
        public static let console = MonitorStyle(rawValue: 1 << 1)

        public static var allItems: MonitorStyle = [.float, .console]

        public let rawValue: Int
        public init(rawValue: Int) {
            self.rawValue = rawValue
        }
    }
}
