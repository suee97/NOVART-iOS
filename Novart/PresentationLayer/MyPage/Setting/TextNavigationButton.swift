import UIKit

final class TextNavigationButton: UIView {
    
    private enum Constants {
        static let font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        static let textColor = UIColor.Common.black
        static let arrowDiameter: CGFloat = 24
    }
    
    init(title: String, onTap: @escaping (() -> Void)) {
        super.init(frame: .zero)
        setUpView()
        titleLabel.text = title
        
        transparentButton.addAction(UIAction(handler: { _ in
            onTap()
        }), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = Constants.textColor
        label.font = Constants.font
        return label
    }()
    
    private let transparentButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        return button
    }()
    
    private func setUpView() {
        let arrowImageView = UIImageView(image: UIImage(named: "icon_forward"))
        
        addSubview(titleLabel)
        addSubview(arrowImageView)
        addSubview(transparentButton)
        
        titleLabel.snp.makeConstraints({ m in
            m.left.centerY.equalToSuperview()
        })
        
        arrowImageView.snp.makeConstraints({ m in
            m.right.centerY.equalToSuperview()
            m.width.height.equalTo(Constants.arrowDiameter)
        })
        
        transparentButton.snp.makeConstraints({ m in
            m.edges.equalToSuperview()
        })
    }
}
