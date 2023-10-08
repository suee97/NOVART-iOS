import UIKit

final class MyPageCategoryButton: UIButton {

    private enum Constants {
        static let unSelectedFont = UIFont(name: "Apple SD Gothic Neo Regular", size: 14)
        static let selectedFont = UIFont(name: "Apple SD Gothic Neo Bold", size: 14)
    }
    
    var category: MyPageCategory!
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                setTitleColor(.Common.black, for: .normal)
                titleLabel?.font = Constants.selectedFont
            } else {
                setTitleColor(.Common.grey03, for: .normal)
                titleLabel?.font = Constants.unSelectedFont
            }
        }
    }
    
    init(category: MyPageCategory) {
        super.init(frame: .zero)
        self.category = category
        self.setTitle(category.rawValue, for: .normal)
        setUpView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpView() {
        backgroundColor = .clear
        layer.cornerRadius = 12
        isSelected = false
    }
    
    func setState(_ state: Bool) {
        isSelected = state
    }

}
