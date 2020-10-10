import UIKit

final class MenuViewController: MenuBaseViewController {
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        navView = NavigationView(title: "Dinergate", leftButtonText: "关闭", rightButtonText: "配置", leftButtonAction: {
            Menu.shared.dismiss()
        }, rightButtonAction: { [weak self] in
            
        })
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
    }
}

extension MenuViewController: UITableViewDataSource {
    
    enum Row: Int, CaseIterable {
        case stuckLog
        case crashLog
        
        var title: String {
            switch self {
            case .stuckLog:
                return "卡顿日志"
            case .crashLog:
                return "崩溃日志"
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Row.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let row = Row(rawValue: indexPath.row) else { fatalError() }
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        cell.textLabel?.text = row.title
        return cell
    }
    
}

extension MenuViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let row = Row(rawValue: indexPath.row) else { fatalError() }
        defer {
            tableView.deselectRow(at: indexPath, animated: true)
        }
        let vc = MenuLogViewController(title: row.title)
        navigationController?.pushViewController(vc, animated: true)
    }
}
