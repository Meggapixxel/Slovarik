import UIKit

protocol P_TableViewControllerPresenter: P_ViewControllerPresenter, UITableViewDataSource {
    
    associatedtype VIEWCONTROLLER: P_TableViewController
    associatedtype CELL: UITableViewCell & P_PresenterConfigurableView
    associatedtype ITEM: Equatable
    
    init(vc: VIEWCONTROLLER, cellConfig: @escaping (ITEM) -> (CELL.PRESENTER))
    
    var cellConfig: (ITEM) -> (CELL.PRESENTER) { get }
    var vc: VIEWCONTROLLER! { get }

    var headerView: UIView? { get }
    var footerView: UIView? { get }
    
}

extension P_TableViewControllerPresenter {

    var tableView: UITableView! { vc.tableView }

}

fileprivate extension P_TableViewControllerPresenter {

    func prepare() {
        tableView.register(CELL.self)
        tableView.dataSource = self
        tableView.backgroundColor = .clear
        tableView.keyboardDismissMode = .interactive
        tableView.separatorInset.left = 0
        tableView.separatorColor = .clear
        tableView.tableHeaderView = headerView
        tableView.tableFooterView = footerView
    }

}

extension P_TableViewControllerPresenter {

    func prepareTableViewControllerPresenter() {
        prepare()
    }

}


class BaseTableViewControllerPresenter<
    VIEWCONTROLLER: P_TableViewController,
    CELL: UITableViewCell & P_PresenterConfigurableView,
    ITEM: Equatable
>: BaseViewControllerPresenter<VIEWCONTROLLER>, P_TableViewControllerPresenter, P_FooterObservable {
    
    let cellConfig: (ITEM) -> (CELL.PRESENTER)
    var headerView: UIView? { nil }
    var footerView: UIView? { nil }
    
    required init(vc: VIEWCONTROLLER, cellConfig: @escaping (ITEM) -> (CELL.PRESENTER)) {
        self.cellConfig = cellConfig
        super.init(vc: vc)
    }
    
    override func initialUpdateUI() {
        super.initialUpdateUI()
        self.prepare()
    }
    
    // MARK: - UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? { nil }

    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? { nil }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool { tableView.isEditing }

    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool { tableView.isEditing }

    func sectionIndexTitles(for tableView: UITableView) -> [String]? { nil }

    func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int { Int() }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) { }

    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) { }
    
}
