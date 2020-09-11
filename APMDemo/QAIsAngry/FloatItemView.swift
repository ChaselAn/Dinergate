import UIKit

class FloatItemView: UIView {
    enum State {
        case green
        case yellow
        case red

        var color: UIColor {
            switch self {
            case .green:
                return .green
            case .yellow:
                return .yellow
            case .red:
                return .red
            }
        }

        var backgroundColor: UIColor {
            return color.withAlphaComponent(0.4)
        }
    }

    private let progressView = UIView()
    private let progressBgView = UIView()
    private let titleLabel = UILabel()
    private let progressLabel = UILabel()
    private var progressHeight: NSLayoutConstraint?
    private var state: State  = .green {
        didSet {
            updateState()
        }
    }

    init(title: String) {
        super.init(frame: CGRect.zero)

        config()
        makeUI()

        titleLabel.text = title
        updateState()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setData(state: State, progressStr: String, progress: Float) {
        progressLabel.text = progressStr
        self.state = state
        layoutIfNeeded()
        let safeProgress = min(1, max(0, progress))
        progressHeight?.constant = (bounds.size.height - progressLabel.bounds.height - titleLabel.bounds.height) * CGFloat(safeProgress)
    }

    private func config() {
        progressLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        progressLabel.textColor = .white
        progressLabel.textAlignment = .center

        titleLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        titleLabel.textColor = .white
        titleLabel.textAlignment = .center
    }

    private func makeUI() {
        addSubview(progressLabel)
        progressLabel.translatesAutoresizingMaskIntoConstraints = false
        progressLabel.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        progressLabel.topAnchor.constraint(equalTo: topAnchor).isActive = true
        progressLabel.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        progressLabel.contentScaleFactor = 0.5
        progressLabel.setContentHuggingPriority(.required, for: .vertical)
        progressLabel.setContentCompressionResistancePriority(.required, for: .vertical)

        addSubview(progressBgView)
        progressBgView.translatesAutoresizingMaskIntoConstraints = false
        progressBgView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        progressBgView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        progressBgView.topAnchor.constraint(equalTo: progressLabel.bottomAnchor).isActive = true

        addSubview(progressView)
        progressView.translatesAutoresizingMaskIntoConstraints = false
        progressView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        progressView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        progressHeight = progressView.heightAnchor.constraint(equalToConstant: 0)
        progressHeight?.isActive = true
        progressView.bottomAnchor.constraint(equalTo: progressBgView.bottomAnchor).isActive = true

        addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        titleLabel.topAnchor.constraint(equalTo: progressBgView.bottomAnchor).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        titleLabel.contentScaleFactor = 0.5
        titleLabel.setContentHuggingPriority(.required, for: .vertical)
        titleLabel.setContentCompressionResistancePriority(.required, for: .vertical)
    }

    private func updateState() {
        progressBgView.backgroundColor = state.backgroundColor
        progressView.backgroundColor = state.color
    }
}
