import UIKit

class FloatWindow: DragableWindow {

    private let itemSize = CGSize(width: 40, height: 100)
    private let itemSpace: CGFloat = 10

    init(items: Dinergate.FloatItem, closeAction: () -> Void) {
        let edgeInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        let w = CGFloat(items.count) * itemSize.width + itemSpace * CGFloat(items.count - 1)
        let x = UIScreen.main.bounds.width - edgeInset.left - edgeInset.right - w
        super.init(frame: CGRect(x: x, y: 100, width: w, height: itemSize.height))

        rootViewController = FloatRootViewController(items: items, itemSize: itemSize, itemSpace: itemSpace)
        dragEdgeInsets = edgeInset
        
        windowLevel = .statusBar + 100
    }

    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
