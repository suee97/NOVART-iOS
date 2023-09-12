import UIKit
import SnapKit

final class MyPageHeaderView: UICollectionReusableView {
    // MARK: - Constants
    private enum Constants {
        static let screenWidth = UIScreen.main.bounds.width
        static let backgroundRat: CGFloat = 22/39
    }
    
    
    // MARK: - Properties
    static let id = "my_page_header_view"
    var onTap: ((_ category: MyPageCategory) -> ()) = {category in}
    
    
    // MARK: - UI
    let backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    let userNameLabel: UILabel = {
        let label = UILabel()
        label.text = "게스트"
        label.font = UIFont(name: "Apple SD Gothic Neo Bold", size: 28)
        return label
    }()
    
    private let categoryView: UIView = {
        let view = UIView()
        view.backgroundColor = .Common.grey00
        view.layer.cornerRadius = 12
        
        let barView1 = UIView()
        let barView2 = UIView()
        let barView3 = UIView()
        barView1.backgroundColor = .Common.grey01
        barView2.backgroundColor = .Common.grey01
        barView3.backgroundColor = .Common.grey01
        
        let interestButton = MyPageCategoryButton(title: MyPageCategory.Interest.rawValue)
        let followingButton = MyPageCategoryButton(title: MyPageCategory.Following.rawValue)
        let workButton = MyPageCategoryButton(title: MyPageCategory.Work.rawValue)
        let exhibitionButton = MyPageCategoryButton(title: MyPageCategory.Exhibition.rawValue)
        
        interestButton.addTarget(self, action: #selector(onTapInterestButton), for: .touchUpInside)
        followingButton.addTarget(self, action: #selector(onTapFollowingButton), for: .touchUpInside)
        workButton.addTarget(self, action: #selector(onTapWorkButton), for: .touchUpInside)
        exhibitionButton.addTarget(self, action: #selector(onTapExhibitionButton), for: .touchUpInside)
        
        view.addSubview(interestButton)
        view.addSubview(followingButton)
        view.addSubview(workButton)
        view.addSubview(exhibitionButton)
        view.addSubview(barView1)
        view.addSubview(barView2)
        view.addSubview(barView3)
        
        interestButton.snp.makeConstraints({ m in
            m.width.equalTo(84)
            m.height.equalTo(44)
            m.left.top.equalTo(view)
        })
        barView1.snp.makeConstraints({ m in
            m.width.equalTo(1)
            m.height.equalTo(16)
            m.left.equalTo(interestButton.snp.right)
            m.centerY.equalTo(view)
        })
        followingButton.snp.makeConstraints({ m in
            m.width.equalTo(84)
            m.height.equalTo(44)
            m.left.equalTo(barView1.snp.right)
            m.top.equalTo(view)
        })
        barView2.snp.makeConstraints({ m in
            m.width.equalTo(1)
            m.height.equalTo(16)
            m.left.equalTo(followingButton.snp.right)
            m.centerY.equalTo(view)
        })
        workButton.snp.makeConstraints({ m in
            m.width.equalTo(84)
            m.height.equalTo(44)
            m.top.equalTo(view)
            m.left.equalTo(barView2.snp.right)
        })
        barView3.snp.makeConstraints({ m in
            m.width.equalTo(1)
            m.height.equalTo(16)
            m.left.equalTo(workButton.snp.right)
            m.centerY.equalTo(view)
        })
        exhibitionButton.snp.makeConstraints({ m in
            m.width.equalTo(84)
            m.height.equalTo(44)
            m.left.equalTo(barView3.snp.right)
            m.top.equalTo(view)
        })
        
        return view
    }()
    
    
    // MARK: - LifeCycle
    override init(frame: CGRect) {
        print("MyPageHeaderView - init()")
        super.init(frame: frame)
        setUpView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("MyPageHeaderView - deinit()")
    }
    
    private func setUpView() {
        backgroundColor = .clear
        addSubview(backgroundImageView)
        addSubview(profileImageView)
        addSubview(userNameLabel)
        addSubview(categoryView)
        
        backgroundImageView.snp.makeConstraints({ m in
            m.left.right.top.equalToSuperview()
            m.height.equalTo(Constants.screenWidth * Constants.backgroundRat)
        })
        
        profileImageView.snp.makeConstraints({ m in
            m.centerX.equalToSuperview()
            m.width.height.equalTo(108)
            m.centerY.equalTo(backgroundImageView.snp.bottom)
        })
        
        userNameLabel.snp.makeConstraints({ m in
            m.centerX.equalToSuperview()
            m.top.equalTo(profileImageView.snp.bottom).offset(8)
        })
        
        categoryView.snp.makeConstraints({ m in
            m.top.equalTo(userNameLabel.snp.bottom).offset(18)
            m.width.equalTo(342)
            m.height.equalTo(44)
            m.centerX.equalToSuperview()
        })
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = backgroundImageView.bounds
        let colors: [CGColor] = [UIColor.white.withAlphaComponent(0.0).cgColor, UIColor.white.cgColor]
        gradientLayer.colors = colors
        
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
        gradientLayer.locations = [0.5, 1.0]
        backgroundImageView.layer.addSublayer(gradientLayer)
    }
    
    
    // MARK: - Selectors
    @objc private func onTapInterestButton() {
        onTap(MyPageCategory.Interest)
    }
    
    @objc private func onTapFollowingButton() {
        onTap(MyPageCategory.Following)
    }
    
    @objc private func onTapWorkButton() {
        onTap(MyPageCategory.Work)
    }
    
    @objc private func onTapExhibitionButton() {
        onTap(MyPageCategory.Exhibition)
    }
}
