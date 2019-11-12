import UIKit

protocol P_PresenterConfigurableView: P_View {
    
    associatedtype PRESENTER: P_ViewPresenter where PRESENTER.VIEW == Self
    
}

extension P_PresenterConfigurableView {

    @discardableResult
    func configured(using presenter: PRESENTER) -> Self {
        presenter.updateUI(self)
        return self
    }

}

extension UITableView {
    
    func new<T: UITableViewHeaderFooterView & P_PresenterConfigurableView>(
        headerFooter: T.Type,
        reuseIdentifier: String = String(describing: T.self),
        presenter: T.PRESENTER
    ) -> T {
        self.new(headerFooter: headerFooter, reuseIdentifier: reuseIdentifier).configured(using: presenter)
    }
    
    func new<T: UITableViewCell & P_PresenterConfigurableView>(
        _ classType: T.Type,
        reuseIdentifier: String = String(describing: T.self),
        presenter: T.PRESENTER
    ) -> T {
        self.new(classType, reuseIdentifier: reuseIdentifier).configured(using: presenter)
    }
    
}
