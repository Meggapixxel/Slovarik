import UIKit

@objc protocol TabViewDelegate: class {
    
    func didScrolling(_ loginTabView: V_TabView, to index: CGFloat)
    func didChangeSelectedIndex(_ loginTabView: V_TabView, to index: Int)
    
}

class V_TabView: UIView {
    
    @IBOutlet private(set) weak var rootScrollView: UIScrollView!
    @IBOutlet private(set) weak var tabItemsStackView: UIStackView!
    @IBOutlet private(set) weak var lineView: UIView!
    @IBOutlet private(set) weak var lineViewLeadingConstraint: NSLayoutConstraint!
    @IBOutlet private(set) weak var observableScrollView: UIScrollView!
    
    @IBOutlet weak var delegate: TabViewDelegate?
    
    private var selectedIndex = 0 {
        didSet {
            delegate?.didChangeSelectedIndex(self, to: selectedIndex)
        }
    }
    
    private var contentOffsetKVO: NSKeyValueObservation?
    
    deinit {
        contentOffsetKVO?.invalidate()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        contentOffsetKVO = observableScrollView.observe(\.contentOffset, options: [.new, .old]) { [weak self] (scrollView, change) in
            guard let self = self, change.newValue?.x != change.oldValue?.x else { return }
            let koef = scrollView.contentOffset.x / scrollView.frame.width
            self.delegate?.didScrolling(self, to: koef)
            self.lineViewLeadingConstraint.constant = self.lineView.frame.width * koef
            
            let index = koef.truncatingRemainder(dividingBy: 1)
            guard index == 0, Int(koef) != self.selectedIndex else { return }
            self.selectedIndex = Int(koef)
        }
    }
    
}

extension V_TabView {
    
    @IBAction private func didTapTabItem(_ sender: UIButton) {
        guard let index = tabItemsStackView.arrangedSubviews.firstIndex(of: sender),
            index != selectedIndex
            else { return }
        observableScrollView.setContentOffset(
            CGPoint(x: observableScrollView.frame.width * CGFloat(index), y: 0),
            animated: true
        )
    }
    
}
