import UIKit

typealias VoidHandler = () -> Void
typealias SingleHandler<T> = (T) -> Void
final class NavigationView: UIView {
    
    private let titleLabel = UILabel()
    private let leftButton = UIButton(type: .system)
    private let rightButton = UIButton(type: .system)
    private let separator = UIView()
    
    private let leftButtonAction: VoidHandler?, rightButtonAction: VoidHandler?
    
    init(title: String, leftButtonText: String?, rightButtonText: String?, leftButtonAction: VoidHandler?, rightButtonAction: VoidHandler?) {
        self.leftButtonAction = leftButtonAction
        self.rightButtonAction = rightButtonAction
        super.init(frame: .zero)
        
        backgroundColor = .white
        
        titleLabel.text = title
        titleLabel.textAlignment = .center
        titleLabel.textColor = .black
        
        leftButton.setTitle(leftButtonText, for: .normal)
        leftButton.addTarget(self, action: #selector(leftButtonClicked), for: .touchUpInside)
        rightButton.setTitle(rightButtonText, for: .normal)
        rightButton.addTarget(self, action: #selector(rightButtonClicked), for: .touchUpInside)
        
        separator.backgroundColor = .lightGray
        makeUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func makeUI() {
        addSubview(leftButton)
        leftButton.translatesAutoresizingMaskIntoConstraints = false
        leftButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10).isActive = true
        leftButton.topAnchor.constraint(equalTo: topAnchor).isActive = true
        let bottom = leftButton.bottomAnchor.constraint(equalTo: bottomAnchor)
        bottom.priority = .defaultHigh
        bottom.isActive = true
        leftButton.widthAnchor.constraint(equalToConstant: 44).isActive = true
        leftButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
        addSubview(rightButton)
        rightButton.translatesAutoresizingMaskIntoConstraints = false
        rightButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10).isActive = true
        rightButton.topAnchor.constraint(equalTo: topAnchor).isActive = true
        rightButton.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        rightButton.widthAnchor.constraint(equalToConstant: 44).isActive = true
        
        addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.leadingAnchor.constraint(equalTo: leftButton.trailingAnchor, constant: 10).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: rightButton.leadingAnchor, constant: -10).isActive = true
        titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        addSubview(separator)
        separator.translatesAutoresizingMaskIntoConstraints = false
        separator.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        separator.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        separator.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        separator.heightAnchor.constraint(equalToConstant: 1 / UIScreen.main.scale).isActive = true
    }
    
    @objc private func leftButtonClicked() {
        leftButtonAction?()
    }
    
    @objc private func rightButtonClicked() {
        rightButtonAction?()
    }
}
