//
//  PrivacyPolicyViewController.swift
//  Novart
//
//  Created by Jinwook Huh on 2023/07/22.
//

import UIKit
import Combine

final class PrivacyPolicyViewController: BaseViewController {
    
    // MARK: - Constants
    
    enum Constants {
        static let topMargin: CGFloat = 77
        static let leadingMargin: CGFloat = 24
        static let trailingMargin: CGFloat = 24
        static let bottomMargin: CGFloat = 22
        
        enum TitleLabel {
            static let font: UIFont = UIFont.systemFont(ofSize: 20, weight: .bold)
            static let textColor: UIColor = UIColor.Common.black
            static let bottonMargin: CGFloat = 16
        }
        
        enum SubtitleLabel {
            static let font: UIFont = UIFont.systemFont(ofSize: 12, weight: .regular)
            static let textColor: UIColor = UIColor.Common.grey03
        }
        
        enum AllButton {
            static let borderColor: UIColor = UIColor.Common.grey01
            static let backgroundColor: UIColor = UIColor.Common.grey00
            static let cornerRadius: CGFloat = 12
            static let textColor: UIColor = UIColor.Common.black
            static let font: UIFont = UIFont.systemFont(ofSize: 14, weight: .regular)
            static let leadingMargin: CGFloat = 12
            static let bottomMargin: CGFloat = 16
            static let height: CGFloat = 48
        }
        
        enum PolicyView {
            static let leadingMargin: CGFloat = 36
            static let trailingMargin: CGFloat = 36
            static let verticalSpacing: CGFloat = 10
            static let horizontalSpacing: CGFloat = 12
        }
        
        enum NextButton {
            static let backgroundColor: UIColor = UIColor.Common.main
            static let textColor: UIColor = UIColor.Common.white
            static let disabledBackgroundColor: UIColor = UIColor.Common.grey00
            static let disabledTextColor: UIColor = UIColor.Common.grey01
            static let font: UIFont = UIFont.systemFont(ofSize: 16, weight: .semibold)
            static let cornerRadius: CGFloat = 12
            static let height: CGFloat = 46
            static let topMargin: CGFloat = 56
        }
    }
    
