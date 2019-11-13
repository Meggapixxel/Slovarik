import UIKit

protocol P_TableViewResizableFooter {
    
    var footerView: UIView? { get }
    var footerViewBottomSpacing: CGFloat { get }
    
}
extension P_TableViewResizableFooter {
    
    var footerView: UIView? { nil }
    var footerViewBottomSpacing: CGFloat { .scale1 }
    
    func updateFooterView(tableView: UITableView) {
        guard let footerView = self.footerView else { return }
        
        let contentHeight = tableView.contentSize.height
        let tableViewHeightWithoutContentInsets = tableView.frame.height - (tableView.contentInset.top + tableView.contentInset.bottom)
        
        if let footerView = tableView.tableFooterView {
            
            let oldFooterHeight = footerView.frame.height
            
            let footerHeight: CGFloat
            
            let contentHeightWithoutFooter = contentHeight - oldFooterHeight
            
            if contentHeightWithoutFooter > tableViewHeightWithoutContentInsets {
                footerHeight = 0
            } else {
                footerHeight = tableViewHeightWithoutContentInsets - contentHeightWithoutFooter - footerViewBottomSpacing
            }
            
            // compare CGFloat as String rounded two decimal because difference in last decimals values
            guard String(format: "%.2f", footerHeight) != String(format: "%.2f", oldFooterHeight) else { return }
            tableView.resizeFooter(toHeight: footerHeight)
        } else if contentHeight < tableViewHeightWithoutContentInsets {
            let footerHeight = tableViewHeightWithoutContentInsets - contentHeight - footerViewBottomSpacing
            tableView.tableFooterView = footerView
            tableView.resizeFooter(toHeight: footerHeight)
        }
    }
    
}


extension P_TableViewResizableFooter where Self: P_TableViewControllerPresenter {
    
    func updateFooterView() {
        updateFooterView(tableView: tableView)
    }
    
}
