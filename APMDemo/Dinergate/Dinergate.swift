import Foundation
import DinergateBrain
import CrashReporter

public class Dinergate {
    
    struct Test: Decodable {
        let value: Int
    }
    
    public static var appInfo: String = _appInfo

    // default items = [.stuck, .crash]
    public static func start(items: DinergateBrain.Items = .default, config: DinergateBrain.Config = .default) {
        self.defaultItems = items
        var brainItems: DinergateBrain.Items = []
        if UserDefaults.standard.value(forKey: MenuSettingItem.stuck.rawValue) as? Bool ?? items.contains(.stuck) {
            brainItems.insert(.stuck)
        }
        if UserDefaults.standard.value(forKey: MenuSettingItem.crash.rawValue) as? Bool ?? items.contains(.crash) {
            brainItems.insert(.crash)
        }
        if UserDefaults.standard.value(forKey: MenuSettingItem.fps.rawValue) as? Bool ?? items.contains(.fps) {
            brainItems.insert(.fps)
        }
        DinergateBrain.shared.start(items: brainItems, config: config)
        if brainItems.contains(.fps) {
            FloatManager.shared.show(items: .fps)
        }
        DBManager.shared.config()
        
        CrashMonitor.shared.crashHappening = { type in
            switch type {
            case .exception(let exception):
                let callStack = exception.callStackSymbols.filter({
                    !$0.contains("Dinergate")
                }).joined(separator: "\n")
                DBManager.shared.insertCrash(title: exception.name.rawValue, desc: exception.reason, callStack: callStack, date: Date(), appInfo: appInfo)
            case .singal(let code, let name):
//                let callStack = Thread.callStackSymbols.filter({
//                    !$0.contains("Dinergate")
//                }).joined(separator: "\n")
                guard let callStack = getCallStack() else { return }
                DBManager.shared.insertCrash(title: name, desc: "\(code)", callStack: callStack, date: Date(), appInfo: appInfo)
            }
        }
        
        StuckMonitor.shared.stuckHappening = { type in
            let title: String
            switch type {
            case .single:
                title = "单次卡顿超过\(config.stuckThreshold.singleTimeout * 1000)ms"
            case .continuous:
                let timeout = config.stuckThreshold.continuousThreshold?.timeout ?? 0
                title = "连续卡顿，每次卡顿超过\(timeout * 1000)ms"
            }
//            let callStack = Thread.callStackSymbols.filter({
//                !$0.contains("Dinergate")
//            }).joined(separator: "\n")
            guard let callStack = getCallStack() else { return }
            DBManager.shared.insertStuck(title: title, desc: nil, callStack: callStack, date: Date(), appInfo: appInfo)
        }
        
    }

    public static func stop() {
        FloatManager.shared.close()
        DinergateBrain.shared.stop()
    }
    
    public static func showMenu() {
        Menu.shared.show()
    }
    
    public static func getCallStack() -> String? {
        guard let logData = PLCrashReporter(configuration: PLCrashReporterConfig(signalHandlerType: .BSD, symbolicationStrategy: .all))?.generateLiveReport() else { return nil }
        guard let logReport = try? PLCrashReport(data: logData) else { return nil }
        let logStr = PLCrashReportTextFormatter.stringValue(for: logReport, with: PLCrashReportTextFormatiOS)
        return logStr
    }
    
    public static func tickLog(_ log: String, desc: String?, type: String?) {
        DBManager.shared.insertTickLog(log: log, date: Date(), desc: desc, type: type)
    }
}

// MARK: - MonitorItem
extension Dinergate {
    struct FloatItem: OptionSet {

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

// MARK: - private & internal
extension Dinergate {
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
    
    static var defaultItems: DinergateBrain.Items = .default
}

enum MenuSettingItem: String, CaseIterable {
    case stuck
    case crash
    case fps
    
    var title: String {
        switch self {
        case .stuck:
            return "卡顿监测"
        case .crash:
            return "崩溃监测"
        case .fps:
            return "fps浮窗"
        }
    }
}

//public extension UIViewController {
//    open override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
//        if motion == .motionShake {
//            Dinergate.showMenu()
//        }
//    }
//}
