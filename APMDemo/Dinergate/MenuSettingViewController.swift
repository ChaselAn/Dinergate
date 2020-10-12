import UIKit
import DinergateBrain

class MenuSettingViewController: MenuBaseViewController {
    
    private var stuckEnable: Bool
    private var crashEnable: Bool
    private var fpsEnable: Bool
    
    init(title: String) {
        self.stuckEnable = UserDefaults.standard.value(forKey: MenuSettingItem.stuck.rawValue) as? Bool ?? Dinergate.defaultItems.contains(.stuck)
        self.crashEnable = UserDefaults.standard.value(forKey: MenuSettingItem.crash.rawValue) as? Bool ?? Dinergate.defaultItems.contains(.crash)
        self.fpsEnable = UserDefaults.standard.value(forKey: MenuSettingItem.fps.rawValue) as? Bool ?? Dinergate.defaultItems.contains(.fps)
        super.init(nibName: nil, bundle: nil)
        
        navView = NavigationView(title: title, leftButtonText: "返回", rightButtonText: nil, leftButtonAction: { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }, rightButtonAction: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.register(SettingTableViewCell.self, forCellReuseIdentifier: SettingTableViewCell.identifier)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.allowsSelection = false
    }
}

extension MenuSettingViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MenuSettingItem.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SettingTableViewCell.identifier, for: indexPath) as! SettingTableViewCell
        let info = MenuSettingItem.allCases[indexPath.row]
        cell.titleLabel.text = info.title
        switch info {
        case .crash:
            cell.switchView.isOn = crashEnable
            cell.switchChanged = { [weak self] enabled in
                UserDefaults.standard.setValue(enabled, forKey: info.rawValue)
                self?.crashEnable = enabled
                enabled ? CrashMonitor.shared.start() : CrashMonitor.shared.stop()
                self?.tableView.reloadData()
            }
        case .fps:
            cell.switchView.isOn = fpsEnable
            cell.switchChanged = { [weak self] enabled in
                UserDefaults.standard.setValue(enabled, forKey: info.rawValue)
                self?.fpsEnable = enabled
                enabled ? FPSMonitor.shared.start() : FPSMonitor.shared.stop()
                enabled ? FloatManager.shared.show(items: [.fps]) : FloatManager.shared.close()
                self?.tableView.reloadData()
            }
        case .stuck:
            cell.switchView.isOn = stuckEnable
            cell.switchChanged = { [weak self] enabled in
                UserDefaults.standard.setValue(enabled, forKey: info.rawValue)
                self?.stuckEnable = enabled
                enabled ? StuckMonitor.shared.start() : StuckMonitor.shared.stop()
                self?.tableView.reloadData()
            }
        }
        return cell
    }
    
}

final class SettingTableViewCell: UITableViewCell {
    
    static let identifier = "SettingTableViewCell"
    
    let titleLabel = UILabel()
    let switchView = UISwitch()
    var switchChanged: SingleHandler<Bool>?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        titleLabel.numberOfLines = 0
        titleLabel.textColor = .black
        titleLabel.lineBreakMode = .byTruncatingTail
    
        contentView.backgroundColor = UIColor.white
        
        switchView.addTarget(self, action: #selector(switchValueChanged), for: .valueChanged)
        
        makeUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func switchValueChanged() {
        switchChanged?(switchView.isOn)
    }
    
    private func makeUI() {
        
        contentView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15).isActive = true
        titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8).isActive = true
        titleLabel.setContentHuggingPriority(.required, for: .vertical)
        titleLabel.setContentCompressionResistancePriority(.required, for: .vertical)
        let bottom = titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        bottom.priority = .defaultHigh
        bottom.isActive = true
        
        contentView.addSubview(switchView)
        switchView.translatesAutoresizingMaskIntoConstraints = false
        switchView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15).isActive = true
        switchView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        switchView.leadingAnchor.constraint(greaterThanOrEqualTo: titleLabel.trailingAnchor, constant: 8).isActive = true
        switchView.setContentHuggingPriority(.required, for: .horizontal)
        switchView.setContentCompressionResistancePriority(.required, for: .horizontal)
    }
}
