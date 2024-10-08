//
//  LoginViewController.swift
//  Novart
//
//  Created by Jinwook Huh on 2023/07/02.
//

import UIKit
import Combine

final class LoginViewController: BaseViewController {
    
    // MARK: - Constant
    
    private enum Constants {
        
        enum Handle {
            static let color: UIColor = UIColor.Common.warmGrey02
            static let width: CGFloat = 40
            static let height: CGFloat = 4
            static let topMargin: CGFloat = 12
        }
        
        enum Logo {
            static let verticalConstant: CGFloat = 52
        }
        
        enum LoginStackView {
            static let bottomMargin: CGFloat = 24
        }
        
        enum SkipLoginButton {
            static let bottomMargin: CGFloat = 54
            static let font: UIFont = UIFont.systemFont(ofSize: 14, weight: .regular)
            static let color: UIColor = UIColor.Common.grey04
        }
    }

    
    // MARK: - UI
    
    private lazy var handleView: UIView = {
        let view = UIView()
        view.backgroundColor = Constants.Handle.color
        view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            view.widthAnchor.constraint(equalToConstant: Constants.Handle.width),
            view.heightAnchor.constraint(equalToConstant: Constants.Handle.height)
        ])
        
        view.clipsToBounds = true
        view.layer.cornerRadius = Constants.Handle.height / 2
        return view
    }()
    
    private lazy var mainLogoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "logo_login")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private lazy var kakaoButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "login_kakao"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false

        button.addAction(UIAction(handler: { [weak self] _ in
            self?.viewModel.login(with: .kakao)
        }), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var googleButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "login_google"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false

        button.addAction(UIAction(handler: { [weak self] _ in
            self?.viewModel.login(with: .google)
        }), for: .touchUpInside)
        return button
    }()
    
    private lazy var appleButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "login_apple"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false

        button.addAction(UIAction(handler: { [weak self] _ in
            self?.viewModel.login(with: .apple)
        }), for: .touchUpInside)
        return button
    }()
    
    
    private lazy var loginButtonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 0
        
        stackView.addArrangedSubview(kakaoButton)
        stackView.addArrangedSubview(googleButton)
        stackView.addArrangedSubview(appleButton)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var skipLoginButton: UIButton = {
       
        let button = UIButton()
        let buttonTitleString = NSMutableAttributedString(string: "로그인하지 않고 둘러보기")
        buttonTitleString.addAttributes(
            [.font: Constants.SkipLoginButton.font,
             .foregroundColor: Constants.SkipLoginButton.color,
             .underlineStyle: NSUnderlineStyle.single.rawValue
            ],
            range: NSRange(location: 0, length: buttonTitleString.length))
        
        button.setAttributedTitle(buttonTitleString, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addAction(UIAction(handler: { [weak self] _ in
            self?.viewModel.showMainScene()
        }), for: .touchUpInside)
        return button
        
    }()
    
    // MARK: - Properties
    
    private var viewModel: LoginViewModel
    private var subscriptions: Set<AnyCancellable> = .init()
    
    init(viewModel: LoginViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()        
    }
    
    override func setupNavigationBar() {
        navigationController?.navigationBar.isHidden = true
    }
    
    override func setupView() {
        view.backgroundColor = UIColor.Common.white
        
        if viewModel.isPresentedAsModal {
            view.addSubview(handleView)
            NSLayoutConstraint.activate([
                handleView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                handleView.topAnchor.constraint(equalTo: view.topAnchor, constant: Constants.Handle.topMargin)
            ])
        }
        
        let safeArea = view.safeAreaLayoutGuide
        
        view.addSubview(mainLogoImageView)
        NSLayoutConstraint.activate([
            mainLogoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            mainLogoImageView.centerYAnchor.constraint(equalTo: safeArea.centerYAnchor, constant: -Constants.Logo.verticalConstant)
        ])
        
        view.addSubview(skipLoginButton)
        NSLayoutConstraint.activate([
            skipLoginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            skipLoginButton.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -Constants.SkipLoginButton.bottomMargin)
        ])
        
        view.addSubview(loginButtonStackView)
        NSLayoutConstraint.activate([
            loginButtonStackView.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            loginButtonStackView.bottomAnchor.constraint(equalTo: skipLoginButton.topAnchor, constant: -Constants.LoginStackView.bottomMargin)
        ])
    }
    
    override func setupBindings() {
        viewModel.isFirstLogin
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isFirst in
                guard let self else { return }
                if isFirst {
                    self.viewModel.showPolicyAgreeViewController()
                } else {
                    self.viewModel.transitionToMainScene()
                }
            }
            .store(in: &subscriptions)
    }
}
