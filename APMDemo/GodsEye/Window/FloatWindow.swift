import UIKit

class FloatWindow: DragableWindow {

    init(items: GodsEye.MonitorItem, closeAction: () -> Void) {
        super.init(frame: CGRect.zero)
    }

    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
