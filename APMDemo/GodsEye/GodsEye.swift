import Foundation

public class GodsEye {

    private static var observer: NSObject?

    public static func start(with config: Configuration, changeHandler: ((MonitorChangeType) -> Void)? = nil) {
        if observer != nil {
            stop()
        }
        observer = NSObject()
        if config.monitorItem.contains(.cpu) {
            CPUEye.shared.start()
            CPUEye.shared.observable.addObserver(observer!) { (_, cpu) in
                changeHandler?(.cpu(cpu))
            }
        }
        if config.monitorItem.contains(.fps) {
            FPSEye.shared.start()
            FPSEye.shared.observable.addObserver(observer!) { (_, fps) in
                changeHandler?(.fps(fps))
            }
        }
        if config.monitorItem.contains(.runloopBlock) {
            RunLoopBlockEye.shared.start()
            RunLoopBlockEye.shared.observable.addObserver(observer!) { (_, blockType) in
                guard let blockType = blockType else { return }
                changeHandler?(.runLoopBlock(blockType))
            }
        }

        if config.monitorStyle.contains(.float) {
            FloatManager.shared.show(items: config.monitorItem)
        }
    }

    public static func stop() {
        observer = nil
        FloatManager.shared.close()
        CPUEye.shared.stop()
        FPSEye.shared.stop()
        RunLoopBlockEye.shared.stop()
    }
}

// MARK: - Configuration
extension GodsEye {
    public struct Configuration {

        public var monitorItem: MonitorItem
        public var monitorStyle: MonitorStyle

        public static var `default`: Configuration {
            return Configuration(monitorItem: [.fps, .runloopBlock], monitorStyle: MonitorStyle.allItems)
        }
    }
}

// MARK: - MonitorItem
extension GodsEye {
    public struct MonitorItem: OptionSet {

        public static let cpu = MonitorItem(rawValue: 1 << 0)
        public static let fps = MonitorItem(rawValue: 1 << 1)
        public static let runloopBlock = MonitorItem(rawValue: 1 << 2)

        public static var allItems: MonitorItem = [.cpu, .fps, .runloopBlock]
        var count: Int {
            var _count = 0
            if contains(.cpu) {
                _count += 1
            }
            if contains(.fps) {
                _count += 1
            }
            if contains(.runloopBlock) {
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
extension GodsEye {
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
extension GodsEye {
    public enum MonitorChangeType {

        case cpu(Float) // percent
        case fps(Int)
        case runLoopBlock(RunLoopBlockEye.BlockType)
    }
}
