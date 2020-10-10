import UIKit

final class MenuNavigationViewController: UINavigationController {

    enum TransitionStyle {
        case fade
        case upward
    }
    var transitionStyle: TransitionStyle = .upward

    private let transitionManager = AlertTransitionManager()
    
    override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
        
        setUpTransition()
    }

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)

        setUpTransition()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        setUpTransition()
    }

    private func setUpTransition() {
        transitioningDelegate = transitionManager
        modalPresentationStyle = .custom
        modalPresentationCapturesStatusBarAppearance = true
    }
}

class AlertTransitionManager: NSObject {

    var animator: AlertTransitionAnimator

    override init() {
        animator = AlertTransitionAnimator()
        super.init()
    }
}

extension AlertTransitionManager: UIViewControllerTransitioningDelegate {

    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        animator.isDismissing = false
        return animator
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        animator.isDismissing = true
        return animator
    }
}

class AlertTransitionAnimator: NSObject {
    var isDismissing: Bool = false

    override init() {
        super.init()
    }
}

extension AlertTransitionAnimator: UIViewControllerAnimatedTransitioning {

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.25
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {

        let key: UITransitionContextViewControllerKey = isDismissing ? .from : .to
        let controller = transitionContext.viewController(forKey: key)!
        if !isDismissing {
            transitionContext.containerView.addSubview(controller.view)
        }
        let animationDuration = transitionDuration(using: transitionContext)
        guard let alertController = controller as? MenuNavigationViewController else { return }
        let originAlpha = alertController.view.alpha
        let initialAlpha: CGFloat = isDismissing ? originAlpha : 0
        let finalAlpha: CGFloat = isDismissing ? 0 : originAlpha
        alertController.view.alpha = initialAlpha

        switch alertController.transitionStyle {
        case .fade:
            UIView.animate(withDuration: animationDuration, animations: {
                alertController.view.alpha = finalAlpha
            }, completion: { _ in
                transitionContext.completeTransition(true)
            })
        case .upward:
            guard let containerView = alertController.view.subviews.first else { fatalError("need a containerView") }
            let beginY = !isDismissing ? alertController.view.bounds.height : containerView.frame.origin.y
            let endY = isDismissing ? alertController.view.bounds.height : containerView.frame.origin.y
            containerView.frame = CGRect(x: containerView.frame.origin.x, y: beginY, width: containerView.bounds.width, height: containerView.bounds.height)
            UIView.animate(withDuration: animationDuration, animations: {
                alertController.view.alpha = finalAlpha
                containerView.frame.origin.y = endY
            }, completion: { finished in
                transitionContext.completeTransition(finished)
            })
        }
    }

}
