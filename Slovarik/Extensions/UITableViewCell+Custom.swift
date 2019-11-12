import UIKit

extension UITableViewCell {
    
    var superTableView: UITableView? {
        return next(UITableView.self)
    }
    
    var selfIndexPath: IndexPath? {
        guard let tableView = superTableView else { return nil }
        return tableView.indexPath(for: self)
    }
    
}
