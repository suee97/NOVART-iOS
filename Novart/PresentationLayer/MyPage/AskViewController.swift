import UIKit
import SnapKit

final class AskViewController: BaseViewController {

    // MARK: - Constants
    private enum Constants {
        static let screenWidth = UIScreen.main.bounds.size.width
        static let screenHeight = UIScreen.main.bounds.size.height
        static func getRelativeWidth(from width: CGFloat) -> CGFloat { screenWidth * (width/390) }
        static func getRelativeHeight(from height: CGFloat) -> CGFloat { screenHeight * (height/844) }
        
        static let height = getRelativeHeight(from: 248)
        static let offsetY = screenHeight - height
        
        static let backgroundColor = UIColor.Common.white
        static let radius: CGFloat = 12
        
        enum Shadow {
            static let color: CGColor = UIColor.black.withAlphaComponent(0.25).cgColor
            static let radius: CGFloat = 4
            static let offset: CGSize = CGSize(width: 0, height: 4)
            static let opacity: Float = 1
        }
        
        enum TopBar {
            static let backgroundColor = UIColor.Common.grey01
            static let width: CGFloat = 40
            static let height: CGFloat = 4
            static let topMargin: CGFloat = getRelativeHeight(from: 12)
        }
        
        enum AskLabel {
            static let text = "문의"
            static let textColor = UIColor.Common.black
            static let font = UIFont.systemFont(ofSize: 16, weight: .semibold)
            static let topMargin = getRelativeHeight(from: 8)
        }
        
        enum CancelButton {
            static let diameter = getRelativeWidth(from: 24)
            static let imagePath = "icon_cancel"
            static let rightMargin = getRelativeWidth(from: 24)
        }
        
        enum Divider {
            static let width = getRelativeWidth(from: 342)
            static let height = 0.5
            static let topMargin = getRelativeHeight(from: 4)
            static let color = UIColor.Common.grey01
        }
        
        enum KakaoAskView {
            static let leftMargin = getRelativeWidth(from: 24)
            static let rightMargin = getRelativeWidth(from: 24)
            static let topMargin = getRelativeHeight(from: 16)
            static let height = getRelativeHeight(from: 40 + 32)
            
            enum ImageView {
                static let imagePath = "login_kakao"
                static let diameter = getRelativeWidth(from: 40)
            }
            
            enum Label {
                static let text = "카카오톡으로 문의"
                static let textColor = UIColor.Common.black
                static let font = UIFont.systemFont(ofSize: 16, weight: .semibold)
                static let leftMargin = getRelativeWidth(from: 12)
            }
        }
        
        enum EmailAskView {
            static let leftMargin = getRelativeWidth(from: 24)
            static let rightMargin = getRelativeWidth(from: 24)
            static let topMargin = getRelativeHeight(from: 4)
            static let height = getRelativeHeight(from: 40 + 32)
            
            enum ImageView {
                static let imagePath = "icon_email"
                static let diameter = getRelativeWidth(from: 40)
            }
            
            enum Label {
                static let text = "이메일로 문의"
                static let textColor = UIColor.Common.black
                static let font = UIFont.systemFont(ofSize: 16, weight: .semibold)
                static let leftMargin = getRelativeWidth(from: 12)
            }
        }
    }
    
    
    // MARK: - UI
    private let topBar: UIView = {
        let view = UIView()
        view.backgroundColor = Constants.TopBar.backgroundColor
        view.layer.cornerRadius = Constants.TopBar.height / 2
        return view
    }()
    
    private let askLabel: UILabel = {
        let label = UILabel()
        label.text = Constants.AskLabel.text
        label.textColor = Constants.AskLabel.textColor
        label.font = Constants.AskLabel.font
        return label
    }()
    
