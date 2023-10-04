import UIKit
import SnapKit

final class MyPageHeaderView: UICollectionReusableView {
    // MARK: - Constants
    private enum Constants {
        static let screenWidth = UIScreen.main.bounds.width
        static let backgroundRat: CGFloat = 22/39
    }
    
    
    // MARK: - Properties
    var isGradient = false
    var onTapCategoryButton: ((_ category: MyPageCategory) -> ()) = {category in}
    var isHeaderSticky = false {
        didSet {
            setUpView()
        }
    }
    
    
    // MARK: - UI
    let backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let stickyBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .Common.white
        return view
    }()
    
    private let divider: UIView = {
        let view = UIView()
        view.backgroundColor = .Common.grey01
        return view
    }()
    
    private let profileImageFrame: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 54
        return view
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
    
    let interestButton = MyPageCategoryButton(category: .Interest)
    let followingButton = MyPageCategoryButton(category: .Following)
    let workButton = MyPageCategoryButton(category: .Work)
    let exhibitionButton = MyPageCategoryButton(category: .Exhibition)
    
    lazy var categoryButtons = [interestButton, followingButton, workButton, exhibitionButton]
    
    private lazy var categoryView: UIView = {
        let view = UIView()
        view.backgroundColor = .Common.grey00
        view.layer.cornerRadius = 12
        
        let barView1 = UIView()
        let barView2 = UIView()
        let barView3 = UIView()
        barView1.backgroundColor = .Common.grey01
        barView2.backgroundColor = .Common.grey01
        barView3.backgroundColor = .Common.grey01
        
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
        setUpInitView()
        interestButton.setState(true)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("MyPageHeaderView - deinit()")
    }
    
    private func setUpInitView() {
        backgroundColor = .clear
        addSubview(backgroundImageView)
        addSubview(stickyBackgroundView)
        addSubview(divider)
        addSubview(profileImageFrame)
        addSubview(profileImageView)
        addSubview(userNameLabel)
        addSubview(categoryView)
    }
    
    private func setUpView() {
        backgroundImageView.isHidden = isHeaderSticky
        stickyBackgroundView.isHidden = !isHeaderSticky
        profileImageFrame.isHidden = isHeaderSticky
        divider.isHidden = !isHeaderSticky
        
        backgroundImageView.snp.makeConstraints({ m in
            m.left.right.top.equalToSuperview()
            m.height.equalTo(Constants.screenWidth * Constants.backgroundRat)
        })
        
        stickyBackgroundView.snp.makeConstraints({ m in
            m.left.right.top.equalToSuperview()
            m.height.equalTo(201)
        })
        
        profileImageFrame.snp.makeConstraints({ m in
            m.centerX.equalToSuperview()
            m.width.height.equalTo(108)
            m.centerY.equalTo(backgroundImageView.snp.bottom)
        })
        
        divider.snp.makeConstraints({ m in
            m.height.equalTo(1)
            m.left.right.equalToSuperview()
            m.bottom.equalTo(stickyBackgroundView.snp.bottom)
        })
        
        profileImageView.snp.removeConstraints()
        categoryView.snp.removeConstraints()
        userNameLabel.snp.removeConstraints()
        
        if !isHeaderSticky {
            profileImageView.snp.makeConstraints({ m in
                m.centerX.equalToSuperview()
                m.width.height.equalTo(100)
                m.centerY.equalTo(backgroundImageView.snp.bottom)
            })
            
            userNameLabel.font = userNameLabel.font.withSize(28)
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
        } else {
            profileImageView.snp.makeConstraints({ m in
                m.top.equalToSuperview().inset(103)
                m.left.equalToSuperview().inset(24)
                m.width.height.equalTo(32)
            })
            
            userNameLabel.font = userNameLabel.font.withSize(18)
            userNameLabel.snp.makeConstraints({ m in
                m.centerY.equalTo(profileImageView)
                m.left.equalTo(profileImageView.snp.right).offset(8)
            })
            
            categoryView.snp.makeConstraints({ m in
                m.bottom.equalTo(stickyBackgroundView.snp.bottom).offset(-6)
                m.width.equalTo(342)
                m.height.equalTo(44)
                m.centerX.equalToSuperview()
            })
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if !isGradient {
            addGradient()
            isGradient = true
        }
    }
    
    private func addGradient() {
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
        onTapCategoryButton(MyPageCategory.Interest)
    }
    
    @objc private func onTapFollowingButton() {
        onTapCategoryButton(MyPageCategory.Following)
    }
    
    @objc private func onTapWorkButton() {
        onTapCategoryButton(MyPageCategory.Work)
    }
    
    @objc private func onTapExhibitionButton() {
        onTapCategoryButton(MyPageCategory.Exhibition)
    }
}
