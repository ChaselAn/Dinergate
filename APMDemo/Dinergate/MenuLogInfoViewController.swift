import UIKit

class MenuLogInfoViewController: MenuBaseViewController {

    private let data: CallStackLogInfo
    
    init(title: String, data: CallStackLogInfo) {
        self.data = data
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
        tableView.allowsSelection = false
        tableView.register(LogListTableViewCell.self, forCellReuseIdentifier: LogListTableViewCell.identifier)
        tableView.rowHeight = UITableView.automaticDimension
    }
}

extension MenuLogInfoViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = LogInfoTableViewCell()
        cell.titleLabel.text = data.title
        cell.appInfoLabel.text = (data.appInfo ?? "") + " \(data.date.string)"
        cell.descLabel.text = data.desc
        cell.callStackLabel.text = data.callStack
        return cell
    }
    
}

final class LogInfoTableViewCell: UITableViewCell {
    
    static let identifier = "LogInfoTableViewCell"
    
    let titleLabel = UILabel()
    let appInfoLabel = UILabel()
    let descLabel = UILabel()
    let callStackLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = .white

        titleLabel.numberOfLines = 0
        titleLabel.textColor = .red
        
        descLabel.numberOfLines = 0
        descLabel.textColor = UIColor.black
        descLabel.font = UIFont.systemFont(ofSize: 12)
        
        appInfoLabel.numberOfLines = 0
        appInfoLabel.textColor = .lightGray
        appInfoLabel.font = UIFont.systemFont(ofSize: 11)
        
        callStackLabel.numberOfLines = 0
        callStackLabel.textColor = .lightGray
        callStackLabel.font = UIFont.systemFont(ofSize: 12)
        
        makeUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func makeUI() {
        
        contentView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8).isActive = true
        titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8).isActive = true
        titleLabel.setContentHuggingPriority(.required, for: .vertical)
        titleLabel.setContentCompressionResistancePriority(.required, for: .vertical)
        
        contentView.addSubview(appInfoLabel)
        appInfoLabel.translatesAutoresizingMaskIntoConstraints = false
        appInfoLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor).isActive = true
        appInfoLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor).isActive = true
        appInfoLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10).isActive = true
        appInfoLabel.setContentHuggingPriority(.required, for: .vertical)
        appInfoLabel.setContentCompressionResistancePriority(.required, for: .vertical)
        
        contentView.addSubview(descLabel)
        descLabel.translatesAutoresizingMaskIntoConstraints = false
        descLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor).isActive = true
        descLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor).isActive = true
        descLabel.topAnchor.constraint(equalTo: appInfoLabel.bottomAnchor, constant: 10).isActive = true
        descLabel.setContentHuggingPriority(.required, for: .vertical)
        descLabel.setContentCompressionResistancePriority(.required, for: .vertical)
        
        contentView.addSubview(callStackLabel)
        callStackLabel.translatesAutoresizingMaskIntoConstraints = false
        callStackLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor).isActive = true
        callStackLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor).isActive = true
        callStackLabel.topAnchor.constraint(equalTo: descLabel.bottomAnchor, constant: 20).isActive = true
        callStackLabel.setContentHuggingPriority(.required, for: .vertical)
        callStackLabel.setContentCompressionResistancePriority(.required, for: .vertical)
        let bottom = callStackLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        bottom.priority = .defaultHigh
        bottom.isActive = true
    }
}
