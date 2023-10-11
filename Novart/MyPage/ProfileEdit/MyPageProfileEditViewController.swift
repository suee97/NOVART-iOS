import UIKit
import SnapKit

final class MyPageProfileEditViewController: BaseViewController {

    // MARK: - Constants
    private enum Constants {
        enum CommonLayout {
            static let horizontalMargin: CGFloat = 24
            static let fieldTopMargin: CGFloat = 8
            static let fieldHeight: CGFloat = 49
        }
        
        enum Navigation {
            static let centerTitle: String = "프로필 편집"
            static let cancelTitle: String = "취소"
            static let applyTitle: String = "저장"
            static let buttonSize = CGRect(origin: CGPoint.zero, size: CGSize(width: 28, height: 24))
            static let font = UIFont(name: "Apple SD Gothic Neo Regular", size: 16)
        }
        
        enum ProfileImage {
            static let title: String = "프로필 사진"
            static let titleTopMargin: CGFloat = 16
            static let imageDiameter: CGFloat = 100
            static let imageSize = CGSize(width: 100, height: 100)
            static let imageTopMargin: CGFloat = 8
            static let cameraOrigin = CGPoint(x: 74, y: 74)
            static let cameraSize = CGSize(width: 24, height: 24)
        }
        
        enum BackgroundImage {
            static let title: String = "배경 사진"
            static let titleLeftMargin: CGFloat = 78
            static let titleTopMargin: CGFloat = 16
            static let imageSize = CGSize(width: 178, height: 100)
            static let imageLeftMargin: CGFloat = 52
            static let imageTopMargin: CGFloat = 8
            static let imageRadius: CGFloat = 12
            static let cameraOrigin = CGPoint(x: 77, y: 38)
            static let cameraSize = CGSize(width: 24, height: 24)
        }
        
        enum Nickname {
            static let title: String = "닉네임"
            static let titleTopMargin: CGFloat = 32
            static let placeHolder: String = "활동할 닉네임 입력"
            static let maxLength: Int = 15
            static let countFont = UIFont(name: "Apple SD Gothic Neo Regular", size: 12)
        }
        
        enum Category {
            static let title: String = "카테고리"
            static let titleTopMargin: CGFloat = 32
        }
        
        enum Tag {
            static let title: String = "태그"
        }
        
        enum Email {
            static let title: String = "이메일"
            static let titleTopMargin: CGFloat = 32
            static let placeHolder: String = "소통할 이메일 입력"
        }
        
