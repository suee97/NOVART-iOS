//
//  SetNicknameViewController.swift
//  Novart
//
//  Created by Jinwook Huh on 2023/07/23.
//

import UIKit
import Combine

final class SetNicknameViewController: BaseViewController {
    // MARK: - Constants
    
    enum Constants {
        
        static let horizontalMargin: CGFloat = 24
        static let bottomMargin: CGFloat = 14
        
        enum TitleLabel {
            static let font: UIFont = UIFont.systemFont(ofSize: 24, weight: .bold)
            static let textColor: UIColor = UIColor.Common.black
            static let bottonMargin: CGFloat = 12
            static let topMargin: CGFloat = 104
        }
        
        enum SubtitleLabel {
            static let font: UIFont = UIFont.systemFont(ofSize: 14, weight: .regular)
            static let textColor: UIColor = UIColor.Common.grey03
            static let bottomMargin: CGFloat = 56

        }
        
        enum TextField {
            static let trailingMargin: CGFloat = 8
            static let borderColor: CGColor = UIColor.Common.grey01.cgColor
            static let borderWidth: CGFloat = 1.0
            static let cornerRadius: CGFloat = 12
            static let bottomMargin: CGFloat = 4
        }
        
        enum DuplicateCheck {
            static let backgroundColor: UIColor = UIColor.Common.main
            static let textColor: UIColor = UIColor.Common.white
            static let disabledBackgroundColor: UIColor = UIColor.Common.grey00
            static let disabledTextColor: UIColor = UIColor.Common.grey01
            static let font: UIFont = UIFont.systemFont(ofSize: 14, weight: .medium)
            static let cornerRadius: CGFloat = 12
            static let height: CGFloat = 49
            static let width: CGFloat = 78
        }
        
        enum DoneButton {
            static let backgroundColor: UIColor = UIColor.Common.main
            static let textColor: UIColor = UIColor.Common.white
            static let disabledBackgroundColor: UIColor = UIColor.Common.grey00
            static let disabledTextColor: UIColor = UIColor.Common.grey01
            static let font: UIFont = UIFont.systemFont(ofSize: 16, weight: .semibold)
            static let cornerRadius: CGFloat = 12
            static let height: CGFloat = 46
        }
        
        enum LengthLabel {
            static let font: UIFont = UIFont.systemFont(ofSize: 12)
            static let textColor: UIColor = UIColor.Common.grey03
        }
        
        enum ValidationLabel {
            static let font: UIFont = UIFont.systemFont(ofSize: 12)
            static let validColor: UIColor = UIColor.Common.grey03
            static let invalidColor: UIColor = UIColor.Common.red
            static let validText: String = "사용 가능한 닉네임입니다."
            static let invalidText: String = "이미 존재하는 닉네임입니다."
            static let leadingMargin: CGFloat = 12
        }
    }
    
    // MARK: - UI
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = Constants.TitleLabel.textColor
        label.font = Constants.TitleLabel.font
        label.textAlignment = .left
        label.numberOfLines = 2
        label.text = "플레인에서 활동할\n닉네임을 만들어주세요."
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = Constants.SubtitleLabel.textColor
        label.font = Constants.SubtitleLabel.font
        label.textAlignment = .left
        label.numberOfLines = 2
        label.text = "해당 닉네임은 자동으로 생성되었어요.\n자유롭게 지정해 보세요!"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var textField: InputBarTextField = {
        let textField = InputBarTextField(frame: .zero)
        textField.layer.cornerRadius = Constants.TextField.cornerRadius
        textField.layer.borderWidth = Constants.TextField.borderWidth
        textField.layer.borderColor = Constants.TextField.borderColor
        textField.font = UIFont.systemFont(ofSize: 16)
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        textField.delegate = self
        return textField
    }()
    
