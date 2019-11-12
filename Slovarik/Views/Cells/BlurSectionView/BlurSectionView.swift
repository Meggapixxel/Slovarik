import UIKit

class BlurSectionView: UITableViewHeaderFooterView {

    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var blurViewBottomConstraint: NSLayoutConstraint!
    
    var presenter = Presenter()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundView = UIView()
        backgroundView?.backgroundColor = .clear
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        blurViewBottomConstraint.constant = 1 / UIScreen.main.scale
    }
    
}

extension BlurSectionView: P_PresenterConfigurableView {
    
    typealias PRESENTER = Presenter
    
}

extension BlurSectionView {
    
    class Presenter: P_ViewPresenter {
        
        let title: String?

        init(title: String? = nil) {
            self.title = title
        }
        
        func updateUI(_ view: BlurSectionView) {
            view.nameLabel.text = title
        }
        
    }
    
}
