import UIKit
import SnapKit

final class SearchNoResultView: UIView {
    
    // MARK: - Properties
    private enum Constants {
        static let iconDiameter: CGFloat = 24
        static let description = "검색 결과가 없어요"
        static let font = UIFont.systemFont(ofSize: 16, weight: .regular)
        static let color = UIColor.Common.grey03
        static let topMargin: CGFloat = 8
    }
    
    init() {
        super.init(frame: .zero)
        setUpView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - UI
    private let icon: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "icon_search_no_result"))
        return imageView
    }()
    
    private let desc: UILabel = {
        let label = UILabel()
        label.text = Constants.description
        label.font = Constants.font
        label.textColor = Constants.color
        return label
    }()
    
    private func setUpView() {
        addSubview(icon)
        addSubview(desc)
        
        icon.snp.makeConstraints({ m in
            m.centerX.top.equalToSuperview()
            m.width.height.equalTo(Constants.iconDiameter)
        })
        
        desc.snp.makeConstraints({ m in
            m.centerX.equalToSuperview()
            m.top.equalTo(icon.snp.bottom).offset(Constants.topMargin)
        })
    }
}
