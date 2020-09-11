import Foundation

public class AngryMonitor {

    private static var observer: NSObject?

    public static func start(with config: Configuration, changeHandler: ((MonitorChangeType) -> Void)? = nil) {
        if observer != nil {
            stop()
        }
        observer = NSObject()
//        if config.monitorItem.contains(.cpu) {
//            CPUMonitor.shared.start()
//            CPUMonitor.shared.observable.addObserver(observer!) { (_, cpu) in
//                changeHandler?(.cpu(cpu))
//            }
//        }
        if config.monitorItem.contains(.fps) {
            FPSMonitor.shared.start()
            FPSMonitor.shared.observable.addObserver(observer!) { (_, fps) in
                changeHandler?(.fps(fps))
            }
        }
        if config.monitorItem.contains(.mainThreadStuck) {
            StuckMonitor.shared.start()
            StuckMonitor.shared.observable.addObserver(observer!) { (_, stuckType) in
                guard let stuckType = stuckType else { return }
                changeHandler?(.mainThreadStuck(stuckType))
            }
        }

        if config.monitorStyle.contains(.float) {
            FloatManager.shared.show(items: config.monitorItem)
        }
    }

    public static func stop() {
        observer = nil
        FloatManager.shared.close()
//        CPUMonitor.shared.stop()
        FPSMonitor.shared.stop()
        StuckMonitor.shared.stop()
    }
}

// MARK: - Configuration
extension AngryMonitor {
    public struct Configuration {

        public var monitorItem: MonitorItem
        public var monitorStyle: MonitorStyle

        public static var `default`: Configuration {
            return Configuration(monitorItem: [.fps, .mainThreadStuck], monitorStyle: MonitorStyle.allItems)
        }
    }
}

// MARK: - MonitorItem
extension AngryMonitor {
    public struct MonitorItem: OptionSet {

        public static let cpu = MonitorItem(rawValue: 1 << 0)
        public static let fps = MonitorItem(rawValue: 1 << 1)
        public static let mainThreadStuck = MonitorItem(rawValue: 1 << 2)

        public static var allItems: MonitorItem = [.cpu, .fps, .mainThreadStuck]
        var count: Int {
            var _count = 0
            if contains(.cpu) {
                _count += 1
            }
            if contains(.fps) {
                _count += 1
            }
            if contains(.mainThreadStuck) {
                _count += 1
            }
            return _count
        }
        var floatCount: Int {
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

// MARK: - MonitorStyle
extension AngryMonitor {
    public struct MonitorStyle: OptionSet {

        public static let float = MonitorStyle(rawValue: 1 << 0)

        public static var allItems: MonitorStyle = [.float]

        public let rawValue: Int
        public init(rawValue: Int) {
            self.rawValue = rawValue
        }
    }
}

// MARK: - MonitorChangeHandler
extension AngryMonitor {
    public enum MonitorChangeType {

        case cpu(Float) // percent
        case fps(Int)
        case mainThreadStuck(StuckMonitor.StuckType)
    }
}
