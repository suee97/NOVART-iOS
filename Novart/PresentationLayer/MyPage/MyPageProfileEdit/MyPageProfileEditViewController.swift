import UIKit
import SnapKit
import Combine
import Kingfisher
import Lottie

final class MyPageProfileEditViewController: BaseViewController {

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
        
        enum CommonLayout {
            static let horizontalMargin: CGFloat = getRelativeWidth(from: 24)
            static let fieldTopMargin: CGFloat = getRelativeHeight(from: 8)
            static let fieldHeight: CGFloat = getRelativeHeight(from: 49)
        }
        
        enum Navigation {
            static let buttonSize = CGRect(origin: CGPoint.zero, size: CGSize(width: 24, height: 24))
            static let buttonFont = UIFont.systemFont(ofSize: 16, weight: .medium)
            static let titleFont = UIFont.systemFont(ofSize: 16, weight: .bold)
            static let centerTitle: String = "프로필 편집"
            static let applyTitle: String = "완료"
            static let applyActiveColor = UIColor.Common.main
            static let applyInActiveColor = UIColor.Common.grey02
            static let loadingViewSize = CGRect(origin: CGPoint.zero, size: CGSize(width: 24, height: 24))
        }
        
        enum ProfileImage {
            static let title: String = "프로필 사진"
            static let titleTopMargin: CGFloat = getRelativeHeight(from: 16)
            static let imageDiameter: CGFloat = getRelativeWidth(from: 100)
            static let imageSize = CGSize(width: getRelativeWidth(from: 100), height: getRelativeWidth(from: 100))
            static let imageTopMargin: CGFloat = getRelativeHeight(from: 8)
            static let cameraRightMargin: CGFloat = getRelativeWidth(from: 2)
            static let cameraBottomMargin: CGFloat = getRelativeHeight(from: 2)
            static let cameraDiameter: CGFloat = getRelativeWidth(from: 24)
            static let cameraAlpha: CGFloat = 0.5
        }
        
        enum BackgroundImage {
            static let title: String = "배경 사진"
            static let titleLeftMargin: CGFloat = getRelativeWidth(from: 78)
            static let titleTopMargin: CGFloat = getRelativeHeight(from: 16)
            static let imageSize = CGSize(width: getRelativeWidth(from: 178), height: getRelativeHeight(from: 100))
            static let imageLeftMargin: CGFloat = getRelativeWidth(from: 52)
            static let imageTopMargin: CGFloat = getRelativeHeight(from: 8)
            static let imageRadius: CGFloat = 12
            static let cameraOrigin = CGPoint(x: getRelativeWidth(from: 77), y: getRelativeHeight(from: 38))
            static let cameraSize = CGSize(width: getRelativeWidth(from: 24), height: getRelativeWidth(from: 24))
            static let cameraAlpha: CGFloat = 0.5
            static let defaultColor = UIColor.Common.sub
        }
        
        enum Nickname {
            enum Label {
                static let title: String = "닉네임*"
                static let topMargin: CGFloat = getRelativeHeight(from: 32)
            }
            
            enum Field {
                static let placeHolder: String = "활동할 닉네임 입력"
                static let maxCount: Int = 15
                static let width: CGFloat = getRelativeWidth(from: 264)
            }
            
            enum Count {
                static let textColor = UIColor.Common.main
                static let font = UIFont.systemFont(ofSize: 12, weight: .regular)
                static let topMargin: CGFloat = getRelativeHeight(from: 4)
            }
            
            enum DupCheckResultLabel {
                static let possibleTextColor = UIColor.Common.grey04
                static let possibleText = "사용 가능한 닉네임입니다."
                static let impossibleTextColor = UIColor(red: 255/255, green: 62/255, blue: 49/255, alpha: 1)
                static let impossibleText = "이미 존재하는 닉네임입니다."
                
                static let font = UIFont.systemFont(ofSize: 12, weight: .regular)
                static let topMargin: CGFloat = getRelativeHeight(from: 4)
                static let leftMargin: CGFloat = getRelativeWidth(from: 36)
            }
            
            enum DupCheckButton {
                static let title: String = "중복확인"
                static let font = UIFont.systemFont(ofSize: 14, weight: .medium)
                static let activeBackgroundColor = UIColor.Common.main
                static let activeForegroundColor = UIColor.Common.white
                static let inActiveBackgroundColor = UIColor.Common.grey00
                static let inActiveForegroundColor = UIColor.Common.grey01
                
                static let leftMargin: CGFloat = getRelativeWidth(from: 4)
            }
        }
        
        enum Category {
            enum Label {
                static let title: String = "카테고리"
                static let topMargin: CGFloat = getRelativeHeight(from: 32)
            }
            