    // MARK: - UI
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = Constants.TitleLabel.textColor
        label.font = Constants.TitleLabel.font
        label.textAlignment = .left
        label.numberOfLines = 2
        label.text = "플레인 서비스에\n대한 동의가 필요해요"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = Constants.SubtitleLabel.textColor
        label.font = Constants.SubtitleLabel.font
        label.textAlignment = .left
        label.text = "원활한 이용을 위해 아래 내용을 검토 후 동의해 주세요"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var allCheckBox: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "icon_check_box")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var allButton: UIView = {
        let view = UIView()
        view.backgroundColor = Constants.AllButton.backgroundColor
        view.layer.borderColor = Constants.AllButton.borderColor.cgColor
        view.layer.borderWidth = 1
        view.addSubview(allCheckBox)
        
        let label = UILabel()
        label.font = Constants.AllButton.font
        label.textColor = Constants.AllButton.textColor
        label.text = "전체 동의하기"
        view.addSubview(label)
        
        view.layer.cornerRadius = Constants.AllButton.cornerRadius
        view.clipsToBounds = true
        
        label.translatesAutoresizingMaskIntoConstraints = false
        view.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            allCheckBox.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.AllButton.leadingMargin),
            allCheckBox.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            label.leadingAnchor.constraint(equalTo: allCheckBox.trailingAnchor, constant: 12),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(allButtonTapped))
        view.addGestureRecognizer(tapGestureRecognizer)
        return view
    }()
    
    private lazy var nextButton: UIButton = {
        let button = UIButton()
        button.setTitle("다음으로", for: .normal)
        button.setTitleColor(Constants.NextButton.textColor, for: .normal)
        button.setTitleColor(Constants.NextButton.disabledTextColor, for: .disabled)
        button.titleLabel?.font = Constants.NextButton.font
        button.backgroundColor = Constants.NextButton.backgroundColor
        button.layer.cornerRadius = Constants.NextButton.cornerRadius
        button.clipsToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.addAction(UIAction(handler: { [weak self] _ in
            self?.viewModel.signUp()
        }), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var servicePolicyBox: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "icon_check_box"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addAction(UIAction(handler: { [weak self] _ in
            guard let self else { return }
            self.viewModel.servicePolicySelected.toggle()
            self.updateAllSelected()
        }), for: .touchUpInside)
        return button
    }()
    
    private lazy var servicePolicyView: PolicyContentView = {
        let view = PolicyContentView()
        view.title = "서비스 이용 약관 동의"
        view.isOptional = false
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var privacyPolicyBox: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "icon_check_box"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addAction(UIAction(handler: { [weak self] _ in
            guard let self else { return }
            self.viewModel.privacyPolicySelected.toggle()
            self.updateAllSelected()
        }), for: .touchUpInside)
        return button
    }()
    
    private lazy var privacyPolicyView: PolicyContentView = {
        let view = PolicyContentView()
        view.title = "개인 정보 수집 및 이용 동의"
        view.isOptional = false
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var marketingPolicyBox: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "icon_check_box"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addAction(UIAction(handler: { [weak self] _ in
            guard let self else { return }
            self.viewModel.marketingPolicySelected.toggle()
            self.updateAllSelected()
        }), for: .touchUpInside)
        return button
    }()
    
    private lazy var marketingPolicyView: PolicyContentView = {
        let view = PolicyContentView()
        view.title = "마케팅 정보 수신 동의"
        view.isOptional = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: - Properties
    
    private var viewModel: PrivacyPolicyViewModel
    private var cancellables: Set<AnyCancellable> = .init()

    // MARK: - Intitialization
    
    init(viewModel: PrivacyPolicyViewModel) {
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
        navigationController?.navigationBar.isHidden = false
    }
    
    override func setupView() {
        view.backgroundColor = .white
        let safeAreaLayoutGuide = view.safeAreaLayoutGuide

        view.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: Constants.leadingMargin),
            titleLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: Constants.topMargin)
        ])
        
        view.addSubview(subtitleLabel)
        NSLayoutConstraint.activate([
            subtitleLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: Constants.leadingMargin),
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: Constants.TitleLabel.bottonMargin)
        ])
        
        view.addSubview(nextButton)
        NSLayoutConstraint.activate([
            nextButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -Constants.bottomMargin),
            nextButton.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: Constants.leadingMargin),
            nextButton.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -Constants.trailingMargin),
            nextButton.heightAnchor.constraint(equalToConstant: Constants.NextButton.height)
        ])
        
        view.addSubview(marketingPolicyBox)
        view.addSubview(marketingPolicyView)
        NSLayoutConstraint.activate([
            marketingPolicyBox.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: Constants.PolicyView.leadingMargin),
            marketingPolicyBox.bottomAnchor.constraint(equalTo: nextButton.topAnchor, constant: -Constants.NextButton.topMargin),
            marketingPolicyView.leadingAnchor.constraint(equalTo: marketingPolicyBox.trailingAnchor, constant: Constants.PolicyView.horizontalSpacing),
            marketingPolicyView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -Constants.PolicyView.trailingMargin),
            marketingPolicyView.centerYAnchor.constraint(equalTo: marketingPolicyBox.centerYAnchor)
        ])
        
        view.addSubview(privacyPolicyBox)
        view.addSubview(privacyPolicyView)
        NSLayoutConstraint.activate([
            privacyPolicyBox.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: Constants.PolicyView.leadingMargin),
            privacyPolicyBox.bottomAnchor.constraint(equalTo: marketingPolicyBox.topAnchor, constant: -Constants.PolicyView.verticalSpacing),
            privacyPolicyView.leadingAnchor.constraint(equalTo: privacyPolicyBox.trailingAnchor, constant: Constants.PolicyView.horizontalSpacing),
            privacyPolicyView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -Constants.PolicyView.trailingMargin),
            privacyPolicyView.centerYAnchor.constraint(equalTo: privacyPolicyBox.centerYAnchor)
        ])
        
        view.addSubview(servicePolicyBox)
        view.addSubview(servicePolicyView)
        NSLayoutConstraint.activate([
            servicePolicyBox.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: Constants.PolicyView.leadingMargin),
            servicePolicyBox.bottomAnchor.constraint(equalTo: privacyPolicyBox.topAnchor, constant: -Constants.PolicyView.verticalSpacing),
            servicePolicyView.leadingAnchor.constraint(equalTo: servicePolicyBox.trailingAnchor, constant: Constants.PolicyView.horizontalSpacing),
            servicePolicyView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -Constants.PolicyView.trailingMargin),
            servicePolicyView.centerYAnchor.constraint(equalTo: servicePolicyBox.centerYAnchor)
        ])
        
        view.addSubview(allButton)
        NSLayoutConstraint.activate([
            allButton.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: Constants.leadingMargin),
            allButton.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -Constants.trailingMargin),
            allButton.heightAnchor.constraint(equalToConstant: Constants.AllButton.height),
            allButton.bottomAnchor.constraint(equalTo: servicePolicyBox.topAnchor, constant: -Constants.AllButton.bottomMargin)
        ])
    }
    
    override func setupBindings() {
        viewModel.$allSelected
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isSelected in
                guard let self else { return }
                self.allCheckBox.image = isSelected ? UIImage(named: "icon_check_fill") : UIImage(named: "icon_check_box")
            }
            .store(in: &cancellables)
        
        viewModel.$servicePolicySelected
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isSelected in
                guard let self else { return }
                let image = isSelected ? UIImage(named: "icon_check_fill") : UIImage(named: "icon_check_box")
                self.servicePolicyBox.setImage(image, for: .normal)
              
            }
            .store(in: &cancellables)

        viewModel.$privacyPolicySelected
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isSelected in
                guard let self else { return }
                let image = isSelected ? UIImage(named: "icon_check_fill") : UIImage(named: "icon_check_box")
                self.privacyPolicyBox.setImage(image, for: .normal)
              
            }
            .store(in: &cancellables)
        
        viewModel.$marketingPolicySelected
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isSelected in
                guard let self else { return }
                let image = isSelected ? UIImage(named: "icon_check_fill") : UIImage(named: "icon_check_box")
                self.marketingPolicyBox.setImage(image, for: .normal)
              
            }
            .store(in: &cancellables)
        
        viewModel.$isNextButtonEnabled
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isEnabled in
                self?.nextButton.isEnabled = isEnabled
                self?.nextButton.backgroundColor = isEnabled ? Constants.NextButton.backgroundColor : Constants.NextButton.disabledBackgroundColor
            }
            .store(in: &cancellables)

    }
    
    @objc
    private func allButtonTapped() {
        viewModel.allSelected.toggle()
        viewModel.servicePolicySelected = viewModel.allSelected
        viewModel.privacyPolicySelected = viewModel.allSelected
        viewModel.marketingPolicySelected = viewModel.allSelected
    }
    
    private func updateAllSelected() {
        if !( viewModel.servicePolicySelected && viewModel.privacyPolicySelected && viewModel.marketingPolicySelected ) {
            viewModel.allSelected = false
        }
    }
}
