import UIKit
import SnapKit
import Kingfisher

protocol MyPageHeaderViewDelegate {
    func onTapLoginButton()
    func onTapProfileImage()
    func onTapProfileLabel()
    func onTapCategoryButton(header: MyPageMainHeaderView, selectedCategory: MyPageCategory)
}

final class MyPageMainHeaderView: UICollectionReusableView {
    
    // MARK: - Constants
    private enum Constants {
        static let screenWidth = UIScreen.main.bounds.size.width
        static let screenHeight = UIScreen.main.bounds.size.height
        
        static let profileLabelTextColor = UIColor.Common.black
        
        enum CategoryView {
            static let radius: CGFloat = 12
            
            static let width = 342
            static let height = 44
            
            static let buttonWidth = (342 - 3) / 4
            static let buttonHeight = 44
            
            static let barWidth: CGFloat = 1
            static let barHeight = 16
        }
        
        enum NonSticky {
            static let backgroundHeight: CGFloat = 220
            static let profileFrameDiameter = 108
            static let profileImageDiameter = 100
            static let profileFont = UIFont.systemFont(ofSize: 24, weight: .bold)
            static let profileLabelTopMargin = 8
            static let categoryTopMargin = 18
            
            enum LoginInduceView {
                static let width = 160
                static let height = 120
                static let topMargin: CGFloat = 94
                
                enum Icon {
                    static let image = UIImage(named: "icon_plain_black")
                    static let width: CGFloat = 24
                }
                
                enum Label {
                    static let text = "로그인 후 확인해보세요"
                    static let textColor = UIColor.Common.grey03
                    static let font = UIFont.systemFont(ofSize: 16, weight: .regular)
                    static let topMargin = 8
                }

                enum Button {
                    static let width = 89
                    static let height = 36
                    static let topMargin: CGFloat = 24
                    
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
                static let topMargin = 2
            }
            
            enum EmptyNoticeLabel {
                static let textColor = UIColor.Common.grey03
                static let font = UIFont.systemFont(ofSize: 16, weight: .regular)
                static let topMargin = 26
                static let bottomMargin = 16
                
                static let myInterestEmptyText = "관심중인 작품이 없어요\n지금 바로 관람해 보세요!"
                static let myFollowingEmptyText = "팔로잉한 작가가 없어요\n작가를 추천해 드릴게요!"
                static let myWorkEmptyText = "게시한 작업이 없어요"
                static let myExhibitionEmptyText = "참여한 전시가 없어요"
                static let otherInterestEmptyText = "관심중인 작품이 없어요"
                static let otherFollowingEmptyText = "팔로잉한 작가가 없어요"
                static let otherWorkEmptyText = "게시한 작업이 없어요"
                static let otherExhibitionEmptyText = "참여한 전시가 없어요"
            }
        }
        
        enum Sticky {
            static let backgroundHeight = 201
            static let profileImageDiameter: CGFloat = 32
            static let profileFont = UIFont.systemFont(ofSize: 18, weight: .bold)
            static let profileLabelLeftMargin: CGFloat = 8
            static let profileImageMargin = (top: 103, left: 24)
            static let categoryTopMargin: CGFloat = 16
        }
        