            enum Count {
                static let font = UIFont.systemFont(ofSize: 12, weight: .regular)
                static let defaultColor = UIColor.Common.grey03
                static let activeColor = UIColor.Common.main
                static let maxCount: Int = 2
            }
            
            enum TagView {
                static let topMargin: CGFloat = getRelativeHeight(from: 8)
                static let height: CGFloat = 116
            }
        }
        
        enum Tag {
            enum Label {
                static let title: String = "태그"
                static let topMargin: CGFloat = getRelativeHeight(from: 32)
            }
            
            enum Field {
                static let placeHolder: String = "모던, 부드러운, 예쁜"
            }
            
            enum Count {
                static let maxCount: Int = 3
                static let font = UIFont.systemFont(ofSize: 12, weight: .regular)
                static let defaultColor = UIColor.Common.grey03
                static let activeColor = UIColor.Common.main
            }
            
            enum Recommend {
                static let title: String = "추천태그"
                static let font = UIFont.systemFont(ofSize: 14, weight: .semibold)
                static let color = UIColor.Common.grey04
                static let topMargin: CGFloat = getRelativeHeight(from: 8)
                static let width: CGFloat = getRelativeWidth(from: 73)
                static let height: CGFloat = getRelativeHeight(from: 24)
                static let upImage = UIImage(named: "icon_chevron_up_v2")
                static let downImage = UIImage(named: "icon_chevron_down_v2")
            }
            
            enum TagView {
                static let topMargin: CGFloat = getRelativeHeight(from: 8)
                static let heigth: CGFloat = 236
            }
        }
        
        enum Email {
            static let title: String = "이메일"
            static let titleTopMargin: CGFloat = getRelativeHeight(from: 32)
            static let placeHolder: String = "소통할 이메일 입력"
            
            enum ValidationLabel {
                static let text = "이메일 형식이 올바르지 않습니다."
                static let font = UIFont.systemFont(ofSize: 12, weight: .regular)
                static let textColor = UIColor.init(hexString: "#FF3E31")
                static let leftMargin: CGFloat = 36
                static let topMargin: CGFloat = 4
            }
        }
        
        enum Link {
            enum Label {
                static let title: String = "링크"
                static let topMargin: CGFloat = getRelativeHeight(from: 32)
            }
            
