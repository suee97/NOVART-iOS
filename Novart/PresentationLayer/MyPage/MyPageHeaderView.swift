import UIKit
import SnapKit
import Kingfisher

final class MyPageHeaderView: UICollectionReusableView {
    
    // MARK: - Constants
    private enum Constants {
        static let screenWidth = UIScreen.main.bounds.size.width
        static let screenHeight = UIScreen.main.bounds.size.height
        
        static func getRelativeWidth(from width: CGFloat) -> CGFloat {
            Constants.screenWidth * (width/390)
        }
        static func getRelativeHeight(from height: CGFloat) -> CGFloat {
            Constants.screenHeight * (height/844)
        }
        
        static let profileLabelTextColor = UIColor.Common.black
        
        enum CategoryView {
            static let radius: CGFloat = 12
            
            static let width = getRelativeWidth(from: 342)
            static let height = getRelativeHeight(from: 44)
            
            static let buttonWidth = (Constants.CategoryView.width - 3) / 4
            static let buttonHeight = getRelativeHeight(from: 44)
            
            static let barWidth: CGFloat = 1
            static let barHeight = getRelativeHeight(from: 16)
        }
        
        enum NonSticky {
            static let backgroundHeight: CGFloat = getRelativeHeight(from: 220)
            static let profileFrameDiameter = getRelativeWidth(from: 108)
            static let profileImageDiameter = getRelativeWidth(from: 100)
            static let profileFont = UIFont.systemFont(ofSize: 24, weight: .bold)
            static let profileLabelTopMargin = getRelativeHeight(from: 8)
            static let categoryTopMargin = getRelativeHeight(from: 18)
            
            enum LoginInduceView {
                static let width = getRelativeWidth(from: 160)
                static let height = getRelativeHeight(from: 120)
                static let topMargin: CGFloat = getRelativeHeight(from: 94)
                
                enum Icon {
                    static let image = UIImage(named: "icon_plain_black")
                    static let width: CGFloat = getRelativeWidth(from: 24)
                }
                
                enum Label {
                    static let text = "로그인 후 확인해보세요"
                    static let textColor = UIColor.Common.grey03
                    static let font = UIFont.systemFont(ofSize: 16, weight: .regular)
                    static let topMargin = getRelativeHeight(from: 8)
                }

                enum Button {
                    static let width = getRelativeWidth(from: 89)
                    static let height = getRelativeHeight(from: 36)
                    static let topMargin: CGFloat = getRelativeHeight(from: 24)
                    
                    static let radius: CGFloat = 12
                    static let backgroundColor = UIColor.Common.main
                    
                    static let text = "로그인 하기"
                    static let textColor = UIColor.Common.white
                    static let font = UIFont.systemFont(ofSize: 14, weight: .bold)
                }
            }
            
            enum JobLabel {
                static let font = UIFont.systemFont(ofSize: 12, weight: .medium)
                static let color = UIColor.Common.grey03
                static let defaultText = "나를 소개해보세요 📝"
                static let topMargin = getRelativeHeight(from: 2)
            }
            
            enum InterestRecommendLabel {
                static let text = "관심중인 작품이 없어요\n지금 바로 관람해 보세요!"
                static let textColor = UIColor.Common.grey03
                static let font = UIFont.systemFont(ofSize: 16, weight: .regular)
                static let topMargin = getRelativeHeight(from: 26)
                static let bottomMargin = getRelativeHeight(from: 16)
            }
            
            enum FollowingRecommendLabel {
                static let text = "팔로잉한 작가가 없어요\n작가를 추천해 드릴게요!"
                static let textColor = UIColor.Common.grey03
                static let font = UIFont.systemFont(ofSize: 16, weight: .regular)
                static let topMargin = getRelativeHeight(from: 26)
                static let bottomMargin = getRelativeHeight(from: 16)
            }
        }
        
