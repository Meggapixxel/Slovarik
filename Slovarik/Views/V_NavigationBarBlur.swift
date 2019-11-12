import UIKit

class V_NavigationBarBlur: UINavigationBar {

    private(set) lazy var blurView: UIVisualEffectView = {
        let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .prominent))
        blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurView.isUserInteractionEnabled = false
        return blurView
    }()

    init() {
        super.init(frame: .zero)
        commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        addSubview(blurView)
        blurView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(
            [
                blurView.leadingAnchor.constraint(equalTo: leadingAnchor),
                blurView.trailingAnchor.constraint(equalTo: trailingAnchor),
                blurView.topAnchor.constraint(equalTo: topAnchor, constant: -(UIApplication.shared.windows.first?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0)),
                blurView.bottomAnchor.constraint(equalTo: bottomAnchor)
            ]
        )
        blurView.layer.zPosition = -1
        setBackgroundImage(UIImage(), for: .default)
        shadowImage = UIImage()
        isTranslucent = true
    }
    
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        let statusBarHeight = UIApplication.shared.windows.first?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
//        var blurFrame = bounds
//        blurFrame.size.height += statusBarHeight + 1
//        blurFrame.origin.y -= statusBarHeight
//        blurView.frame = blurFrame
//    }
    
}