            enum Field {
                static let placeHolder: String = "소통할 카카오톡 오픈채팅방 입력"
                static let bottomMargin: CGFloat = getRelativeHeight(from: 22)
            }
        }
    }
    
    
    // MARK: - Properties
    private let viewModel: MyPageProfileEditViewModel
    private var cancellables = Set<AnyCancellable>()
    private let profilePicker = UIImagePickerController()
    private let backgroundPicker = UIImagePickerController()
    
    private var isKeyboardShowing = false
    private var recommendExpanded: Bool = false
    private var nicknameDupChecked: Bool = true {
        didSet {
            validateApply(nicknameDupChecked: nicknameDupChecked, emailText: emailField.text)
        }
    }
    
    private lazy var userData = ProfileEditUserDataModel(
        nickname: viewModel.user.nickname, 
        profileFileName: nil,
        profileImage: nil,
        profileImageUrl: viewModel.user.profileImageUrl,
        backgroundFileName: nil,
        backgroundImage: nil,
        backgroundImageUrl: viewModel.user.backgroundImageUrl,
        email: viewModel.user.email,
        link: viewModel.user.openChatUrl
    )
    
    init(viewModel: MyPageProfileEditViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpDelegate()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setUpKeyboardObserver()
        setupNavigationBar()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        removeKeyboardObserver()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupTagViewData()
    }
    
    override func setupBindings() {
        viewModel.$categoryTagItemSelectCount.sink(receiveValue: { value in
            self.categoryCurCountLabel.text = String(value)
            self.categoryCurCountLabel.textColor = value == 0 ? Constants.Category.Count.defaultColor : Constants.Category.Count.activeColor
        }).store(in: &cancellables)
        
        viewModel.$tagFieldString.sink(receiveValue: { value in
            self.tagField.text = value
        }).store(in: &cancellables)
        
        viewModel.$recommendTagItemSelectCount.sink(receiveValue: { value in
            self.tagCurCountLabel.text = String(value)
            self.tagCurCountLabel.textColor = value == 0 ? Constants.Tag.Count.defaultColor : Constants.Tag.Count.activeColor
        }).store(in: &cancellables)
        
        viewModel.$isLoading.sink(receiveValue: { value in
            DispatchQueue.main.async {
                if value {
                    self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: self.loadingView)
                    self.loadingView.play()
                } else {
                    self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: self.applyButton)
                    self.loadingView.pause()
                }
            }
        }).store(in: &cancellables)
    }
    
    
    // MARK: - UI
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.bounces = false
        scrollView.showsVerticalScrollIndicator = false
        let gesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        gesture.cancelsTouchesInView = false
        scrollView.addGestureRecognizer(gesture)
        return scrollView
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        view.isUserInteractionEnabled = true
        return view
    }()
    
    private lazy var cancelButton: UIButton = {
        let button = UIButton(frame: Constants.Navigation.buttonSize)
        button.setImage(UIImage(named: "icon_cancel"), for: .normal)
        button.addAction(UIAction(handler: { [weak self] _ in
            guard let self else { return }
            self.onTapCancel()
        }), for: .touchUpInside)
        return button
    }()
    
    private lazy var applyButton: UIButton = {
        let button = UIButton(frame: Constants.Navigation.buttonSize)
        button.setTitle(Constants.Navigation.applyTitle, for: .normal)
        button.titleLabel?.font = Constants.Navigation.buttonFont
        button.setTitleColor(Constants.Navigation.applyActiveColor, for: .normal)
        button.addAction(UIAction(handler: { [weak self] _ in
            guard let self else { return }
            self.onTapApply()
        }), for: .touchUpInside)
        return button
    }()
    
    private let loadingView: LottieAnimationView = {
        let view = LottieAnimationView(name: "loading_json")
        view.frame = Constants.Navigation.loadingViewSize
        view.loopMode = .loop
        view.pause()
        return view
    }()
    
    private let profileImageLabel = ProfileEditLabel(title: Constants.ProfileImage.title)
    private let backgroundImageLabel = ProfileEditLabel(title: Constants.BackgroundImage.title)
    private let nicknameLabel = ProfileEditLabel(title: Constants.Nickname.Label.title)
    private let categoryLabel = ProfileEditLabel(title: Constants.Category.Label.title)
    private let tagLabel = ProfileEditLabel(title: Constants.Tag.Label.title)
    private let emailLabel = ProfileEditLabel(title: Constants.Email.title)
    private let linkLabel = ProfileEditLabel(title: Constants.Link.Label.title)
    
    private lazy var nicknameField: ProfileEditTextField = {
        let textField = ProfileEditTextField(placeholder: Constants.Nickname.Field.placeHolder)
        textField.text = viewModel.user.nickname
        textField.addTarget(self, action: #selector(textFieldDidchanged(_:)), for: .editingChanged)
        return textField
    }()
    
    private lazy var tagField: ProfileEditTextField = {
        let textField = ProfileEditTextField(placeholder: Constants.Tag.Field.placeHolder)
        textField.addTarget(self, action: #selector(textFieldDidchanged(_:)), for: .editingChanged)
        return textField
    }()
    
    private lazy var emailField: ProfileEditTextField = {
        let textField = ProfileEditTextField(placeholder: Constants.Email.placeHolder)
        textField.text = viewModel.user.email
        textField.addTarget(self, action: #selector(textFieldDidchanged(_:)), for: .editingChanged)
        return textField
    }()
    
    private let emailValidationLabel: UILabel = {
        let label = UILabel()
        label.text = Constants.Email.ValidationLabel.text
        label.textColor = Constants.Email.ValidationLabel.textColor
        label.font = Constants.Email.ValidationLabel.font
        label.isHidden = true
        return label
    }()
    
    private lazy var linkField: ProfileEditTextField = {
        let textField = ProfileEditTextField(placeholder: Constants.Link.Field.placeHolder)
        textField.text = viewModel.user.openChatUrl
        textField.addTarget(self, action: #selector(textFieldDidchanged(_:)), for: .editingChanged)
        return textField
    }()
    
    private let profileCameraView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "icon_camera")
        imageView.alpha = Constants.ProfileImage.cameraAlpha
        return imageView
    }()
    
    private lazy var profileImageView: UIImageView = {
        let profileImageView = UIImageView(frame: CGRect(origin: CGPoint.zero, size: Constants.ProfileImage.imageSize))
        profileImageView.layer.cornerRadius = Constants.ProfileImage.imageDiameter / 2
        profileImageView.clipsToBounds = true
        profileImageView.isUserInteractionEnabled = true
        profileImageView.contentMode = .scaleAspectFill
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(onTapProfileImage))
        profileImageView.addGestureRecognizer(gesture)
        
        guard let urlString = viewModel.user.profileImageUrl, let url = URL(string: urlString) else {
            profileImageView.image = UIImage(named: "default_user_profile_image")
            return profileImageView
        }
        
        profileImageView.kf.setImage(with: url)
        return profileImageView
    }()
    
    private lazy var backgroundImageView: UIImageView = {
        let backgroundImageView = UIImageView(frame: CGRect(origin: CGPoint.zero, size: Constants.BackgroundImage.imageSize))
        backgroundImageView.layer.cornerRadius = Constants.BackgroundImage.imageRadius
        backgroundImageView.clipsToBounds = true
        backgroundImageView.isUserInteractionEnabled = true
        backgroundImageView.contentMode = .scaleAspectFill
        
        let cameraImageView = UIImageView(frame: CGRect(origin: Constants.BackgroundImage.cameraOrigin, size: Constants.BackgroundImage.cameraSize))
        cameraImageView.image = UIImage(named: "icon_camera")
        cameraImageView.alpha = Constants.BackgroundImage.cameraAlpha
        
        backgroundImageView.addSubview(cameraImageView)
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(onTapBackgroundImage))
        backgroundImageView.addGestureRecognizer(gesture)
        
        guard let urlString = viewModel.user.backgroundImageUrl, let url = URL(string: urlString) else {
            backgroundImageView.image = nil
            backgroundImageView.backgroundColor = Constants.BackgroundImage.defaultColor
            return backgroundImageView
        }
        
        backgroundImageView.kf.setImage(with: url)
        
        return backgroundImageView
    }()
    
    private let nicknameMaxCountLabel: UILabel = {
        let label = UILabel()
        label.font = Constants.Nickname.Count.font
        label.textColor = .Common.grey03
        label.text = "/\(Constants.Nickname.Field.maxCount)자"
        return label
    }()
    
    private lazy var nicknameCurCountLabel: UILabel = {
        let label = UILabel()
        let string = nicknameField.text ?? ""
        let length = string.count
        
        label.font = Constants.Nickname.Count.font
        label.text = String(length)
        label.textColor = Constants.Nickname.Count.textColor
        return label
    }()
    
    private let nicknameDupCheckResultLabel: UILabel = {
        let label = UILabel()
        label.font = Constants.Nickname.DupCheckResultLabel.font
        return label
    }()
    
    private lazy var nicknameDupCheckButton: PlainButton = {
        let button = PlainButton()
        button.setTitle(Constants.Nickname.DupCheckButton.title, for: .normal)
        button.titleLabel?.font = Constants.Nickname.DupCheckButton.font
        button.backgroundColor = Constants.Nickname.DupCheckButton.inActiveBackgroundColor
        button.setTitleColor(Constants.Nickname.DupCheckButton.inActiveForegroundColor, for: .normal)
        button.isEnabled = false
        button.addAction(UIAction(handler: { [weak self] _ in
            guard let self else { return }
            self.onTapNicknameDupCheckButton()
        }), for: .touchUpInside)
        return button
    }()
    
    private lazy var categoryTagView = TagView()
    
    private let categoryMaxCountLabel: UILabel = {
        let label = UILabel()
        label.font = Constants.Category.Count.font
        label.textColor = Constants.Category.Count.defaultColor
        label.text = "/\(Constants.Category.Count.maxCount)"
        return label
    }()
    
    private let categoryCurCountLabel: UILabel = {
        let label = UILabel()
        label.font = Constants.Category.Count.font
        label.textColor = Constants.Category.Count.defaultColor
        return label
    }()
    
    private let tagMaxCountLabel: UILabel = {
        let label = UILabel()
        label.font = Constants.Tag.Count.font
        label.textColor = Constants.Tag.Count.defaultColor
        label.text = "/\(Constants.Tag.Count.maxCount)"
        return label
    }()
    
    private let tagCurCountLabel: UILabel = {
        let label = UILabel()
        label.font = Constants.Tag.Count.font
        label.textColor = Constants.Tag.Count.defaultColor
        return label
    }()
    
    private let recommendButtonImageView: UIImageView = {
        let imageView = UIImageView(image: Constants.Tag.Recommend.downImage)
        return imageView
    }()
    
    private lazy var recommendButton: UIView = {
        let view = UIView()
        let label = UILabel()
        
        label.text = Constants.Tag.Recommend.title
        label.textColor = Constants.Tag.Recommend.color
        label.font = Constants.Tag.Recommend.font
        
        view.addSubview(label)
        view.addSubview(recommendButtonImageView)
        label.snp.makeConstraints({ m in
            m.left.top.bottom.equalToSuperview()
        })
        recommendButtonImageView.snp.makeConstraints({ m in
            m.left.equalTo(label.snp.right)
            m.top.bottom.right.equalToSuperview()
        })
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(onTapTagRecommendButton))
        view.addGestureRecognizer(gesture)
        
        return view
    }()
    
    private lazy var recommendTagView = TagView()
    
    override func setupView() {
        view.backgroundColor = .Common.white
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(profileImageLabel)
        contentView.addSubview(profileImageView)
        contentView.addSubview(profileCameraView)
        contentView.addSubview(backgroundImageLabel)
        contentView.addSubview(backgroundImageView)
        contentView.addSubview(nicknameLabel)
        contentView.addSubview(nicknameMaxCountLabel)
        contentView.addSubview(nicknameCurCountLabel)
        contentView.addSubview(nicknameField)
        contentView.addSubview(nicknameDupCheckResultLabel)
        contentView.addSubview(nicknameDupCheckButton)
        contentView.addSubview(categoryLabel)
        contentView.addSubview(categoryMaxCountLabel)
        contentView.addSubview(categoryCurCountLabel)
        contentView.addSubview(categoryTagView)
        contentView.addSubview(tagLabel)
        contentView.addSubview(tagMaxCountLabel)
        contentView.addSubview(tagCurCountLabel)
        contentView.addSubview(tagField)
        contentView.addSubview(recommendButton)
        contentView.addSubview(recommendTagView)
        contentView.addSubview(emailLabel)
        contentView.addSubview(emailField)
        contentView.addSubview(emailValidationLabel)
        contentView.addSubview(linkLabel)
        contentView.addSubview(linkField)
        
        scrollView.snp.makeConstraints({ m in
            m.edges.equalTo(view.safeAreaLayoutGuide)
        })
        
        contentView.snp.makeConstraints({ m in
            m.top.bottom.width.equalToSuperview()
        })
        
        profileImageLabel.snp.makeConstraints({ m in
            m.left.equalToSuperview().inset(Constants.CommonLayout.horizontalMargin)
            m.top.equalToSuperview().inset(Constants.ProfileImage.titleTopMargin)
        })
        
        profileImageView.snp.makeConstraints({ m in
            m.left.equalToSuperview().inset(Constants.CommonLayout.horizontalMargin)
            m.top.equalTo(profileImageLabel.snp.bottom).offset(Constants.ProfileImage.imageTopMargin)
            m.width.height.equalTo(Constants.ProfileImage.imageDiameter)
        })
        
        profileCameraView.snp.makeConstraints({ m in
            m.width.equalTo(Constants.ProfileImage.cameraDiameter)
            m.height.equalTo(Constants.ProfileImage.cameraDiameter)
            m.right.equalTo(profileImageView.snp.right).inset(Constants.ProfileImage.cameraRightMargin)
            m.bottom.equalTo(profileImageView.snp.bottom).inset(Constants.ProfileImage.cameraBottomMargin)
        })
        
        backgroundImageLabel.snp.makeConstraints({ m in
            m.left.equalTo(profileImageLabel.snp.right).offset(Constants.BackgroundImage.titleLeftMargin)
            m.top.equalToSuperview().inset(Constants.BackgroundImage.titleTopMargin)
        })
        
        backgroundImageView.snp.makeConstraints({ m in
            m.left.equalTo(profileImageView.snp.right).offset(Constants.BackgroundImage.imageLeftMargin)
            m.top.equalTo(backgroundImageLabel.snp.bottom).offset(Constants.BackgroundImage.imageTopMargin)
            m.width.equalTo(Constants.BackgroundImage.imageSize.width)
            m.height.equalTo(Constants.BackgroundImage.imageSize.height)
        })
        
        nicknameLabel.snp.makeConstraints({ m in
            m.left.equalToSuperview().inset(Constants.CommonLayout.horizontalMargin)
            m.top.equalTo(profileImageView.snp.bottom).offset(Constants.Nickname.Label.topMargin)
        })
        
        nicknameField.snp.makeConstraints({ m in
            m.left.equalToSuperview().inset(Constants.CommonLayout.horizontalMargin)
            m.top.equalTo(nicknameLabel.snp.bottom).offset(Constants.CommonLayout.fieldTopMargin)
            m.height.equalTo(Constants.CommonLayout.fieldHeight)
            m.width.equalTo(Constants.Nickname.Field.width)
        })
        
        nicknameMaxCountLabel.snp.makeConstraints({ m in
            m.right.equalTo(nicknameField.snp.right)
            m.top.equalTo(nicknameField.snp.bottom).offset(Constants.Nickname.Count.topMargin)
        })
        
        nicknameCurCountLabel.snp.makeConstraints({ m in
            m.centerY.equalTo(nicknameMaxCountLabel)
            m.right.equalTo(nicknameMaxCountLabel.snp.left)
        })
        
        nicknameDupCheckResultLabel.snp.makeConstraints({ m in
            m.left.equalToSuperview().inset(Constants.Nickname.DupCheckResultLabel.leftMargin)
            m.top.equalTo(nicknameField.snp.bottom).offset(Constants.Nickname.DupCheckResultLabel.topMargin)
        })
        
        nicknameDupCheckButton.snp.makeConstraints({ m in
            m.left.equalTo(nicknameField.snp.right).offset(Constants.Nickname.DupCheckButton.leftMargin)
            m.right.equalToSuperview().inset(Constants.CommonLayout.horizontalMargin)
            m.height.centerY.equalTo(nicknameField)
        })
        
        categoryLabel.snp.makeConstraints({ m in
            m.left.equalToSuperview().inset(Constants.CommonLayout.horizontalMargin)
            m.top.equalTo(nicknameMaxCountLabel.snp.bottom).offset(Constants.Category.Label.topMargin)
        })
        
        categoryMaxCountLabel.snp.makeConstraints({ m in
            m.right.equalToSuperview().inset(Constants.CommonLayout.horizontalMargin)
            m.centerY.equalTo(categoryLabel)
        })
        
        categoryCurCountLabel.snp.makeConstraints({ m in
            m.right.equalTo(categoryMaxCountLabel.snp.left)
            m.centerY.equalTo(categoryLabel)
        })
        
        categoryTagView.snp.makeConstraints { m in
            m.top.equalTo(categoryLabel.snp.bottom).offset(Constants.Category.TagView.topMargin)
            m.left.right.equalToSuperview().inset(Constants.CommonLayout.horizontalMargin)
            m.height.equalTo(Constants.Category.TagView.height)
        }
        
        tagLabel.snp.makeConstraints({ m in
            m.left.equalToSuperview().inset(Constants.CommonLayout.horizontalMargin)
            m.top.equalTo(categoryTagView.snp.bottom).offset(Constants.Tag.Label.topMargin)
        })
        
        tagMaxCountLabel.snp.makeConstraints({ m in
            m.right.equalToSuperview().inset(Constants.CommonLayout.horizontalMargin)
            m.centerY.equalTo(tagLabel)
        })
        
        tagCurCountLabel.snp.makeConstraints({ m in
            m.right.equalTo(tagMaxCountLabel.snp.left)
            m.centerY.equalTo(tagLabel)
        })
        
        tagField.snp.makeConstraints({ m in
            m.left.right.equalToSuperview().inset(Constants.CommonLayout.horizontalMargin)
            m.top.equalTo(tagLabel.snp.bottom).offset(Constants.CommonLayout.fieldTopMargin)
            m.height.equalTo(Constants.CommonLayout.fieldHeight)
        })
        
        recommendButton.snp.makeConstraints({ m in
            m.top.equalTo(tagField.snp.bottom).offset(Constants.Tag.Recommend.topMargin)
            m.right.equalTo(tagField)
            m.width.equalTo(Constants.Tag.Recommend.width)
            m.height.equalTo(Constants.Tag.Recommend.height)
        })
        
        recommendTagView.snp.makeConstraints({ m in
            m.top.equalTo(recommendButton.snp.bottom).offset(Constants.Tag.TagView.topMargin)
            m.left.right.equalToSuperview().inset(Constants.CommonLayout.horizontalMargin)
            m.height.equalTo(0)
        })
        
        emailLabel.snp.makeConstraints({ m in
            m.left.equalToSuperview().inset(Constants.CommonLayout.horizontalMargin)
            m.top.equalTo(recommendTagView.snp.bottom).offset(Constants.Email.titleTopMargin)
        })
        
        emailField.snp.makeConstraints({ m in
            m.left.right.equalToSuperview().inset(Constants.CommonLayout.horizontalMargin)
            m.top.equalTo(emailLabel.snp.bottom).offset(Constants.CommonLayout.fieldTopMargin)
            m.height.equalTo(Constants.CommonLayout.fieldHeight)
        })
        
        emailValidationLabel.snp.makeConstraints({ m in
            m.left.equalToSuperview().inset(Constants.Email.ValidationLabel.leftMargin)
            m.top.equalTo(emailField.snp.bottom).offset(Constants.Email.ValidationLabel.topMargin)
        })
        
        linkLabel.snp.makeConstraints({ m in
            m.left.equalToSuperview().inset(Constants.CommonLayout.horizontalMargin)
            m.top.equalTo(emailField.snp.bottom).offset(Constants.Link.Label.topMargin)
        })
        
        linkField.snp.makeConstraints({ m in
            m.left.right.equalToSuperview().inset(Constants.CommonLayout.horizontalMargin)
            m.top.equalTo(linkLabel.snp.bottom).offset(Constants.CommonLayout.fieldTopMargin)
            m.height.equalTo(Constants.CommonLayout.fieldHeight)
            m.bottom.equalTo(contentView).offset(-Constants.Link.Field.bottomMargin)
        })
    }
    
    
    // MARK: - Functions
    private func setUpDelegate() {
        nicknameField.delegate = self
        tagField.delegate = self
        emailField.delegate = self
        linkField.delegate = self
        profilePicker.delegate = self
        backgroundPicker.delegate = self
        categoryTagView.delegate = self
        recommendTagView.delegate = self
    }
    
    private func setupTagViewData() {
        categoryTagView.applyItems(viewModel.categoryTagItems)
        recommendTagView.applyItems(viewModel.recommendTagItems)
    }
    
    override func setupNavigationBar() {
        navigationItem.title = Constants.Navigation.centerTitle
        navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.font: Constants.Navigation.titleFont
        ]
        let cancelItem = UIBarButtonItem(customView: cancelButton)
        let applyItem = UIBarButtonItem(customView: applyButton)
        self.navigationItem.leftBarButtonItem = cancelItem
        self.navigationItem.rightBarButtonItem = applyItem
    }
    
    private func onTapCancel() {
        viewModel.showMain()
    }
    
    private func onTapApply() {
        viewModel.applyChanges(userData: userData)
    }
    
    @objc private func onTapProfileImage() {
        openLibrary(.profile)
    }
    
    @objc private func onTapBackgroundImage() {
        openLibrary(.background)
    }
    
    private func onTapNicknameDupCheckButton() {
        guard let nickname = nicknameField.text else { return }
        Task {
            let response = try await self.viewModel.checkDuplicateNickname(nickname: nickname)
            nicknameDupChecked = !response
            if response {
                self.nicknameDupCheckResultLabel.text = Constants.Nickname.DupCheckResultLabel.impossibleText
                self.nicknameDupCheckResultLabel.textColor = Constants.Nickname.DupCheckResultLabel.impossibleTextColor
            } else {
                self.nicknameDupCheckResultLabel.text = Constants.Nickname.DupCheckResultLabel.possibleText
                self.nicknameDupCheckResultLabel.textColor = Constants.Nickname.DupCheckResultLabel.possibleTextColor
            }
        }
    }
    
    @objc private func onTapTagRecommendButton() {
        if recommendExpanded {
            recommendButtonImageView.image = Constants.Tag.Recommend.downImage
            recommendTagView.snp.updateConstraints({ m in
                m.height.equalTo(0)
            })
            recommendTagView.updateConstraints()
            recommendExpanded = false
        } else {
            recommendButtonImageView.image = Constants.Tag.Recommend.upImage
            recommendTagView.snp.updateConstraints({ m in
                m.height.equalTo(Constants.Tag.TagView.heigth)
            })
            recommendTagView.updateConstraints()
            recommendExpanded = true
        }
    }
    
    private func openLibrary(_ type: PickerType) {
        switch type {
        case .profile:
            profilePicker.sourceType = .photoLibrary
            present(profilePicker, animated: true)
        case.background:
            backgroundPicker.sourceType = .photoLibrary
            present(backgroundPicker, animated: true)
        }
    }
    
    private func validateApply(nicknameDupChecked: Bool, emailText: String?) {
        guard let emailText else { return }
        if nicknameDupChecked && viewModel.validateEmail(text: emailText) {
            applyButton.setTitleColor(Constants.Navigation.applyActiveColor, for: .normal)
            applyButton.isEnabled = true
        } else {
            applyButton.setTitleColor(Constants.Navigation.applyInActiveColor, for: .normal)
            applyButton.isEnabled = false
        }
    }
}


