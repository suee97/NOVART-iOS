import UIKit
import SnapKit

class PlainButton: UIButton {
    
    private enum Constants {
        static let buttonRadius: CGFloat = 12
        static let dimRadius: CGFloat = 12
        
        static let backgroundColor = UIColor.Common.main
        static let foregroundColor = UIColor.Common.white
        
        static let highlightedDimColor = UIColor.black.withAlphaComponent(0.1)
        static let unHighlightedDimColor = UIColor.black.withAlphaComponent(0)
    }
    
    override var isHighlighted: Bool {
        didSet {
            dimView.backgroundColor = isHighlighted ? Constants.highlightedDimColor : Constants.unHighlightedDimColor
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let dimView = UIView()
    
    private func setUpView() {
        backgroundColor = Constants.backgroundColor
        setTitleColor(Constants.foregroundColor, for: .normal)
        layer.cornerRadius = Constants.buttonRadius
        
        addSubview(dimView)
        dimView.isUserInteractionEnabled = false
        dimView.layer.cornerRadius = Constants.dimRadius
        dimView.snp.makeConstraints({ m in
            m.edges.equalToSuperview()
        })
    }
}
