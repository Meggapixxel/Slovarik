import UIKit

extension UITableView {
    
    func sizeHeaderToFit() {
        guard let headerView = self.tableHeaderView else { return }
        let height = headerView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
        resizeHeader(toHeight: height)
    }
    
    func resizeHeader(toHeight height: CGFloat) {
        guard let headerView = self.tableHeaderView, headerView.frame.height != height else { return }
        headerView.setNeedsLayout()
        headerView.layoutIfNeeded()
        
        var frame = headerView.frame
        frame.size.height = height
        headerView.frame = frame
        
        self.tableHeaderView = headerView
    }
    
    func sizeFooterToFit() {
        guard let footerView = tableFooterView else { return }
        let height = footerView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
        resizeFooter(toHeight: height)
    }
    
    func resizeFooter(toHeight height: CGFloat) {
        guard let footerView = self.tableFooterView, footerView.frame.height != height else { return }
        footerView.setNeedsLayout()
        footerView.layoutIfNeeded()
        
        var frame = footerView.frame
        frame.size.height = height
        footerView.frame = frame
        
        self.tableFooterView = footerView
    }
    
}