    private lazy var duplicateCheckButton: UIButton = {
        let button = UIButton()
        button.setTitle("중복확인", for: .normal)
        button.setTitleColor(Constants.DuplicateCheck.textColor, for: .normal)
        button.setTitleColor(Constants.DuplicateCheck.disabledTextColor, for: .disabled)
        button.titleLabel?.font = Constants.DuplicateCheck.font
        button.backgroundColor = Constants.DuplicateCheck.backgroundColor
        button.layer.cornerRadius = Constants.DuplicateCheck.cornerRadius
        button.clipsToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.addAction(UIAction(handler: { [weak self] _ in
            guard let self else { return }
            self.viewModel.checkNicknameValidation()
        }), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var doneButton: UIButton = {
        let button = UIButton()
        button.setTitle("완료하기", for: .normal)
        button.setTitleColor(Constants.DoneButton.textColor, for: .normal)
        button.setTitleColor(Constants.DoneButton.disabledTextColor, for: .disabled)
        button.titleLabel?.font = Constants.DoneButton.font
        button.backgroundColor = Constants.DoneButton.backgroundColor
        button.layer.cornerRadius = Constants.DoneButton.cornerRadius
        button.clipsToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.addAction(UIAction(handler: { [weak self] _ in
        
        }), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var maxLengthLabel: UILabel = {
        let label = UILabel()
        label.font = Constants.LengthLabel.font
        label.textColor = Constants.LengthLabel.textColor
        label.text = "/\(viewModel.maximumNicknameLength)자"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var currentLengthLabel: UILabel = {
        let label = UILabel()
        label.font = Constants.LengthLabel.font
        label.textColor = Constants.LengthLabel.textColor
        label.text = "0"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var nicknameLengthStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [currentLengthLabel, maxLengthLabel])
        stackView.axis = .horizontal
        stackView.spacing = 0
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var validationResultLabel: UILabel = {
        let label = UILabel()
        label.font = Constants.ValidationLabel.font
        label.textColor = Constants.ValidationLabel.validColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Properties
    
    private var viewModel: SetNicknameViewModel
    private var cancellables: Set<AnyCancellable> = .init()
    
    // MARK: - Intitialization
    
    init(viewModel: SetNicknameViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.loadDefaultNickname()
    }

    override func setupView() {
        view.backgroundColor = .white
        let safeAreaLayoutGuide = view.safeAreaLayoutGuide

        view.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: Constants.TitleLabel.topMargin),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.horizontalMargin)
        ])
        
        view.addSubview(subtitleLabel)
        NSLayoutConstraint.activate([
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: Constants.TitleLabel.bottonMargin),
            subtitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.horizontalMargin)
        ])
        
        view.addSubview(duplicateCheckButton)
        NSLayoutConstraint.activate([
            duplicateCheckButton.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: Constants.SubtitleLabel.bottomMargin),
            duplicateCheckButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.horizontalMargin),
            duplicateCheckButton.heightAnchor.constraint(equalToConstant: Constants.DuplicateCheck.height),
            duplicateCheckButton.widthAnchor.constraint(equalToConstant: Constants.DuplicateCheck.width)
        ])
        
        view.addSubview(textField)
        NSLayoutConstraint.activate([
            textField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.horizontalMargin),
            textField.trailingAnchor.constraint(equalTo: duplicateCheckButton.leadingAnchor, constant: -Constants.TextField.trailingMargin),
            textField.topAnchor.constraint(equalTo: duplicateCheckButton.topAnchor),
            textField.bottomAnchor.constraint(equalTo: duplicateCheckButton.bottomAnchor)
        ])
        
        view.addSubview(nicknameLengthStackView)
        NSLayoutConstraint.activate([
            nicknameLengthStackView.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: Constants.TextField.bottomMargin),
            nicknameLengthStackView.trailingAnchor.constraint(equalTo: textField.trailingAnchor)
        ])
        
        view.addSubview(validationResultLabel)
        NSLayoutConstraint.activate([
            validationResultLabel.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: Constants.TextField.bottomMargin),
            validationResultLabel.leadingAnchor.constraint(equalTo: textField.leadingAnchor, constant: Constants.ValidationLabel.leadingMargin)
        ])
        
        view.addSubview(doneButton)
        NSLayoutConstraint.activate([
            doneButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -Constants.bottomMargin),
            doneButton.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: Constants.horizontalMargin),
            doneButton.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -Constants.horizontalMargin),
            doneButton.heightAnchor.constraint(equalToConstant: Constants.DoneButton.height)
        ])
    }
    
    override func setupBindings() {
        
        viewModel.$defaultNickname
            .receive(on: DispatchQueue.main)
            .sink { [weak self] name in
                guard let self else { return }
                self.textField.text = name
            }
            .store(in: &cancellables)
        
        viewModel.$nickname
            .receive(on: DispatchQueue.main)
            .sink { [weak self] name in
                guard let self else { return }
                self.currentLengthLabel.text = "\(name.count)"
            }
            .store(in: &cancellables)
        
        viewModel.$isDuplicateCheckEnabled
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isEnabled in
                guard let self else { return }
                self.duplicateCheckButton.isEnabled = isEnabled
                self.duplicateCheckButton.backgroundColor = isEnabled ? Constants.DuplicateCheck.backgroundColor : Constants.DuplicateCheck.disabledBackgroundColor
                
                self.doneButton.isEnabled = !isEnabled
                self.doneButton.backgroundColor = !isEnabled ? Constants.DoneButton.backgroundColor : Constants.DoneButton.disabledBackgroundColor

            }
            .store(in: &cancellables)
        
        viewModel.isValidNickname
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isValid in
                guard let self else { return }
                if isValid {
                    self.updateNicknameValidation(valid: isValid)
                }
            }
            .store(in: &cancellables)
    }
    
    private func updateNicknameValidation(valid: Bool) {
        validationResultLabel.text = valid ? Constants.ValidationLabel.validText : Constants.ValidationLabel.invalidText
        validationResultLabel.textColor = valid ? Constants.ValidationLabel.validColor : Constants.ValidationLabel.invalidColor
    }
}

extension SetNicknameViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        let prospectiveText = (currentText as NSString).replacingCharacters(in: range, with: string)

        return prospectiveText.count <= viewModel.maximumNicknameLength
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        guard let text = textField.text else { return }
        viewModel.nickname = text
    }
}