// MARK: - TextField
extension MyPageProfileEditViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField == nicknameField {
            
            let currentString = (textField.text ?? "") as NSString
            let length = currentString.replacingCharacters(in: range, with: string).count
            nicknameCurCountLabel.text = String(length)
            
            let inValidString = CharacterSet(charactersIn: "!@#$%^&*()_+{}[]|\"<>,.~`/:;?-=\\¥'£•¢")
            
            if textField.textInputMode?.primaryLanguage == "emoji" || textField.textInputMode?.primaryLanguage == nil {
                return false
            }
            if let _ = string.rangeOfCharacter(from: inValidString) {
                return false
            }
            
            return length <= Constants.Nickname.Field.maxCount - 1
        }
        
        if textField == tagField && viewModel.recommendTagItemSelectCount == Constants.Tag.Count.maxCount {
            if string == "," {
                return false
            }
        }

        return true
    }
    
    @objc private func textFieldDidchanged(_ textField: UITextField) {
        switch textField {
        case nicknameField:
            nicknameDupCheckResultLabel.text = ""
            nicknameDupChecked = false
            guard let text = nicknameField.text else { return }
            userData.nickname = text
            if text.count == 0 || text == viewModel.user.nickname || text.trimmingCharacters(in: [" "]) == "" {
                nicknameDupCheckButton.setTitleColor(Constants.Nickname.DupCheckButton.inActiveForegroundColor, for: .normal)
                nicknameDupCheckButton.backgroundColor = Constants.Nickname.DupCheckButton.inActiveBackgroundColor
                nicknameDupCheckButton.isEnabled = false
            } else {
                nicknameDupCheckButton.setTitleColor(Constants.Nickname.DupCheckButton.activeForegroundColor, for: .normal)
                nicknameDupCheckButton.backgroundColor = Constants.Nickname.DupCheckButton.activeBackgroundColor
                nicknameDupCheckButton.isEnabled = true
            }
        case tagField:
            viewModel.tagFieldString = textField.text ?? ""
            viewModel.tagFieldChangedFromUser()
            recommendTagView.applyItems(viewModel.recommendTagItems)
        case emailField:
            guard let text = emailField.text else { return }
            validateApply(nicknameDupChecked: nicknameDupChecked, emailText: text)
            let validationResult: Bool = viewModel.validateEmail(text: text)
            emailValidationLabel.isHidden = validationResult
            if validationResult { userData.email = text }
        case linkField:
            guard let text = linkField.text else { return }
            userData.link = text
        default:
            break
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        hideKeyboard()
        return true
    }
}