        enum Sticky {
            static let backgroundHeight = getRelativeHeight(from: 201)
            static let profileImageDiameter: CGFloat = getRelativeWidth(from: 32)
            static let profileFont = UIFont.systemFont(ofSize: 18, weight: .bold)
            static let profileLabelLeftMargin: CGFloat = getRelativeWidth(from: 8)
            static let profileImageMargin = (top: getRelativeHeight(from: 103), left: getRelativeWidth(from: 24))
            static let categoryTopMargin: CGFloat = getRelativeHeight(from: 16)
        }
        
        enum TagStackView {
            static let topMargin = getRelativeHeight(from: 8)
        }
    }
    
    
    // MARK: - Properties
    var onTapCategoryButton: ((_ category: MyPageCategory) -> ()) = {category in}
    var isHeaderSticky = false
    var isFirstSetUp = true
    var isGradient = false
    var delegate: MyPageHeaderViewDelegate?
    
    
    // MARK: - LifeCycle
    override init(frame: CGRect) {
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - UI
    let backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
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
    
    lazy var profileImageFrame: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = Constants.NonSticky.profileFrameDiameter / 2
        let gesture = UITapGestureRecognizer(target: self, action: #selector(onTapProfileImage))
        view.addGestureRecognizer(gesture)
        return view
    }()
    
    private lazy var profileImageView: PlainProfileImageView = {
        let imageView = PlainProfileImageView()
        return imageView
    }()
    
    lazy var profileLabel: UILabel = {
        let label = UILabel()
        label.textColor = Constants.profileLabelTextColor
        label.font = Constants.NonSticky.profileFont
        label.isUserInteractionEnabled = true
        let gesture = UITapGestureRecognizer(target: self, action: #selector(onTapProfileLabel))
        label.addGestureRecognizer(gesture)
        return label
    }()
    
    private var jobLabel: UILabel = {
        let label = UILabel()
        label.font = Constants.NonSticky.JobLabel.font
        label.textColor = Constants.NonSticky.JobLabel.color
        return label
    }()
    
    private var tagStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = Constants.getRelativeWidth(from: 4)
        stackView.distribution = .equalSpacing
        return stackView
    }()
    
    let interestButton = MyPageCategoryButton(category: .Interest)
    let followingButton = MyPageCategoryButton(category: .Following)
    let workButton = MyPageCategoryButton(category: .Work)
    let exhibitionButton = MyPageCategoryButton(category: .Exhibition)
    
    lazy var categoryButtons = [interestButton, followingButton, workButton, exhibitionButton]
    
    private lazy var categoryView: UIView = {
        let view = UIView()
        view.backgroundColor = .Common.grey00
        view.layer.cornerRadius = Constants.CategoryView.radius
        
        let barView1 = UIView()
        let barView2 = UIView()
        let barView3 = UIView()
        barView1.backgroundColor = .Common.grey01
        barView2.backgroundColor = .Common.grey01
        barView3.backgroundColor = .Common.grey01
        
        interestButton.addAction(UIAction(handler: { [weak self] _ in
            guard let self else { return }
            self.onTapCategoryButton(MyPageCategory.Interest)
        }), for: .touchUpInside)
        
        followingButton.addAction(UIAction(handler: { [weak self] _ in
            guard let self else { return }
            self.onTapCategoryButton(MyPageCategory.Following)
        }), for: .touchUpInside)
        
        workButton.addAction(UIAction(handler: { [weak self] _ in
            guard let self else { return }
            self.onTapCategoryButton(MyPageCategory.Work)
        }), for: .touchUpInside)
        
        exhibitionButton.addAction(UIAction(handler: { [weak self] _ in
            guard let self else { return }
            self.onTapCategoryButton(MyPageCategory.Exhibition)
        }), for: .touchUpInside)
        
        view.addSubview(interestButton)
        view.addSubview(followingButton)
        view.addSubview(workButton)
        view.addSubview(exhibitionButton)
        view.addSubview(barView1)
        view.addSubview(barView2)
        view.addSubview(barView3)
        
        interestButton.snp.makeConstraints({ m in
            m.width.equalTo(Constants.CategoryView.buttonWidth)
            m.height.equalTo(Constants.CategoryView.buttonHeight)
            m.left.top.equalTo(view)
        })
        barView1.snp.makeConstraints({ m in
            m.width.equalTo(Constants.CategoryView.barWidth)
            m.height.equalTo(Constants.CategoryView.barHeight)
            m.left.equalTo(interestButton.snp.right)
            m.centerY.equalTo(view)
        })
        followingButton.snp.makeConstraints({ m in
            m.width.equalTo(Constants.CategoryView.buttonWidth)
            m.height.equalTo(Constants.CategoryView.buttonHeight)
            m.left.equalTo(barView1.snp.right)
            m.top.equalTo(view)
        })
        barView2.snp.makeConstraints({ m in
            m.width.equalTo(Constants.CategoryView.barWidth)
            m.height.equalTo(Constants.CategoryView.barHeight)
            m.left.equalTo(followingButton.snp.right)
            m.centerY.equalTo(view)
        })
        workButton.snp.makeConstraints({ m in
            m.width.equalTo(Constants.CategoryView.buttonWidth)
            m.height.equalTo(Constants.CategoryView.buttonHeight)
            m.top.equalTo(view)
            m.left.equalTo(barView2.snp.right)
        })
        barView3.snp.makeConstraints({ m in
            m.width.equalTo(Constants.CategoryView.barWidth)
            m.height.equalTo(Constants.CategoryView.barHeight)
            m.left.equalTo(workButton.snp.right)
            m.centerY.equalTo(view)
        })
        exhibitionButton.snp.makeConstraints({ m in
            m.width.equalTo(Constants.CategoryView.buttonWidth)
            m.height.equalTo(Constants.CategoryView.buttonHeight)
            m.left.equalTo(barView3.snp.right)
            m.top.equalTo(view)
        })
        
        return view
    }()
    
    private lazy var loginButton: PlainButton = {
        let button = PlainButton()
        button.setTitle(Constants.NonSticky.LoginInduceView.Button.text, for: .normal)
        button.titleLabel?.font = Constants.NonSticky.LoginInduceView.Button.font
        button.addAction(UIAction(handler: { [weak self] _ in
            guard let self else { return }
            self.delegate?.onTapLoginButton()
        }), for: .touchUpInside)
        return button
    }()
    
    private lazy var loginInduceView: UIView = {
        let view = UIView()
        let iconImageView = UIImageView(image: Constants.NonSticky.LoginInduceView.Icon.image)
        let label = UILabel()
        
        label.text = Constants.NonSticky.LoginInduceView.Label.text
        label.textColor = Constants.NonSticky.LoginInduceView.Label.textColor
        label.font = Constants.NonSticky.LoginInduceView.Label.font
        
        view.addSubview(iconImageView)
        view.addSubview(label)
        view.addSubview(loginButton)
        
        iconImageView.snp.makeConstraints({ m in
            m.centerX.top.equalToSuperview()
        })
        label.snp.makeConstraints({ m in
            m.top.equalTo(iconImageView.snp.bottom).offset(Constants.NonSticky.LoginInduceView.Label.topMargin)
            m.centerX.equalToSuperview()
        })
        loginButton.snp.makeConstraints({ m in
            m.top.equalTo(label.snp.bottom).offset(Constants.NonSticky.LoginInduceView.Button.topMargin)
            m.width.equalTo(Constants.NonSticky.LoginInduceView.Button.width)
            m.height.equalTo(Constants.NonSticky.LoginInduceView.Button.height)
            m.centerX.equalToSuperview()
        })
        
        return view
    }()
    
    private let interestRecommendLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.text = Constants.NonSticky.InterestRecommendLabel.text
        label.textColor = Constants.NonSticky.InterestRecommendLabel.textColor
        label.font = Constants.NonSticky.InterestRecommendLabel.font
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.sizeToFit()
        return label
    }()
    
