import UIKit
import SnapKit

final class LoginModalViewController: BaseViewController {

    // MARK: - Constants
    private enum Constants {
        static let screenWidth = UIScreen.main.bounds.size.width
        static let backgroundColor = UIColor.Common.white
        
        enum TopBar {
            static let backgroundColor = UIColor.Common.grey02
            static let width: CGFloat = 40
            static let height: CGFloat = 4
            static let topMargin: CGFloat = 12
        }
        
        enum LogoImageView {
            static let logoImage = UIImage(named: "logo_plain")
            static let width: CGFloat = 128.48
            static let height: CGFloat = 134.27
            static let topMargin: CGFloat = 166
        }
        
        enum titleImageView {
            static let titleImage = UIImage(named: "plain_text")
            static let width: CGFloat = 141
            static let height: CGFloat = 27.42
            static let topMargin: CGFloat = 46
        }
        
        enum subTitleLabel {
            static let text = "가장 가까운 예술"
            static let font = UIFont.systemFont(ofSize: 16, weight: .medium)
            static let textColor = UIColor.Common.main
            static let topMargin: CGFloat = 7.58
        }
        
        enum KakaoButton {
            static let image = UIImage(named: "login_kakao")
            static let diameter: CGFloat = 44
        }
        
        enum GoogleButton {
            static let image = UIImage(named: "login_google")
            static let diameter: CGFloat = 44
        }
        
        enum AppleButton {
            static let image = UIImage(named: "login_apple")
            static let diameter: CGFloat = 44
        }
        
        enum LoginInduceLabel {
            static let text = "로그인 후 경험해 보세요"
            static let font = UIFont.systemFont(ofSize: 14, weight: .regular)
            static let textColor = UIColor.Common.grey03
            static let bottomMargin: CGFloat = 72
        }
        
        enum ButtonStackView {
            static let spacing: CGFloat = 16
            static let bottomMargin: CGFloat = 32
        }
    }
    
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    // MARK: - UI
    private let topBar: UIView = {
        let view = UIView()
        view.backgroundColor = Constants.TopBar.backgroundColor
        view.layer.cornerRadius = Constants.TopBar.height / 2
        return view
    }()
    
    private let logoImageView: UIImageView = {
        let imageView = UIImageView(image: Constants.LogoImageView.logoImage)
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let titleImageView: UIImageView = {
        let imageView = UIImageView(image: Constants.titleImageView.titleImage)
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let subTitleLabel: UILabel = {
        let label = UILabel()
        label.text = Constants.subTitleLabel.text
        label.textColor = Constants.subTitleLabel.textColor
        label.font = Constants.subTitleLabel.font
        return label
    }()
    
    private lazy var kakaoButton: UIButton = {
        let button = UIButton()
        button.setImage(Constants.KakaoButton.image, for: .normal)
        button.snp.makeConstraints({ m in
            m.width.height.equalTo(Constants.KakaoButton.diameter)
        })
        button.layer.cornerRadius = Constants.KakaoButton.diameter / 2
        setLogoButtonShadow(button: button)
        button.addAction(UIAction(handler: { _ in
            print("kakao button tapped")
        }), for: .touchUpInside)
        return button
    }()
    
    private lazy var googleButton: UIButton = {
        let button = UIButton()
        button.setImage(Constants.GoogleButton.image, for: .normal)
        button.snp.makeConstraints({ m in
            m.width.height.equalTo(Constants.GoogleButton.diameter)
        })
        button.layer.cornerRadius = Constants.GoogleButton.diameter / 2
        setLogoButtonShadow(button: button)
        button.addAction(UIAction(handler: { _ in
            print("google button tapped")
        }), for: .touchUpInside)
        return button
    }()
    
    private lazy var appleButton: UIButton = {
        let button = UIButton()
        button.setImage(Constants.AppleButton.image, for: .normal)
        button.snp.makeConstraints({ m in
            m.width.height.equalTo(Constants.AppleButton.diameter)
        })
        button.layer.cornerRadius = Constants.AppleButton.diameter / 2
        setLogoButtonShadow(button: button)
        button.addAction(UIAction(handler: { _ in
            print("apple button tapped")
        }), for: .touchUpInside)
        return button
    }()
    
    private let loginInduceLabel: UILabel = {
        let label = UILabel()
        label.text = Constants.LoginInduceLabel.text
        label.font = Constants.LoginInduceLabel.font
        label.textColor = Constants.LoginInduceLabel.textColor
        return label
    }()
    
    private lazy var buttonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.spacing = Constants.ButtonStackView.spacing
        
        stackView.addArrangedSubview(kakaoButton)
        stackView.addArrangedSubview(googleButton)
        stackView.addArrangedSubview(appleButton)
        return stackView
    }()
    
    override func setupView() {
        view.backgroundColor = Constants.backgroundColor
        
        view.addSubview(topBar)
        view.addSubview(logoImageView)
        view.addSubview(titleImageView)
        view.addSubview(subTitleLabel)
        view.addSubview(loginInduceLabel)
        view.addSubview(buttonStackView)
        
        topBar.snp.makeConstraints({ m in
            m.centerX.equalToSuperview()
            m.top.equalToSuperview().inset(Constants.TopBar.topMargin)
            m.width.equalTo(Constants.TopBar.width)
            m.height.equalTo(Constants.TopBar.height)
        })
        
        logoImageView.snp.makeConstraints({ m in
            m.centerX.equalToSuperview()
            m.top.equalTo(topBar.snp.bottom).offset(Constants.LogoImageView.topMargin)
            m.width.equalTo(Constants.LogoImageView.width)
            m.height.equalTo(Constants.LogoImageView.height)
        })
        
        titleImageView.snp.makeConstraints({ m in
            m.centerX.equalToSuperview()
            m.top.equalTo(logoImageView.snp.bottom).offset(Constants.titleImageView.topMargin)
            m.width.equalTo(Constants.titleImageView.width)
            m.height.equalTo(Constants.titleImageView.height)
        })
        
        subTitleLabel.snp.makeConstraints({ m in
            m.top.equalTo(titleImageView.snp.bottom).offset(Constants.subTitleLabel.topMargin)
            m.centerX.equalToSuperview()
        })
        
        loginInduceLabel.snp.makeConstraints({ m in
            m.bottom.equalToSuperview().inset(Constants.LoginInduceLabel.bottomMargin)
            m.centerX.equalToSuperview()
        })
        
        buttonStackView.snp.makeConstraints({ m in
            m.bottom.equalTo(loginInduceLabel.snp.top).offset(-Constants.ButtonStackView.bottomMargin)
            m.centerX.equalToSuperview()
        })
    }
    
    
    // MARK: - Functions
    private func setLogoButtonShadow(button: UIButton) {
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.12
        button.layer.shadowOffset = CGSize.zero
        button.layer.shadowRadius = 6
    }
}

