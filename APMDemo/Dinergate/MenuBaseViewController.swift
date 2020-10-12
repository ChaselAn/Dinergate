import UIKit

class MenuBaseViewController: UIViewController {
    
    let tableView = UITableView()
    var navView: NavigationView!
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .clear
        tableView.tableFooterView = UIView()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.backgroundColor = UIColor.white
        makeUI()
    }

    private func makeUI() {
        
        view.addSubview(navView)
        navView.translatesAutoresizingMaskIntoConstraints = false
        navView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        navView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        navView.topAnchor.constraint(equalTo: view.topAnchor, constant: 100).isActive = true

        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: navView.bottomAnchor).isActive = true
    }
}