    private let followingRecommendLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.text = Constants.NonSticky.FollowingRecommendLabel.text
        label.textColor = Constants.NonSticky.FollowingRecommendLabel.textColor
        label.font = Constants.NonSticky.FollowingRecommendLabel.font
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.sizeToFit()
        return label
    }()
    
    private lazy var loggedOutViews = [backgroundImageView, profileImageFrame, profileImageView, profileLabel, categoryView, loginInduceView]
    private lazy var meViews = [backgroundImageView, stickyBackgroundView, profileImageFrame, profileImageView, profileLabel, jobLabel, tagStackView, categoryView, divider, interestRecommendLabel, followingRecommendLabel]
    
    func update(user: PlainUser?, userState: MyPageUserState, isInterestsEmpty: Bool = false, isFollowingsEmpty: Bool = false) {
        setUpView(user: user, userState: userState, isInterestsEmpty: isInterestsEmpty, isFollowingsEmpty: isFollowingsEmpty)
    }
    
    private func setUpView(user: PlainUser?, userState: MyPageUserState, isInterestsEmpty: Bool, isFollowingsEmpty: Bool) {
        
        if userState == .loggedOut {
            
            if backgroundImageView.image == nil {
                backgroundImageView.image = UIImage(named: "default_user_background_image")
            }
            
            profileImageView.layer.cornerRadius = Constants.NonSticky.profileImageDiameter / 2
            profileLabel.font = Constants.NonSticky.profileFont
            
            profileLabel.text = "게스트"
            
            loggedOutViews.forEach {
                if !$0.isDescendant(of: self) { addSubview($0) }
                $0.snp.removeConstraints()
            }
            
            backgroundImageView.snp.makeConstraints({ m in
                m.left.right.top.equalToSuperview()
                m.height.equalTo(Constants.NonSticky.backgroundHeight)
            })
            
            profileImageView.snp.makeConstraints({ m in
                m.centerX.equalToSuperview()
                m.width.height.equalTo(Constants.NonSticky.profileImageDiameter)
                m.centerY.equalTo(backgroundImageView.snp.bottom)
            })
            
            profileImageFrame.snp.makeConstraints({ m in
                m.center.equalTo(profileImageView)
                m.width.height.equalTo(Constants.NonSticky.profileFrameDiameter)
            })
            
            profileLabel.snp.makeConstraints({ m in
                m.centerX.equalToSuperview()
                m.top.equalTo(profileImageView.snp.bottom).offset(Constants.NonSticky.profileLabelTopMargin)
            })
            
            categoryView.snp.makeConstraints({ m in
                m.top.equalTo(profileLabel.snp.bottom).offset(Constants.getRelativeHeight(from: 18))
                m.width.equalTo(Constants.CategoryView.width)
                m.height.equalTo(Constants.CategoryView.height)
                m.centerX.equalToSuperview()
            })
            
            loginInduceView.snp.makeConstraints({ m in
                m.top.equalTo(categoryView.snp.bottom).offset(Constants.getRelativeHeight(from: 94))
                m.width.equalTo(Constants.NonSticky.LoginInduceView.width)
                m.height.equalTo(Constants.NonSticky.LoginInduceView.height)
                m.centerX.equalToSuperview()
                m.bottom.equalToSuperview()
            })
            
            return
        }
        
        if userState == .me || userState == .other {
            guard let user else { return }
            
            if user.backgroundImageUrl == nil {
                backgroundImageView.image = UIImage(named: "default_user_background_image")
            } else {
                if let urlString = user.backgroundImageUrl, let url = URL(string: urlString) {
                    let retryStrategy = DelayRetryStrategy(maxRetryCount: 3, retryInterval: .seconds(1))
                    backgroundImageView.kf.setImage(with: url, options: [.retryStrategy(retryStrategy)])
                }
            }
            
            if let urlString = user.profileImageUrl, let url = URL(string: urlString) {
                profileImageView.setImage(with: url)
            }
            
            profileLabel.text = user.nickname
            if user.jobs.isEmpty {
                jobLabel.text = Constants.NonSticky.JobLabel.defaultText
            } else {
                jobLabel.text = user.jobs.joined(separator: ", ")
            }
            
            meViews.forEach {
                if !$0.isDescendant(of: self) { addSubview($0) }
                $0.snp.removeConstraints()
            }
            while let first = tagStackView.arrangedSubviews.first {
                tagStackView.removeArrangedSubview(first)
                first.removeFromSuperview()
            }
            for e in user.tags {
                let label = MyPageTagLabel(text: e)
                tagStackView.addArrangedSubview(label)
            }
            
            if isHeaderSticky {
                stickyBackgroundView.isHidden = false
                divider.isHidden = false
                profileImageView.layer.cornerRadius = Constants.Sticky.profileImageDiameter / 2
                profileLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
                
                let hiddenViews = [backgroundImageView, profileImageFrame, jobLabel, interestRecommendLabel, followingRecommendLabel]
                hiddenViews.forEach {
                    $0.isHidden = true
                }
                
                stickyBackgroundView.snp.makeConstraints({ m in
                    m.left.right.top.equalToSuperview()
                    m.height.equalTo(Constants.Sticky.backgroundHeight)
                })
                
                profileImageView.snp.makeConstraints({ m in
                    m.left.equalToSuperview().inset(Constants.Sticky.profileImageMargin.left)
                    m.top.equalToSuperview().inset(Constants.Sticky.profileImageMargin.top)
                    m.width.height.equalTo(Constants.Sticky.profileImageDiameter)
                })
                
                profileLabel.snp.makeConstraints({ m in
                    m.left.equalTo(profileImageView.snp.right).offset(Constants.getRelativeWidth(from: 8))
                    m.centerY.equalTo(profileImageView)
                })
                
                tagStackView.snp.makeConstraints({ m in
                    m.centerY.equalTo(profileImageView)
                    m.right.equalToSuperview().inset(Constants.getRelativeWidth(from: 24))
                })
                
                categoryView.snp.makeConstraints({ m in
                    m.centerX.equalToSuperview()
                    m.top.equalToSuperview().inset(Constants.getRelativeHeight(from: 151))
                    m.width.equalTo(Constants.CategoryView.width)
                    m.height.equalTo(Constants.CategoryView.height)
                })
                
                divider.snp.makeConstraints({ m in
                    m.left.right.equalToSuperview()
                    m.top.equalTo(stickyBackgroundView.snp.bottom)
                    m.height.equalTo(Constants.getRelativeHeight(from: 1))
                    m.bottom.equalToSuperview()
                })
            } else {
                backgroundImageView.isHidden = false
                profileImageFrame.isHidden = false
                jobLabel.isHidden = false
                interestRecommendLabel.isHidden = false
                followingRecommendLabel.isHidden = false
                profileImageView.layer.cornerRadius = Constants.NonSticky.profileImageDiameter / 2
                profileLabel.font = UIFont.systemFont(ofSize: 24, weight: .bold)
                
                let hiddenViews = [stickyBackgroundView, divider]
                hiddenViews.forEach {
                    $0.isHidden = true
                }
                
                backgroundImageView.snp.makeConstraints({ m in
                    m.left.top.right.equalToSuperview()
                    m.height.equalTo(Constants.NonSticky.backgroundHeight)
                })
                
                profileImageFrame.snp.makeConstraints({ m in
                    m.centerX.equalToSuperview()
                    m.centerY.equalTo(backgroundImageView.snp.bottom)
                    m.width.height.equalTo(Constants.NonSticky.profileFrameDiameter)
                })
                
                profileImageView.snp.makeConstraints({ m in
                    m.center.equalTo(profileImageFrame)
                    m.width.height.equalTo(Constants.NonSticky.profileImageDiameter)
                })
                
                profileLabel.snp.makeConstraints({ m in
                    m.top.equalTo(profileImageFrame.snp.bottom).offset(Constants.NonSticky.profileLabelTopMargin)
                    m.centerX.equalToSuperview()
                })
                
                jobLabel.snp.makeConstraints({ m in
                    m.top.equalTo(profileLabel.snp.bottom).offset(Constants.NonSticky.JobLabel.topMargin)
                    m.centerX.equalToSuperview()
                })
                
                if user.tags.isEmpty {
                    tagStackView.isHidden = true
                    categoryView.snp.makeConstraints({ m in
                        m.top.equalTo(jobLabel.snp.bottom).offset(Constants.getRelativeHeight(from: 18))
                        m.centerX.equalToSuperview()
                        m.width.equalTo(Constants.CategoryView.width)
                        m.height.equalTo(Constants.CategoryView.height)
                    })
                } else {
                    tagStackView.isHidden = false
                    tagStackView.snp.makeConstraints({ m in
                        m.centerX.equalToSuperview()
                        m.top.equalTo(jobLabel.snp.bottom).offset(8)
                    })
                    
                    categoryView.snp.makeConstraints({ m in
                        m.centerX.equalToSuperview()
                        m.top.equalTo(tagStackView.snp.bottom).offset(12)
                        m.width.equalTo(Constants.CategoryView.width)
                        m.height.equalTo(Constants.CategoryView.height)
                    })
                }
                
                if userState == .me && isInterestsEmpty {
                    followingRecommendLabel.isHidden = true
                    interestRecommendLabel.snp.makeConstraints({ m in
                        m.centerX.equalToSuperview()
                        m.top.equalTo(categoryView.snp.bottom).offset(Constants.NonSticky.InterestRecommendLabel.topMargin)
                        m.bottom.equalToSuperview().inset(Constants.NonSticky.InterestRecommendLabel.bottomMargin)
                    })
                } else if userState == .me && isFollowingsEmpty {
                    interestRecommendLabel.isHidden = true
                    followingRecommendLabel.snp.makeConstraints({ m in
                        m.centerX.equalToSuperview()
                        m.top.equalTo(categoryView.snp.bottom).offset(Constants.NonSticky.FollowingRecommendLabel.topMargin)
                        m.bottom.equalToSuperview().inset(Constants.NonSticky.FollowingRecommendLabel.bottomMargin)
                    })
                } else {
                    interestRecommendLabel.isHidden = true
                    followingRecommendLabel.isHidden = true
                    categoryView.snp.makeConstraints({ m in
                        m.bottom.equalToSuperview().inset(Constants.getRelativeHeight(from: 18))
                    })
                }
            }
        }
    }
    
