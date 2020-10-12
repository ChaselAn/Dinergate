import UIKit

final class Menu {

    static let shared = Menu()

    private let windowColor = UIColor.black.withAlphaComponent(0.75)
    private var window: MenuWindow?
    private var lastKeyWindow: UIWindow?
    
    func show() {
        guard UIApplication.shared.applicationState == .active else { return }
        guard window == nil else { return }
        
        let window = MenuWindow(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height))
        window.alpha = 0
        window.backgroundColor = windowColor
        if UIApplication.shared.keyWindow is MenuWindow {
            lastKeyWindow = UIApplication.shared.delegate?.window ?? nil
        } else {
            lastKeyWindow = UIApplication.shared.keyWindow
        }
        self.window = window
        window.makeKeyAndVisible()
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseOut, animations: {
            window.alpha = 1.0
        })
        window.showVC()
    }
    
    func dismiss() {
        UIView.animate(withDuration: 0.25, animations: { [weak self] in
            self?.window?.alpha = 0
            }, completion: { [weak self] _ in
                self?.window = nil
                self?.lastKeyWindow?.makeKeyAndVisible()
        })
    }
}

final class MenuWindow: UIWindow {

    private let rootVC = UIViewController()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        isHidden = false
        windowLevel = .statusBar + 100
        rootViewController = rootVC
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func showVC() {
        let nvc = MenuNavigationViewController(rootViewController: MenuViewController())
        nvc.modalPresentationStyle = .fullScreen
        nvc.setNavigationBarHidden(true, animated: false)
        rootVC.present(nvc, animated: true, completion: nil)
    }

//    func showRechargeView() {
//        productListVC.modalPresentationStyle = .fullScreen
//        rootVC.present(productListVC, animated: true, completion: nil)
//    }
//
//    func showRechargeSuccessView(dismissAction: @escaping () -> Void) {
//        productListVC.dismiss(animated: true, completion: nil)
//        rootVC.present(RechargeResultViewController(type: .success, dismissAction: dismissAction), animated: true, completion: nil)
//    }
//
//    func showRechargeFailedView(dismissAction: @escaping () -> Void) {
//        productListVC.dismiss(animated: true, completion: nil)
//        rootVC.present(RechargeResultViewController(type: .failure, dismissAction: dismissAction), animated: true, completion: nil)
//    }
}
