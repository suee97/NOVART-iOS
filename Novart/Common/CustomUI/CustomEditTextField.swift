import UIKit

final class CustomEditTextField: UITextField {
    enum Constants {
        static let leftMargin: CGFloat = 14
        static let font = UIFont.systemFont(ofSize: 16, weight: .regular)
    }
    
    private let leftSpace = UIView(frame: CGRect(x: 0, y: 0, width: Constants.leftMargin, height: 0))
    
    init(placeholder: String) {
        super.init(frame: .zero)
        setUp(placeholder: placeholder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUp(placeholder: String) {
        attributedPlaceholder = NSAttributedString(
            string: placeholder,
            attributes: [
                NSAttributedString.Key.foregroundColor: UIColor.Common.grey02,
                NSAttributedString.Key.font: Constants.font
            ]
        )
        
        layer.borderWidth = 1
        layer.cornerRadius = 12
        layer.borderColor = UIColor.Common.grey01.cgColor
        font = Constants.font
        leftView = leftSpace
        leftViewMode = .always
        
        spellCheckingType = .no
        autocorrectionType = .no
        autocapitalizationType = .none
    }
}