//    private func addGradient() {
//        self.backgroundColor = .blue
//        let gradientLayer = CAGradientLayer()
//        gradientLayer.frame = self.bounds
//        let colors: [CGColor] = [UIColor.white.withAlphaComponent(0.0).cgColor, UIColor.white.withAlphaComponent(0.7).cgColor]
//        gradientLayer.colors = colors
//
//        gradientLayer.startPoint = CGPoint(x: 0.5, y: Double(91/844))
//        gradientLayer.endPoint = CGPoint(x: 0.5, y: 0.0)
//        gradientLayer.locations = [0.0, 1.0]
//        self.layer.addSublayer(gradientLayer)
//        
//        isGradient = true
//    }
    
    @objc func onTapProfileImage() {
        delegate?.onTapProfileImage()
    }
    
    @objc func onTapProfileLabel() {
        delegate?.onTapProfileLabel()
    }
}


fileprivate final class MyPageTagLabel: UILabel {
    var edgeInset: UIEdgeInsets = .zero
    
    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(width: size.width + edgeInset.left + edgeInset.right, height: size.height + edgeInset.top + edgeInset.bottom)
    }
    
    init(text: String) {
        super.init(frame: .zero)
        setUpView()
        self.text = text
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let radius = min(bounds.width, bounds.height) / 2
        layer.cornerRadius = radius
    }
    
    private func setUpView() {
        backgroundColor = UIColor.Common.main.withAlphaComponent(0.14)
        textColor = UIColor.Common.main
        font = UIFont.systemFont(ofSize: 14, weight: .medium)
        edgeInset = UIEdgeInsets(top: 4, left: 8, bottom: 4, right: 8)
        textAlignment = .center
        clipsToBounds = true
    }
}

protocol MyPageHeaderViewDelegate {
    func onTapLoginButton()
    func onTapProfileImage()
    func onTapProfileLabel()
}
