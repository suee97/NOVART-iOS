//
//  LoginViewController.swift
//  Novart
//
//  Created by Jinwook Huh on 2023/07/02.
//

import UIKit
import Combine

final class LoginViewController: BaseViewController {
    
    // MARK: - UI
    
    private lazy var mainLogoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "logo_novart")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.textAlignment = .center
        label.text = "나만의 새로운 작품"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white
        label.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.text = "예술작품 중개 플랫폼,\n예술작품에서 인테리어까지!"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var loginDividerView: UIView = {
        let view = UIView()
        let leftDividerView = UIView()
        leftDividerView.backgroundColor = UIColor.white
        let rightDividerView = UIView()
        rightDividerView.backgroundColor = UIColor.white
        let loginLabel = UILabel()
        loginLabel.textColor = UIColor.white
        loginLabel.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        loginLabel.textAlignment = .center
        loginLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        loginLabel.text = "로그인"
        leftDividerView.translatesAutoresizingMaskIntoConstraints = false
        rightDividerView.translatesAutoresizingMaskIntoConstraints = false
        loginLabel.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(leftDividerView)
        view.addSubview(loginLabel)
        view.addSubview(rightDividerView)
        
        NSLayoutConstraint.activate([
            loginLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loginLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            leftDividerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            leftDividerView.trailingAnchor.constraint(equalTo: loginLabel.leadingAnchor, constant: -8),
            leftDividerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            leftDividerView.heightAnchor.constraint(equalToConstant: 1),
            rightDividerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            rightDividerView.leadingAnchor.constraint(equalTo: loginLabel.trailingAnchor, constant: 8),
            rightDividerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            rightDividerView.heightAnchor.constraint(equalToConstant: 1),
            view.heightAnchor.constraint(equalToConstant: 17)
        ])

        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var kakaoButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(hexString: "#F9DF4A")
        button.setTitle("카카오로 계속하기", for: .normal)
        button.setTitleColor(UIColor.Common.black, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        button.layer.cornerRadius = 4
        button.translatesAutoresizingMaskIntoConstraints = false
        
        let logoImageView = UIImageView(image: UIImage(named: "logo_kakao"))
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        button.addSubview(logoImageView)
        
        NSLayoutConstraint.activate([
            button.heightAnchor.constraint(equalToConstant: 50),
            logoImageView.leadingAnchor.constraint(equalTo: button.leadingAnchor, constant: 14),
            logoImageView.centerYAnchor.constraint(equalTo: button.centerYAnchor)
        ])
        
        button.addAction(UIAction(handler: { [weak self] _ in
            self?.viewModel.login(with: .kakao)
        }), for: .touchUpInside)
        return button
    }()
    
    private lazy var googleButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor.white
        button.setTitle("구글로 계속하기", for: .normal)
        button.setTitleColor(UIColor.Common.black, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        button.layer.cornerRadius = 4
        button.translatesAutoresizingMaskIntoConstraints = false
        
        let logoImageView = UIImageView(image: UIImage(named: "logo_google"))
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        button.addSubview(logoImageView)
        
        NSLayoutConstraint.activate([
            button.heightAnchor.constraint(equalToConstant: 50),
            logoImageView.leadingAnchor.constraint(equalTo: button.leadingAnchor, constant: 14),
            logoImageView.centerYAnchor.constraint(equalTo: button.centerYAnchor)
        ])
        
        button.addAction(UIAction(handler: { [weak self] _ in
            self?.viewModel.login(with: .google)
        }), for: .touchUpInside)
        return button
    }()
    
    private lazy var appleButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor.black
        button.setTitle("애플로 계속하기", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        button.layer.cornerRadius = 4
        button.translatesAutoresizingMaskIntoConstraints = false
        
        let logoImageView = UIImageView(image: UIImage(named: "logo_apple"))
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        button.addSubview(logoImageView)
        
        NSLayoutConstraint.activate([
            button.heightAnchor.constraint(equalToConstant: 50),
            logoImageView.leadingAnchor.constraint(equalTo: button.leadingAnchor, constant: 14),
            logoImageView.centerYAnchor.constraint(equalTo: button.centerYAnchor)
        ])
        
        button.addAction(UIAction(handler: { _ in
            print("apple")
        }), for: .touchUpInside)
        return button
    }()
    
    
    private lazy var loginButtonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        
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
            [.font: UIFont.systemFont(ofSize: 12, weight: .regular),
             .foregroundColor: UIColor.Common.white,
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
        view.backgroundColor = UIColor.Common.main
        
        view.addSubview(mainLogoImageView)
        NSLayoutConstraint.activate([
            mainLogoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            mainLogoImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 174)
        ])
        
        view.addSubview(titleLabel)
        view.addSubview(subtitleLabel)
        view.addSubview(loginDividerView)
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: mainLogoImageView.bottomAnchor, constant: 40),
            subtitleLabel.centerXAnchor.constraint(equalTo: titleLabel.centerXAnchor),
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            loginDividerView.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 56),
            loginDividerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            loginDividerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24)
        ])
        
        view.addSubview(loginButtonStackView)
        NSLayoutConstraint.activate([
            loginButtonStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loginButtonStackView.topAnchor.constraint(equalTo: loginDividerView.bottomAnchor, constant: 16),
            loginButtonStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            loginButtonStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24)
        ])
        
        view.addSubview(skipLoginButton)
        NSLayoutConstraint.activate([
            skipLoginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            skipLoginButton.topAnchor.constraint(equalTo: loginButtonStackView.bottomAnchor, constant: 16)
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
