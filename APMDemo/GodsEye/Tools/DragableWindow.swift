import UIKit

open class DragableWindow: UIWindow {

    public enum DragStyle {
        case beInPlace // 滑动到哪就停在哪
        case leftOrRight // 根据距父View位置黏在左边或者右边
        case topOrBottom // 根据距父View位置黏在上边或者下边
        case around // 根据距父View位置黏在上下左右某个边
    }

    public var dragable: Bool = true
    public var dragEdgeInsets: UIEdgeInsets = UIEdgeInsets(top: 18, left: 18, bottom: 18, right: 18) // 停留在边上距离父view的边距
    public var dragStyle: DragStyle = .beInPlace

    private var originalPoint: CGPoint?

    public override init(frame: CGRect) {
        super.init(frame: frame)

        let gesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        addGestureRecognizer(gesture)
    }

    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func correctPosition(currentPosition: CGPoint, offset: CGPoint = .zero) {
        switch dragStyle {
        case .beInPlace:
            break
        case .around:
            around(offset: offset, originalPoint: currentPosition)
        case .leftOrRight:
            leftOrRight(offset: offset, originalPoint: currentPosition)
        case .topOrBottom:
            topOrBottom(offset: offset, originalPoint: currentPosition)
        }
    }

    @objc private func handlePan(ges: UIPanGestureRecognizer) {
        guard dragable else { return }
        switch ges.state {
        case .began:
            self.originalPoint = frame.origin
            self.translatesAutoresizingMaskIntoConstraints = true
        case .cancelled, .ended:
            let offset = ges.translation(in: self)
            guard let originalPoint = originalPoint else { return }
            correctPosition(currentPosition: originalPoint, offset: offset)
            self.originalPoint = nil
        case .changed:
            handlePanChanged(ges: ges)
        default:
            break
        }
    }

    private func handlePanChanged(ges: UIPanGestureRecognizer) {
        let size = frame.size
        let offset = ges.translation(in: self)
        guard let originalPoint = originalPoint else { return }
        let point = safePoint(CGPoint(x: originalPoint.x + offset.x, y: originalPoint.y + offset.y))
        self.frame = CGRect(origin: point, size: size)
    }

    private func around(offset: CGPoint, originalPoint: CGPoint) {
        let size = frame.size
        let point = safePoint(CGPoint(x: originalPoint.x + offset.x, y: originalPoint.y + offset.y))
        let marginLeft = point.x - dragEdgeInsets.left
        let marginRight = safeMaxX - point.x
        let marginTop = point.y - dragEdgeInsets.top
        let marginBottom = safeMaxY - point.y

        let isLeft = marginLeft < marginRight
        let isTop = marginTop < marginBottom

        let finalX: CGFloat
        let finalY: CGFloat

        if isLeft && isTop {
            if marginLeft < marginTop {
                finalX = dragEdgeInsets.left
                finalY = point.y
            } else {
                finalX = point.x
                finalY = dragEdgeInsets.top
            }
        } else if !isLeft && isTop {
            if marginRight < marginTop {
                finalX = safeMaxX
                finalY = point.y
            } else {
                finalX = point.x
                finalY = dragEdgeInsets.top
            }
        } else if isLeft && !isTop {
            if marginLeft < marginBottom {
                finalX = dragEdgeInsets.left
                finalY = point.y
            } else {
                finalX = point.x
                finalY = safeMaxY
            }
        } else {
            if marginRight < marginBottom {
                finalX = safeMaxX
                finalY = point.y
            } else {
                finalX = point.x
                finalY = safeMaxY
            }
        }
        UIView.animate(withDuration: 0.25) { [weak self] in
            self?.frame = CGRect(origin: CGPoint(x: finalX, y: finalY), size: size)
        }
    }

    private func leftOrRight(offset: CGPoint, originalPoint: CGPoint) {
        guard let keyWindow = UIApplication.shared.keyWindow else { return }
        let size = frame.size
        let point = safePoint(CGPoint(x: originalPoint.x + offset.x, y: originalPoint.y + offset.y))
        let newFrame: CGRect
        if point.x < (keyWindow.bounds.width - dragEdgeInsets.left - dragEdgeInsets.right) / 2 {
            newFrame = CGRect(origin: CGPoint(x: dragEdgeInsets.left, y: point.y), size: size)
        } else {
            newFrame = CGRect(origin: CGPoint(x: safeMaxX, y: point.y), size: size)
        }
        UIView.animate(withDuration: 0.25) { [weak self] in
            self?.frame = newFrame
        }
    }

    private func topOrBottom(offset: CGPoint, originalPoint: CGPoint) {
        guard let keyWindow = UIApplication.shared.keyWindow else { return }
        let size = frame.size
        let point = safePoint(CGPoint(x: originalPoint.x + offset.x, y: originalPoint.y + offset.y))
        let newFrame: CGRect
        if point.y < (keyWindow.bounds.height - dragEdgeInsets.top - dragEdgeInsets.bottom) / 2 {
            newFrame = CGRect(origin: CGPoint(x: point.x, y: dragEdgeInsets.top), size: size)
        } else {
            newFrame = CGRect(origin: CGPoint(x: point.x, y: safeMaxY), size: size)
        }
        UIView.animate(withDuration: 0.25) { [weak self] in
            self?.frame = newFrame
        }
    }

    private var safeMaxX: CGFloat {
        guard let keyWindow = UIApplication.shared.keyWindow else { return 0 }
        return keyWindow.bounds.width - dragEdgeInsets.right - frame.size.width
    }

    private var safeMaxY: CGFloat {
        guard let keyWindow = UIApplication.shared.keyWindow else { return 0 }
        return keyWindow.bounds.height - dragEdgeInsets.bottom - frame.size.height
    }

    private func safePoint(_ oldPoint: CGPoint) -> CGPoint {
        var newX = oldPoint.x
        var newY = oldPoint.y
        if newX < dragEdgeInsets.left {
            newX = dragEdgeInsets.left
        } else if newX > safeMaxX {
            newX = safeMaxX
        }
        if newY < dragEdgeInsets.top {
            newY = dragEdgeInsets.top
        } else if newY > safeMaxY {
            newY = safeMaxY
        }
        return CGPoint(x: newX, y: newY)
    }
}