// MARK: - Keyboard
extension MyPageProfileEditViewController {
    private func setUpKeyboardObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func removeKeyboardObserver() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        if isKeyboardShowing || nicknameField.isFirstResponder { return }
        
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue, let tabBarHeight = self.tabBarController?.tabBar.frame.height {
            UIView.animate(withDuration: 0.3) {
                let contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height - tabBarHeight, right: 0)
                self.scrollView.contentInset = contentInset
                self.scrollView.scrollIndicatorInsets = contentInset
                
                let currentOffset = self.scrollView.contentOffset
                let newOffset = CGPoint(x: currentOffset.x, y: currentOffset.y + keyboardSize.height - tabBarHeight)
                self.scrollView.setContentOffset(newOffset, animated: true)
            }
            isKeyboardShowing = true
        }
    }
    
    @objc private func keyboardWillHide(_ notification: Notification) {
        UIView.animate(withDuration: 0.3) {
            self.scrollView.contentInset = .zero
            self.scrollView.scrollIndicatorInsets = .zero
            self.isKeyboardShowing = false
        }
    }
    
    @objc private func hideKeyboard() {
        view.endEditing(true)
    }
}


// MARK: - TagView
extension MyPageProfileEditViewController: TagViewDelegate {
    func tagView(_ tagView: TagView, didSelectItemAt indexPath: IndexPath) {
        if tagView == categoryTagView {
            if viewModel.categoryTagItemSelectCount < Constants.Category.Count.maxCount {
                viewModel.updateCategoryTagSelection(indexPath: indexPath, isSelected: true)
            } else {
                tagView.applyItems(viewModel.categoryTagItems)
            }
            return
        }
        
        if tagView == recommendTagView {
            if viewModel.recommendTagItemSelectCount < Constants.Tag.Count.maxCount {
                viewModel.updateRecommendTagSelection(indexPath: indexPath, isSelected: true)
            } else {
                tagView.applyItems(viewModel.recommendTagItems)
            }
            return
        }
    }
    
