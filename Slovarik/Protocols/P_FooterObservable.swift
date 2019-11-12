import UIKit

protocol P_FooterObservable {
    
}
extension P_FooterObservable {
    
    func updateFooterView(tableView: UITableView, bottomSpacing: CGFloat) {
        guard tableView.tableFooterView != nil else { return }
        let contentHeight = tableView.contentSize.height
        let tableViewHeightWithoutContentInsets = tableView.frame.height - (tableView.contentInset.top + tableView.contentInset.bottom)
        
        let oldFooterHeight = tableView.tableFooterView?.frame.height ?? 0
        
        let footerHeight: CGFloat
        
        let contentHeightWithoutFooter = contentHeight - oldFooterHeight
        
        if contentHeightWithoutFooter > tableViewHeightWithoutContentInsets {
            footerHeight = 0
        } else {
            footerHeight = tableViewHeightWithoutContentInsets - contentHeightWithoutFooter - bottomSpacing
        }
        
        // compare CGFloat as String rounded two decimal because difference in last decimals values
        guard String(format: "%.2f", footerHeight) != String(format: "%.2f", oldFooterHeight) else { return }
        tableView.resizeFooter(toHeight: footerHeight)
    }
    
}