    private lazy var cancelButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: Constants.CancelButton.imagePath), for: .normal)
        button.addAction(UIAction(handler: { [weak self] _ in
            guard let self else { return }
            self.onTapCancelButton()
        }), for: .touchUpInside)
        return button
    }()
    
    private lazy var kakaoAskView: UIView = {
        let view = UIView()
        
        let imageView = UIImageView(image: UIImage(named: Constants.KakaoAskView.ImageView.imagePath))
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
        view.addSubview(imageView)
        imageView.snp.makeConstraints({ m in
            m.width.height.equalTo(Constants.KakaoAskView.ImageView.diameter)
            m.left.equalToSuperview()
            m.centerY.equalToSuperview()
        })
        
        let label = UILabel()
        label.text = Constants.KakaoAskView.Label.text
        label.textColor = Constants.KakaoAskView.Label.textColor
        label.font = Constants.KakaoAskView.Label.font
        view.addSubview(label)
        label.snp.makeConstraints({ m in
            m.centerY.equalToSuperview()
            m.left.equalTo(imageView.snp.right).offset(Constants.KakaoAskView.Label.leftMargin)
        })
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(onTapKakaoAskButton))
        view.addGestureRecognizer(gesture)
        return view
    }()
    
    private let divider: UIView = {
        let view = UIView()
        view.backgroundColor = Constants.Divider.color
        return view
    }()
    
    private lazy var emailAskView: UIView = {
        let view = UIView()
        
        let imageView = UIImageView(image: UIImage(named: Constants.EmailAskView.ImageView.imagePath))
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
        view.addSubview(imageView)
        imageView.snp.makeConstraints({ m in
            m.width.height.equalTo(Constants.EmailAskView.ImageView.diameter)
            m.left.equalToSuperview()
            m.centerY.equalToSuperview()
        })
        
        let label = UILabel()
        label.text = Constants.EmailAskView.Label.text
        label.textColor = Constants.EmailAskView.Label.textColor
        label.font = Constants.EmailAskView.Label.font
        view.addSubview(label)
        label.snp.makeConstraints({ m in
            m.centerY.equalToSuperview()
            m.left.equalTo(imageView.snp.right).offset(Constants.EmailAskView.Label.leftMargin)
        })
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(onTapEmailAskButton))
        view.addGestureRecognizer(gesture)
        return view
    }()
    
    override func setupView() {
        view.backgroundColor = Constants.backgroundColor
        view.layer.cornerRadius = Constants.radius
        
        view.layer.shadowColor = Constants.Shadow.color
        view.layer.shadowOffset = Constants.Shadow.offset
        view.layer.shadowRadius = Constants.Shadow.radius
        view.layer.shadowOpacity = Constants.Shadow.opacity
        
        view.addSubview(topBar)
        view.addSubview(askLabel)
        view.addSubview(cancelButton)
        view.addSubview(kakaoAskView)
        view.addSubview(divider)
        view.addSubview(emailAskView)
        
        topBar.snp.makeConstraints({ m in
            m.centerX.equalToSuperview()
            m.top.equalToSuperview().inset(Constants.TopBar.topMargin)
            m.width.equalTo(Constants.TopBar.width)
            m.height.equalTo(Constants.TopBar.height)
        })
        
        askLabel.snp.makeConstraints({ m in
            m.centerX.equalToSuperview()
            m.top.equalTo(topBar.snp.bottom).offset(Constants.AskLabel.topMargin)
        })
        
        cancelButton.snp.makeConstraints({ m in
            m.width.height.equalTo(Constants.CancelButton.diameter)
            m.centerY.equalTo(askLabel)
            m.right.equalToSuperview().inset(Constants.CancelButton.rightMargin)
        })
        
        kakaoAskView.snp.makeConstraints({ m in
            m.left.equalToSuperview().inset(Constants.KakaoAskView.leftMargin)
            m.right.equalToSuperview().inset(Constants.KakaoAskView.rightMargin)
            m.top.equalTo(askLabel.snp.bottom).offset(Constants.KakaoAskView.topMargin)
            m.height.equalTo(Constants.KakaoAskView.height)
        })
        
        divider.snp.makeConstraints({ m in
            m.top.equalTo(kakaoAskView.snp.bottom).offset(Constants.Divider.topMargin)
            m.centerX.equalToSuperview()
            m.width.equalTo(Constants.Divider.width)
            m.height.equalTo(Constants.Divider.height)
        })
        
        emailAskView.snp.makeConstraints({ m in
            m.left.equalToSuperview().inset(Constants.EmailAskView.leftMargin)
            m.right.equalToSuperview().inset(Constants.EmailAskView.rightMargin)
            m.top.equalTo(divider.snp.bottom).offset(Constants.EmailAskView.topMargin)
            m.height.equalTo(Constants.EmailAskView.height)
        })
    }
    
    
    // MARK: - Functions
    private func onTapCancelButton() {
        self.dismiss(animated: true)
    }
    
    @objc private func onTapKakaoAskButton() {
        print("onTapKakaoAskButton")
    }
    
    @objc private func onTapEmailAskButton() {
        print("onTapEmailAskButton")
    }
}
