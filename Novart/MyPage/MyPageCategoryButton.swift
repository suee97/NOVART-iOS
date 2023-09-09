import UIKit

final class MyPageCategoryButton: UIButton {

    var title: String!
    
    init(title: String) {
        super.init(frame: .zero)
        self.title = title
        setUpView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpView() {
        backgroundColor = .clear
        layer.cornerRadius = 12
        setTitle(title, for: .normal)
        setTitleColor(.Common.grey03, for: .normal)
        titleLabel?.font = UIFont(name: "Apple SD Gothic Neo Regular", size: 14)
    }

}
