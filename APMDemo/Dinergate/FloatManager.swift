import UIKit

class FloatManager: NSObject {

    static let shared = FloatManager()

    private let windowColor = UIColor.clear

    private var floatWindow: FloatWindow?

    private override init() {
        super.init()
    }

    @discardableResult
    func show(items: Dinergate.MonitorItem) -> Bool {

        let floatWindow = FloatWindow(items: items, closeAction: { [weak self] in
            self?.close()
        })
        floatWindow.isHidden = false
        floatWindow.windowLevel = UIWindow.Level(UIWindow.Level.alert.rawValue + 1)
        floatWindow.alpha = 0
        floatWindow.backgroundColor = windowColor

        self.floatWindow = floatWindow
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseOut, animations: { [weak self] in
            self?.floatWindow?.alpha = 1.0
        })
        return true
    }

    func close() {
        guard floatWindow != nil else { return }
        UIView.animate(withDuration: 0.25, animations: { [weak self] in
            self?.floatWindow?.alpha = 0
            }, completion: { [weak self] _ in
                self?.floatWindow = nil
        })
    }
}
