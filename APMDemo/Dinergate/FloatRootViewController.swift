import UIKit
import DinergateBrain

class FloatRootViewController: UIViewController {

    private lazy var cpuView = FloatItemView(title: "CPU")
    private lazy var fpsView = FloatItemView(title: "FPS")
    private var stackView: UIStackView?

    private let items: Dinergate.FloatItem
    private let itemSize: CGSize
    private let itemSpace: CGFloat

    init(items: Dinergate.FloatItem, itemSize: CGSize, itemSpace: CGFloat) {
        self.items = items
        self.itemSize = itemSize
        self.itemSpace = itemSpace
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        config()
        makeUI()
    }

    private func config() {
        view.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        stackView?.backgroundColor = UIColor.black.withAlphaComponent(0.3)

//        if items.contains(.cpu) {
//            CPUMonitor.shared.observable.addObserver(self) { [weak self] (_, progress) in
//                let state: FloatItemView.State
//                if progress < 0.4 {
//                    state = .green
//                } else if progress < 0.7 {
//                    state = .yellow
//                } else {
//                    state = .red
//                }
//                self?.cpuView.setData(state: state, progressStr: "\(Int(progress * 100))%", progress: progress)
//            }
//        }
        if items.contains(.fps) {
            FPSMonitor.shared.fpsChanged = { [weak self] fps in
                let state: FloatItemView.State
                let safeFps = min(60, max(0, fps))
                if safeFps > 50 {
                    state = .green
                } else if safeFps > 30 {
                    state = .yellow
                } else {
                    state = .red
                }
                let progress: Float = Float(safeFps) / 60
                self?.fpsView.setData(state: state, progressStr: "\(safeFps)", progress: progress)
            }
        }
    }

    private func makeUI() {
        var children: [UIView] = []
//        if items.contains(.cpu) {
//            children.append(cpuView)
//            cpuView.translatesAutoresizingMaskIntoConstraints = false
//            cpuView.widthAnchor.constraint(equalToConstant: itemSize.width).isActive = true
//            cpuView.heightAnchor.constraint(equalToConstant: itemSize.height).isActive = true
//        }
        if items.contains(.fps) {
            children.append(fpsView)
            fpsView.translatesAutoresizingMaskIntoConstraints = false
            fpsView.widthAnchor.constraint(equalToConstant: itemSize.width).isActive = true
            fpsView.heightAnchor.constraint(equalToConstant: itemSize.height).isActive = true
        }
        let stackView = UIStackView(arrangedSubviews: children)
        stackView.alignment = .fill
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.spacing = itemSpace

        view.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        stackView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true

        self.stackView = stackView
    }
}
