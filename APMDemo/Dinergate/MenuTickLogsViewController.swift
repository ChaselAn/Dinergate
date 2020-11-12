import UIKit

final class MenuTickLogsViewController: MenuBaseViewController {
    
    private let datas: [TickLogInfo]
    
    init(title: String, datas: [TickLogInfo]) {
        self.datas = datas
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

extension MenuTickLogsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: LogListTableViewCell.identifier, for: indexPath) as! LogListTableViewCell
        let info = datas[indexPath.row]
        cell.titleLabel.text = info.title
        cell.descLabel.text = info.desc
        cell.dateLabel.text = info.date.string
        return cell
    }
    
}
