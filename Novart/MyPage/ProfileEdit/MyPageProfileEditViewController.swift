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
            static let buttonFont = UIFont.systemFont(ofSize: 16, weight: .medium)
            static let titleFont = UIFont.systemFont(ofSize: 16, weight: .bold)
        }
        
        enum ProfileImage {
            static let title: String = "프로필 사진"
            static let titleTopMargin: CGFloat = 16
            static let imageDiameter: CGFloat = 100
            static let imageSize = CGSize(width: 100, height: 100)
            static let imageTopMargin: CGFloat = 8
            static let cameraRightMargin: CGFloat = 2
            static let cameraBottomMargin: CGFloat = 2
            static let cameraDiameter: CGFloat = 24
            static let cameraAlpha: CGFloat = 0.5
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
            static let cameraAlpha: CGFloat = 0.5
        }
        
        enum Nickname {
            static let title: String = "닉네임*"
            static let titleTopMargin: CGFloat = 32
            static let placeHolder: String = "활동할 닉네임 입력"
            static let maxLength: Int = 15
            static let countFont = UIFont.systemFont(ofSize: 12, weight: .regular)
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
    private let profilePicker = UIImagePickerController()
    private let backgroundPicker = UIImagePickerController()
    
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
        profilePicker.delegate = self
        backgroundPicker.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupData()
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
    
    private let profileCameraView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "icon_camera")
        imageView.alpha = Constants.ProfileImage.cameraAlpha
        return imageView
    }()
    
    private lazy var profileImageView: UIImageView = {
        let profileImageView = UIImageView(frame: CGRect(origin: CGPoint.zero, size: Constants.ProfileImage.imageSize))
        profileImageView.image = UIImage(named: "default_user_profile_image")
        profileImageView.layer.cornerRadius = Constants.ProfileImage.imageDiameter / 2
        profileImageView.clipsToBounds = true
        profileImageView.isUserInteractionEnabled = true
        profileImageView.contentMode = .scaleAspectFill
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(onTapProfileImage))
        profileImageView.addGestureRecognizer(gesture)
        
        return profileImageView
    }()
    
    private lazy var backgroundImageView: UIImageView = {
        let backgroundImageView = UIImageView(frame: CGRect(origin: CGPoint.zero, size: Constants.BackgroundImage.imageSize))
        backgroundImageView.image = UIImage(named: "default_user_background_image")
        backgroundImageView.layer.cornerRadius = Constants.BackgroundImage.imageRadius
        backgroundImageView.clipsToBounds = true
        backgroundImageView.isUserInteractionEnabled = true
        backgroundImageView.contentMode = .scaleAspectFill
        
        let cameraImageView = UIImageView(frame: CGRect(origin: Constants.BackgroundImage.cameraOrigin, size: Constants.BackgroundImage.cameraSize))
        cameraImageView.image = UIImage(named: "icon_camera")
        cameraImageView.alpha = Constants.BackgroundImage.cameraAlpha
        
        backgroundImageView.addSubview(cameraImageView)
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(onTapBackgroundImage))
        view.addGestureRecognizer(gesture)
        
        return backgroundImageView
    }()
    
    private let nicknameMaxCountLabel: UILabel = {
        let label = UILabel()
        label.font = Constants.Nickname.countFont
        label.textColor = .Common.grey03
        label.text = "/\(Constants.Nickname.maxLength)자"
        return label
    }()
    
    private lazy var nicknameCurCountLabel: UILabel = {
        let label = UILabel()
        let string = nicknameField.text ?? ""
        let length = string.count
        
        label.font = Constants.Nickname.countFont
        label.text = String(length)
        label.textColor = length > 0 ? .Common.main : .Common.grey03
        return label
    }()
    
    private let nicknameField = ProfileEditTextField(placeholder: Constants.Nickname.placeHolder)
    private let emailField = ProfileEditTextField(placeholder: Constants.Email.placeHolder)
    private let linkField = ProfileEditTextField(placeholder: Constants.Link.placeHolder)

    private lazy var tagView: TagView = {
        let tagView = TagView()
        tagView.delegate = self
        tagView.translatesAutoresizingMaskIntoConstraints = false
        return tagView
    }()
    
    
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
        contentView.addSubview(emailLabel)
        contentView.addSubview(emailField)
        contentView.addSubview(linkLabel)
        contentView.addSubview(linkField)
        contentView.addSubview(tagView)
        
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
            m.top.equalTo(profileImageView.snp.bottom).offset(Constants.Nickname.titleTopMargin)
        })
        
        nicknameMaxCountLabel.snp.makeConstraints({ m in
            m.right.equalToSuperview().inset(Constants.CommonLayout.horizontalMargin)
            m.centerY.equalTo(nicknameLabel)
        })
        
        nicknameCurCountLabel.snp.makeConstraints({ m in
            m.right.equalTo(nicknameMaxCountLabel.snp.left)
            m.centerY.equalTo(nicknameMaxCountLabel)
        })
        
        nicknameField.snp.makeConstraints({ m in
            m.left.right.equalToSuperview().inset(Constants.CommonLayout.horizontalMargin)
            m.top.equalTo(nicknameLabel.snp.bottom).offset(Constants.CommonLayout.fieldTopMargin)
            m.height.equalTo(Constants.CommonLayout.fieldHeight)
        })
        
        tagView.snp.makeConstraints { m in
            m.top.equalTo(nicknameField.snp.bottom).offset(Constants.Email.titleTopMargin)
            m.leading.trailing.equalToSuperview().inset(Constants.CommonLayout.horizontalMargin)
            m.height.equalTo(1000).priority(999)
        }
        
        emailLabel.snp.makeConstraints({ m in
            m.left.equalToSuperview().inset(Constants.CommonLayout.horizontalMargin)
            m.top.equalTo(tagView.snp.bottom).offset(Constants.Email.titleTopMargin) // 임시
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
    
    private func setupData() {
        // 임시
        let tags: [String] = ["재품 디자이너", "시각 디자이너", "UX 디자이너", "패션 디자이너", "3D 아티스트", "크리에이터", "일러스트레이터"]
        tagView.applyItems(tags.map { TagItem(tag: $0) })
    }
    
    private lazy var cancelButton: UIButton = {
        let button = UIButton(frame: Constants.Navigation.buttonSize)
        button.setTitle(Constants.Navigation.cancelTitle, for: .normal)
        button.titleLabel?.font = Constants.Navigation.buttonFont
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
        button.titleLabel?.font = Constants.Navigation.buttonFont
        button.setTitleColor(.Common.grey02, for: .normal)
        button.addAction(UIAction(handler: { [weak self] _ in
            guard let self else { return }
            self.onTapApply()
        }), for: .touchUpInside)
        return button
    }()
    
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
        // 변경사항 적용 필요
        viewModel.showMain()
    }
    
    @objc private func onTapProfileImage() {
        openLibrary(.profile)
    }
    
    @objc private func onTapBackgroundImage() {
        openLibrary(.background)
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
}


// MARK: - TextField Delegate
extension MyPageProfileEditViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        // 버그
        if textField == nicknameField {
            let currentString = (textField.text ?? "") as NSString
            let length = currentString.replacingCharacters(in: range, with: string).count
            nicknameCurCountLabel.text = String(length)
            nicknameCurCountLabel.textColor = length > 0 ? .Common.main : .Common.grey03
            return length <= Constants.Nickname.maxLength
        }

        return true
    }
}

// MARK: - TagView
extension MyPageProfileEditViewController:TagViewDelegate {
    
    func tagView(_ tagView: TagView, didSelectItemAt indexPath: IndexPath) {
    }
    
    func tagView(_ tagView: TagView, didDeselectItemAt indexPath: IndexPath) {
    }
    
    func invalidateLayout(_ contentHeight: CGFloat) {
        tagView.snp.updateConstraints { m in
            m.height.equalTo(contentHeight).priority(999)
        }
    }
}


// MARK: - ImagePicker Delegate
extension MyPageProfileEditViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
        
        if picker == profilePicker {
            profileImageView.image = image
        }
        
        if picker == backgroundPicker {
            backgroundImageView.image = image
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
        self.font = UIFont(name: "Apple SD Gothic Neo SemiBold", size: 16)
    }
}