        enum Link {
            static let title: String = "링크"
            static let titleTopMargin: CGFloat = 32
            static let placeHolder: String = "소통할 카카오톡 오픈채팅방 입력"
        }
    }
    
    
    // MARK: - Properties
    private let viewModel: MyPageProfileEditViewModel
    
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
        nicknameField.delegate = self
    }
    
    deinit {
        print("MyPageProfileEditViewController deinit()")
    }
    
    
    // MARK: - UI
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.bounces = false
        return scrollView
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        view.isUserInteractionEnabled = true
        return view
    }()
    
    private let profileImageLabel = ProfileEditLabel(title: Constants.ProfileImage.title)
    private let backgroundImageLabel = ProfileEditLabel(title: Constants.BackgroundImage.title)
    private let nicknameLabel = ProfileEditLabel(title: Constants.Nickname.title)
    private let categoryLabel = ProfileEditLabel(title: Constants.Category.title)
    private let tagLabel = ProfileEditLabel(title: Constants.Tag.title)
    private let emailLabel = ProfileEditLabel(title: Constants.Email.title)
    private let linkLabel = ProfileEditLabel(title: Constants.Link.title)
    
    private lazy var profileImageView: UIView = {
        let view = UIView()
        
        let profileImageView = UIImageView(frame: CGRect(origin: CGPoint.zero, size: Constants.ProfileImage.imageSize))
        profileImageView.image = UIImage(named: "default_user_profile_image")

        let cameraImageView = UIImageView(frame: CGRect(origin: Constants.ProfileImage.cameraOrigin, size: Constants.ProfileImage.cameraSize))
        cameraImageView.image = UIImage(named: "icon_camera")
        
        view.addSubview(profileImageView)
        view.addSubview(cameraImageView)
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(onTapProfileImage))
        view.addGestureRecognizer(gesture)
        
        return view
    }()
    
    private lazy var backgroundImageView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = Constants.BackgroundImage.imageRadius
        view.clipsToBounds = true
        
        let backgroundImageView = UIImageView(frame: CGRect(origin: CGPoint.zero, size: Constants.BackgroundImage.imageSize))
        backgroundImageView.image = UIImage(named: "default_user_background_image")

        let cameraImageView = UIImageView(frame: CGRect(origin: Constants.BackgroundImage.cameraOrigin, size: Constants.BackgroundImage.cameraSize))
        cameraImageView.image = UIImage(named: "icon_camera")
        
        view.addSubview(backgroundImageView)
        view.addSubview(cameraImageView)
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(onTapBackgroundImage))
        view.addGestureRecognizer(gesture)
        
        return view
    }()
    
    private lazy var nicknameCountLabel: UILabel = {
        let label = UILabel()
        label.font = Constants.Nickname.countFont
        label.textColor = .Common.grey03
        
        let string = nicknameField.text ?? ""
        label.text = "\(string.count)/\(Constants.Nickname.maxLength)자"
        return label
    }()
    
    private let nicknameField = ProfileEditTextField(placeholder: Constants.Nickname.placeHolder)
    private let emailField = ProfileEditTextField(placeholder: Constants.Email.placeHolder)
    private let linkField = ProfileEditTextField(placeholder: Constants.Link.placeHolder)

    override func setupView() {
        view.backgroundColor = .Common.white
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(profileImageLabel)
        contentView.addSubview(profileImageView)
        contentView.addSubview(backgroundImageLabel)
        contentView.addSubview(backgroundImageView)
        contentView.addSubview(nicknameLabel)
        contentView.addSubview(nicknameCountLabel)
        contentView.addSubview(nicknameField)
        contentView.addSubview(emailLabel)
        contentView.addSubview(emailField)
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
            m.top.equalTo(profileImageView.snp.bottom).offset(Constants.Nickname.titleTopMargin)
        })
        
        nicknameCountLabel.snp.makeConstraints({ m in
            m.right.equalToSuperview().inset(Constants.CommonLayout.horizontalMargin)
            m.centerY.equalTo(nicknameLabel)
        })
        
        nicknameField.snp.makeConstraints({ m in
            m.left.right.equalToSuperview().inset(Constants.CommonLayout.horizontalMargin)
            m.top.equalTo(nicknameLabel.snp.bottom).offset(Constants.CommonLayout.fieldTopMargin)
            m.height.equalTo(Constants.CommonLayout.fieldHeight)
        })
        
        emailLabel.snp.makeConstraints({ m in
            m.left.equalToSuperview().inset(Constants.CommonLayout.horizontalMargin)
            m.top.equalTo(nicknameField.snp.bottom).offset(Constants.Email.titleTopMargin) // 임시
        })
        
        emailField.snp.makeConstraints({ m in
            m.left.right.equalToSuperview().inset(Constants.CommonLayout.horizontalMargin)
            m.top.equalTo(emailLabel.snp.bottom).offset(Constants.CommonLayout.fieldTopMargin)
            m.height.equalTo(Constants.CommonLayout.fieldHeight)
        })
        
        linkLabel.snp.makeConstraints({ m in
            m.left.equalToSuperview().inset(Constants.CommonLayout.horizontalMargin)
            m.top.equalTo(emailField.snp.bottom).offset(Constants.Link.titleTopMargin)
        })
        
        linkField.snp.makeConstraints({ m in
            m.left.right.equalToSuperview().inset(Constants.CommonLayout.horizontalMargin)
            m.top.equalTo(linkLabel.snp.bottom).offset(Constants.CommonLayout.fieldTopMargin)
            m.height.equalTo(Constants.CommonLayout.fieldHeight)
            m.bottom.equalTo(contentView)
        })
    }
    
    private lazy var cancelButton: UIButton = {
        let button = UIButton(frame: Constants.Navigation.buttonSize)
        button.setTitle(Constants.Navigation.cancelTitle, for: .normal)
        button.titleLabel?.font = Constants.Navigation.font
        button.setTitleColor(.Common.grey03, for: .normal)
        button.addAction(UIAction(handler: { [weak self] _ in
            guard let self else { return }
            self.onTapCancel()
        }), for: .touchUpInside)
        return button
    }()
    
    private lazy var applyButton: UIButton = {
        let button = UIButton(frame: Constants.Navigation.buttonSize)
        button.setTitle(Constants.Navigation.applyTitle, for: .normal)
        button.titleLabel?.font = Constants.Navigation.font
        button.setTitleColor(.Common.grey02, for: .normal)
        button.addAction(UIAction(handler: { [weak self] _ in
            guard let self else { return }
            self.onTapApply()
        }), for: .touchUpInside)
        return button
    }()
    
    override func setupNavigationBar() {
        navigationItem.title = Constants.Navigation.centerTitle
        let cancelItem = UIBarButtonItem(customView: cancelButton)
        let applyItem = UIBarButtonItem(customView: applyButton)
        self.navigationItem.leftBarButtonItem = cancelItem
        self.navigationItem.rightBarButtonItem = applyItem
    }
    
    private func onTapCancel() {
        viewModel.showMain()
    }
    
    private func onTapApply() {
        // 변경사항 적용 필요
        viewModel.showMain()
    }
    
    @objc private func onTapProfileImage() {
        print("profile image")
    }
    
    @objc private func onTapBackgroundImage() {
        print("background image")
    }
}


// MARK: - TextField Delegate
extension MyPageProfileEditViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        // 버그
        if textField == nicknameField {
            let currentString = (textField.text ?? "") as NSString
            let length = currentString.replacingCharacters(in: range, with: string).count
            nicknameCountLabel.text = "\(length)/\(Constants.Nickname.maxLength)자"
            return length <= Constants.Nickname.maxLength
        }

        return true
    }
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
        self.font = UIFont(name: "Apple SD Gothic Neo SemiBold", size: 16)
    }
}
