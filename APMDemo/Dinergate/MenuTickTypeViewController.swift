import UIKit

final class MenuTickTypeViewController: MenuBaseViewController {
    
    private let types: [String]
    
    init(types: [String]) {
        self.types = types
        super.init(nibName: nil, bundle: nil)
        
        navView = NavigationView(title: MenuViewController.Row.tickLog.title, leftButtonText: "返回", rightButtonText: nil, leftButtonAction: { [weak self] in
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
    }
}

extension MenuTickTypeViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return types.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        cell.contentView.backgroundColor = .white
        cell.textLabel?.textColor = UIColor.black
        cell.textLabel?.text = types[indexPath.row]
        return cell
    }
    
}

extension MenuTickTypeViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        defer {
            tableView.deselectRow(at: indexPath, animated: true)
        }
        let type = types[indexPath.row]
        let vc: UIViewController = MenuTickLogsViewController(title: type, datas: DBManager.shared.tickLogs(for: type))
        navigationController?.pushViewController(vc, animated: true)
    }
}