        enum TagStackView {
            static let topMargin = 8
        }
    }
    
    
    // MARK: - Properties
    var delegate: MyPageHeaderViewDelegate?
    
    
    // MARK: - LifeCycle
    override init(frame: CGRect) {
        super.init(frame: .zero)
        backgroundColor = .Common.white
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
        view.layer.cornerRadius = 54
        let gesture = UITapGestureRecognizer(target: self, action: #selector(onTapProfileImage))
        view.addGestureRecognizer(gesture)
        return view
    }()
    
    private lazy var profileImageView: PlainProfileImageView = {
        let imageView = PlainProfileImageView()
        imageView.isUserInteractionEnabled = false
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
        stackView.spacing = 4
        stackView.distribution = .equalSpacing
        return stackView
    }()
    
    let interestButton = MyPageMainCategoryButton(category: .Interest)
    let followingButton = MyPageMainCategoryButton(category: .Following)
    let workButton = MyPageMainCategoryButton(category: .Work)
    let exhibitionButton = MyPageMainCategoryButton(category: .Exhibition)
    
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
            self.delegate?.onTapCategoryButton(header: self, selectedCategory: .Interest)
        }), for: .touchUpInside)
        
        followingButton.addAction(UIAction(handler: { [weak self] _ in
            guard let self else { return }
            self.delegate?.onTapCategoryButton(header: self, selectedCategory: .Following)
        }), for: .touchUpInside)
        
        workButton.addAction(UIAction(handler: { [weak self] _ in
            guard let self else { return }
            self.delegate?.onTapCategoryButton(header: self, selectedCategory: .Work)
        }), for: .touchUpInside)
        
        exhibitionButton.addAction(UIAction(handler: { [weak self] _ in
            guard let self else { return }
            self.delegate?.onTapCategoryButton(header: self, selectedCategory: .Exhibition)
        }), for: .touchUpInside)
        
        view.addSubview(interestButton)
        view.addSubview(followingButton)
        view.addSubview(workButton)
        view.addSubview(exhibitionButton)
        view.addSubview(barView1)
        view.addSubview(barView2)
        view.addSubview(barView3)
        
        workButton.snp.makeConstraints({ m in
            m.width.equalTo(Constants.CategoryView.buttonWidth)
            m.height.equalTo(Constants.CategoryView.buttonHeight)
            m.left.top.equalTo(view)
        })
        barView1.snp.makeConstraints({ m in
            m.width.equalTo(1)
            m.height.equalTo(16)
            m.left.equalToSuperview().inset(85)
            m.centerY.equalTo(view)
        })
        followingButton.snp.makeConstraints({ m in
            m.width.equalTo(Constants.CategoryView.buttonWidth)
            m.height.equalTo(Constants.CategoryView.buttonHeight)
            m.left.equalTo(barView1.snp.right)
            m.top.equalTo(view)
        })
        barView2.snp.makeConstraints({ m in
            m.width.equalTo(1)
            m.height.equalTo(16)
            m.left.equalToSuperview().inset(171)
            m.centerY.equalTo(view)
        })
        interestButton.snp.makeConstraints({ m in
            m.width.equalTo(Constants.CategoryView.buttonWidth)
            m.height.equalTo(Constants.CategoryView.buttonHeight)
            m.top.equalTo(view)
            m.left.equalTo(barView2.snp.right)
        })
        barView3.snp.makeConstraints({ m in
            m.width.equalTo(1)
            m.height.equalTo(16)
            m.left.equalToSuperview().inset(257)
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
    
    private let emptyNoticeLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = Constants.NonSticky.EmptyNoticeLabel.textColor
        label.font = Constants.NonSticky.EmptyNoticeLabel.font
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.sizeToFit()
        return label
    }()
    
    private lazy var loggedOutViews = [backgroundImageView, profileImageView, profileImageFrame, profileLabel, categoryView, loginInduceView]
    private lazy var meAndOtherViews = [backgroundImageView, profileImageFrame, profileImageView, profileLabel, jobLabel, tagStackView, categoryView, divider, emptyNoticeLabel]
    
    func setUpLoggedOutView() {
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
            m.width.height.equalTo(100)
            m.centerY.equalTo(backgroundImageView.snp.bottom)
        })
        
        profileImageFrame.snp.makeConstraints({ m in
            m.centerX.equalToSuperview()
            m.width.height.equalTo(108)
            m.centerY.equalTo(backgroundImageView.snp.bottom)
        })
        
        profileLabel.snp.makeConstraints({ m in
            m.centerX.equalToSuperview()
            m.top.equalTo(profileImageView.snp.bottom).offset(Constants.NonSticky.profileLabelTopMargin)
        })
        
        categoryView.snp.makeConstraints({ m in
            m.top.equalTo(profileLabel.snp.bottom).offset(18)
            m.width.equalTo(Constants.CategoryView.width)
            m.height.equalTo(Constants.CategoryView.height)
            m.centerX.equalToSuperview()
        })
        
        loginInduceView.snp.makeConstraints({ m in
            m.top.equalTo(categoryView.snp.bottom).offset(94)
            m.width.equalTo(Constants.NonSticky.LoginInduceView.width)
            m.height.equalTo(Constants.NonSticky.LoginInduceView.height)
            m.centerX.equalToSuperview()
            m.bottom.equalToSuperview()
        })
    }
    
    func setUpUnStickyHeaderView(user: PlainUser, userState: MyPageUserState, category: MyPageCategory, isContentsEmpty: Bool) {
        meAndOtherViews.forEach {
            if !$0.isDescendant(of: self) { addSubview($0) }
        }
        
        profileImageView.layer.cornerRadius = 100 / 2
        profileLabel.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        
        backgroundImageView.snp.remakeConstraints({ m in
            m.left.top.right.equalToSuperview()
            m.height.equalTo(220).priority(999)
        })
        backgroundImageView.isHidden = false
        
        profileImageFrame.snp.remakeConstraints({ m in
            m.width.height.equalTo(108).priority(999)
            m.centerY.equalTo(backgroundImageView.snp.bottom)
            m.centerX.equalToSuperview()
        })
        profileImageFrame.isHidden = false
        
        profileImageView.snp.remakeConstraints({ m in
            m.width.height.equalTo(100).priority(999)
            m.centerY.equalTo(backgroundImageView.snp.bottom)
            m.centerX.equalToSuperview()
        })
        
        profileLabel.snp.remakeConstraints({ m in
            m.top.equalTo(profileImageView.snp.bottom).offset(8).priority(999)
            m.centerX.equalToSuperview()
            
        })
        
        jobLabel.snp.remakeConstraints({ m in
            m.top.equalTo(profileLabel.snp.bottom).offset(2)
            m.centerX.equalToSuperview()
        })
        jobLabel.isHidden = false
        
        tagStackView.snp.remakeConstraints({ m in
            m.centerX.equalToSuperview()
            m.top.equalTo(jobLabel.snp.bottom).offset(user.tags.isEmpty ? 0 : 8)
        })
        tagStackView.isHidden = false
        
        if !isContentsEmpty {
            categoryView.snp.remakeConstraints({ m in
                m.centerX.equalToSuperview()
                m.top.equalTo(user.tags.isEmpty ? jobLabel.snp.bottom : tagStackView.snp.bottom).offset(18).priority(999)
                m.width.equalTo(342)
                m.height.equalTo(44)
                m.bottom.equalToSuperview().inset(0)
            })
            
            emptyNoticeLabel.snp.remakeConstraints({ m in
                m.height.equalTo(0)
            })
            emptyNoticeLabel.isHidden = true
        } else {
            categoryView.snp.remakeConstraints({ m in
                m.centerX.equalToSuperview()
                m.top.equalTo(user.tags.isEmpty ? jobLabel.snp.bottom : tagStackView.snp.bottom).offset(18).priority(999)
                m.width.equalTo(342)
                m.height.equalTo(44)
            })
            
            emptyNoticeLabel.snp.remakeConstraints({ m in
                m.centerX.equalToSuperview()
                m.top.equalTo(categoryView.snp.bottom).offset(26).priority(999)
                m.bottom.equalToSuperview().inset(0)
            })
            emptyNoticeLabel.isHidden = false
        }
        
        divider.snp.remakeConstraints({ m in
            m.height.equalTo(0)
        })
        divider.isHidden = true
        
    }
    
    func setUpStickyHeaderView(user: PlainUser, userState: MyPageUserState, category: MyPageCategory, isContentsEmpty: Bool) {
        meAndOtherViews.forEach {
            if !$0.isDescendant(of: self) { addSubview($0) }
        }
        
        profileImageView.layer.cornerRadius = 16
        profileLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        
        backgroundImageView.snp.remakeConstraints({ m in
            m.left.top.right.equalToSuperview()
            m.height.equalTo(0).priority(999)
        })
        backgroundImageView.isHidden = true
        
        profileImageFrame.snp.remakeConstraints({ m in
            m.width.height.equalTo(0).priority(999)
        })
        profileImageFrame.isHidden = true
        
        profileImageView.snp.remakeConstraints({ m in
            m.width.height.equalTo(32).priority(999)
            m.left.equalToSuperview().inset(24)
            m.top.equalToSuperview().inset(103)
        })
        
        profileLabel.snp.remakeConstraints({ m in
            m.left.equalTo(profileImageView.snp.right).offset(8).priority(999)
            m.centerY.equalTo(profileImageView)
        })
        
        jobLabel.snp.remakeConstraints({ m in
            m.height.equalTo(0)
        })
        jobLabel.isHidden = true
        
        tagStackView.snp.remakeConstraints({ m in
            m.height.equalTo(0)
        })
        tagStackView.isHidden = true
        
        categoryView.snp.remakeConstraints({ m in
            m.centerX.equalToSuperview()
            m.top.equalToSuperview().inset(151)
            m.width.equalTo(342)
            m.height.equalTo(44)
        })

        divider.snp.remakeConstraints({ m in
            m.left.right.equalToSuperview()
            m.top.equalTo(categoryView.snp.bottom).offset(6).priority(999)
            m.height.equalTo(1).priority(999)
            m.bottom.equalToSuperview()
        })
        divider.isHidden = false
        
        emptyNoticeLabel.snp.remakeConstraints({ m in
            m.height.equalTo(0)
        })
        emptyNoticeLabel.isHidden = true
    }
    
    func setUpViewData(user: PlainUser?, userState: MyPageUserState, category: MyPageCategory, isContentsEmpty: Bool) {
        if userState == .loggedOut {
            backgroundImageView.image = UIImage(named: "default_user_background_image")
            profileImageView.layer.cornerRadius = 50
            profileLabel.font = Constants.NonSticky.profileFont
            profileLabel.text = "게스트"
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
            if user.jobs.isEmpty && userState == .me {
                jobLabel.text = Constants.NonSticky.JobLabel.defaultText
            } else {
                jobLabel.text = user.jobs.joined(separator: ", ")
            }
            
            while let first = tagStackView.arrangedSubviews.first {
                tagStackView.removeArrangedSubview(first)
                first.removeFromSuperview()
            }
            for e in user.tags {
                let label = MyPageTagLabel(text: e)
                tagStackView.addArrangedSubview(label)
            }
            
            switch (userState, category) {
            case (.me, .Interest):
                emptyNoticeLabel.text = Constants.NonSticky.EmptyNoticeLabel.myInterestEmptyText
            case (.me, .Following):
                emptyNoticeLabel.text = Constants.NonSticky.EmptyNoticeLabel.myFollowingEmptyText
            case (.me, .Work):
                emptyNoticeLabel.text = Constants.NonSticky.EmptyNoticeLabel.myWorkEmptyText
            case (.me, .Exhibition):
                emptyNoticeLabel.text = Constants.NonSticky.EmptyNoticeLabel.myExhibitionEmptyText
            case (.other, .Interest):
                emptyNoticeLabel.text = Constants.NonSticky.EmptyNoticeLabel.otherInterestEmptyText
            case (.other, .Following):
                emptyNoticeLabel.text = Constants.NonSticky.EmptyNoticeLabel.otherFollowingEmptyText
            case (.other, .Work):
                emptyNoticeLabel.text = Constants.NonSticky.EmptyNoticeLabel.otherWorkEmptyText
            case (.other, .Exhibition):
                emptyNoticeLabel.text = Constants.NonSticky.EmptyNoticeLabel.otherExhibitionEmptyText
            default: break
            }
            return
        }
    }
    
    func updateHeaderView(user: PlainUser?, userState: MyPageUserState, category: MyPageCategory, isContentsEmpty: Bool, isSticky: Bool) {
        setUpViewData(user: user, userState: userState, category: category, isContentsEmpty: isContentsEmpty)
        switch (userState, isSticky) {
        case (.loggedOut, _):
            setUpLoggedOutView()
        case (_, false):
            guard let user else { return }
            setUpUnStickyHeaderView(user: user, userState: userState, category: category, isContentsEmpty: isContentsEmpty)
        case (_, true):
            guard let user else { return }
            setUpStickyHeaderView(user: user, userState: userState, category: category, isContentsEmpty: isContentsEmpty)
        }
    }
    
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