    func tagView(_ tagView: TagView, didDeselectItemAt indexPath: IndexPath) {
        if tagView == categoryTagView {
            viewModel.updateCategoryTagSelection(indexPath: indexPath, isSelected: false)
            return
        }
        
        if tagView == recommendTagView {
            viewModel.updateRecommendTagSelection(indexPath: indexPath, isSelected: false)
            return
        }
    }
    
    func invalidateLayout(_ contentHeight: CGFloat) {}
}


// MARK: - ImagePicker Delegate
extension MyPageProfileEditViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
        guard let url = info[UIImagePickerController.InfoKey.imageURL] as? URL else { return }
        
        if picker == profilePicker {
            if let fileName = url.absoluteString.split(separator: "/").last {
                userData.profileFileName = String(fileName)
            }
            profileImageView.image = image
            userData.profileImage = image
        }
        
        if picker == backgroundPicker {
            if let fileName = url.absoluteString.split(separator: "/").last {
                userData.backgroundFileName = String(fileName)
            }
            backgroundImageView.image = image
            userData.backgroundImage = image
        }
        
        dismiss(animated: true)
    }
}

fileprivate enum PickerType {
    case profile
    case background
}

fileprivate class ProfileEditLabel: UILabel {
    init(title: String) {
        super.init(frame: .zero)
        self.text = title
        setUpView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpView() {
        self.textColor = .Common.grey03
        self.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
    }
}
