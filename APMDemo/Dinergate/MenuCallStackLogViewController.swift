import UIKit

final class MenuCallStackLogViewController: MenuBaseViewController {
    
    private let datas: [LogInfo]
    private let navTitle: String
    
    init(title: String, datas: [LogInfo]) {
        self.datas = datas
        self.navTitle = title
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
        tableView.delegate = self
        tableView.register(LogListTableViewCell.self, forCellReuseIdentifier: LogListTableViewCell.identifier)
        tableView.rowHeight = UITableView.automaticDimension
    }
}

extension MenuCallStackLogViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: LogListTableViewCell.identifier, for: indexPath) as! LogListTableViewCell
        let info = datas[indexPath.row]
        if let info = info as? CallStackLogInfo {
            cell.titleLabel.text = info.title
            cell.descLabel.text = info.desc
            cell.dateLabel.text = info.date.string
            cell.appInfoLabel.text = info.appInfo
        } else if let info = info as? TickLogInfo {
            cell.titleLabel.text = info.title
            cell.dateLabel.text = info.date.string
        }
        return cell
    }
    
}

extension MenuCallStackLogViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        defer {
            tableView.deselectRow(at: indexPath, animated: true)
        }
        if let data = datas[indexPath.row] as? CallStackLogInfo {
            navigationController?.pushViewController(MenuLogInfoViewController(title: navTitle, data: data), animated: true)
        }
    }
}

final class LogListTableViewCell: UITableViewCell {
    
    static let identifier = "LogListTableViewCell"
    
    let titleLabel = UILabel()
    let descLabel = UILabel()
    let dateLabel = UILabel()
    let appInfoLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        titleLabel.numberOfLines = 0
        titleLabel.textColor = .black
        titleLabel.lineBreakMode = .byTruncatingTail
        
        descLabel.numberOfLines = 3
        descLabel.lineBreakMode = .byTruncatingTail
        descLabel.font = UIFont.systemFont(ofSize: 12)
        descLabel.textColor = .lightGray
        
        appInfoLabel.numberOfLines = 0
        appInfoLabel.lineBreakMode = .byTruncatingTail
        appInfoLabel.font = UIFont.systemFont(ofSize: 11)
        appInfoLabel.textColor = .lightGray
        
        dateLabel.numberOfLines = 1
        dateLabel.textColor = .lightGray
        dateLabel.font = UIFont.systemFont(ofSize: 12)
        
        contentView.backgroundColor = UIColor.white
        
        makeUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func makeUI() {
        
        contentView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15).isActive = true
        titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8).isActive = true
        titleLabel.setContentHuggingPriority(.required, for: .vertical)
        titleLabel.setContentCompressionResistancePriority(.required, for: .vertical)
        
        contentView.addSubview(descLabel)
        descLabel.translatesAutoresizingMaskIntoConstraints = false
        descLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor).isActive = true
        descLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8).isActive = true
        descLabel.setContentHuggingPriority(.required, for: .vertical)
        descLabel.setContentCompressionResistancePriority(.required, for: .vertical)
        
        contentView.addSubview(dateLabel)
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15).isActive = true
        dateLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        dateLabel.setContentHuggingPriority(.required, for: .horizontal)
        dateLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        
        contentView.addSubview(appInfoLabel)
        appInfoLabel.translatesAutoresizingMaskIntoConstraints = false
        appInfoLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor).isActive = true
        appInfoLabel.topAnchor.constraint(equalTo: descLabel.bottomAnchor, constant: 8).isActive = true
        appInfoLabel.setContentHuggingPriority(.required, for: .vertical)
        appInfoLabel.setContentCompressionResistancePriority(.required, for: .vertical)
        let bottom = appInfoLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        bottom.priority = .defaultHigh
        bottom.isActive = true
        
        dateLabel.leadingAnchor.constraint(greaterThanOrEqualTo: titleLabel.trailingAnchor, constant: 8).isActive = true
        dateLabel.leadingAnchor.constraint(greaterThanOrEqualTo: descLabel.trailingAnchor, constant: 8).isActive = true
        dateLabel.leadingAnchor.constraint(greaterThanOrEqualTo: appInfoLabel.trailingAnchor, constant: 8).isActive = true
    }
}
