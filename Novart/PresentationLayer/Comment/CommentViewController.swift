//
//  CommentViewController.swift
//  Novart
//
//  Created by Jinwook Huh on 2023/10/28.
//

import UIKit
import Combine

final class CommentViewController: BaseViewController {
    
    // MARK: - Constants
    
    enum Constants {
        static let screenWidth: CGFloat = UIScreen.main.bounds.width
        static let horizontalInsets: CGFloat = 24
        static let itemSpacing: CGFloat = 12
        
        enum Title {
            static let font: UIFont = .systemFont(ofSize: 16, weight: .semibold)
            static let textColor: UIColor = UIColor.Common.black
            static let text: String = "의견"
            static let topMargin: CGFloat = 24
            static let bottomMargin: CGFloat = 10
        }
        
        enum InputBar {
            static let verticalMargin: CGFloat = 16
            static let textFieldHeight: CGFloat = 40
            static let profileImageSize: CGFloat = 24
            static let horizontalMargin: CGFloat = 24
            static let spacing: CGFloat = 10
            static let cornerRadius: CGFloat = 12
            static let backgroundColor: UIColor = UIColor.Common.grey00
            static let font: UIFont = UIFont.systemFont(ofSize: 16)
            static let dividerColor: UIColor = UIColor.Common.grey01
            static let dividerHeight: CGFloat = 1
            static let placeholderText: String = "의견 남기기..."
            static let buttonTrailingMargin: CGFloat = 12
        }
    }
    
    // MARK: - UI
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = Constants.Title.text
        label.font = Constants.Title.font
        label.textColor = Constants.Title.textColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var closeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "icon_close"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addAction(UIAction(handler: { [weak self] _ in
            self?.dismiss(animated: true)
        }), for: .touchUpInside)
        return button
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(CommentCell.self, forCellReuseIdentifier: CommentCell.reuseIdentifier)
        tableView.separatorStyle = .none
        return tableView
    }()
    
    private lazy var inputTextField: InputBarTextField = {
        let textField = InputBarTextField(frame: .zero)
        textField.layer.cornerRadius = Constants.InputBar.cornerRadius
        textField.font = Constants.InputBar.font
        textField.placeholder = Constants.InputBar.placeholderText
        textField.backgroundColor = Constants.InputBar.backgroundColor
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        textField.delegate = self
        return textField
    }()
    
    private lazy var inputBarProfileImageView: PlainProfileImageView = {
        let imageView = PlainProfileImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: Constants.InputBar.profileImageSize),
            imageView.heightAnchor.constraint(equalToConstant: Constants.InputBar.profileImageSize)
        ])
        return imageView
    }()
    
    private lazy var sendButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "icon_send_fill"), for: .normal)
        button.setImage(UIImage(named: "icon_send_grey"), for: .disabled)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isEnabled = false
        button.addAction(UIAction(handler: { [weak self] _ in
            guard let self,
            let text = self.inputTextField.text,
            !text.isEmpty
            else { return }
            
            self.viewModel.writeComment(content: text)
            self.inputTextField.text = nil
            self.view.endEditing(true)
        }), for: .touchUpInside)
        return button
    }()
    
    private lazy var inputBar: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        
        let divider = UIView()
        divider.backgroundColor = Constants.InputBar.dividerColor
        divider.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(divider)
        view.addSubview(inputBarProfileImageView)
        view.addSubview(inputTextField)
        view.addSubview(sendButton)
        NSLayoutConstraint.activate([
            divider.topAnchor.constraint(equalTo: view.topAnchor),
            divider.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            divider.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            divider.heightAnchor.constraint(equalToConstant: Constants.InputBar.dividerHeight),
            inputTextField.heightAnchor.constraint(equalToConstant: Constants.InputBar.textFieldHeight),
            inputTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.InputBar.horizontalMargin),
            inputTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.InputBar.horizontalMargin + Constants.InputBar.profileImageSize + Constants.InputBar.spacing),
            inputTextField.topAnchor.constraint(equalTo: divider.bottomAnchor, constant: Constants.InputBar.verticalMargin),
            inputTextField.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -Constants.InputBar.verticalMargin),
            inputBarProfileImageView.centerYAnchor.constraint(equalTo: inputTextField.centerYAnchor),
            inputBarProfileImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.InputBar.horizontalMargin),
            sendButton.centerYAnchor.constraint(equalTo: inputTextField.centerYAnchor),
            sendButton.trailingAnchor.constraint(equalTo: inputTextField.trailingAnchor, constant: -Constants.InputBar.buttonTrailingMargin)
            
        ])
        
        return view
    }()
    
    // MARK: - Properties
    
    private var viewModel: CommentViewModel
    private var subscriptions: Set<AnyCancellable> = .init()
    
    private var inputBarBottomConstraint: NSLayoutConstraint?
    
    // MARK: - Initialization

    init(viewModel: CommentViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupData()
        viewModel.fetchComments()
    }
    
    // MARK: - Setup
    
    override func setupView() {
        view.backgroundColor = .white
        
        let safeArea = view.safeAreaLayoutGuide

        view.addSubview(titleLabel)
        view.addSubview(closeButton)
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: Constants.Title.topMargin),
            closeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.horizontalInsets),
            closeButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor)
        ])
        
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: Constants.Title.bottomMargin),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.horizontalInsets),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.horizontalInsets),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        tableView.delegate = self
        tableView.dataSource = self
        
        view.addSubview(inputBar)
        NSLayoutConstraint.activate([
            inputBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            inputBar.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        inputBarBottomConstraint = inputBar.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor)
        inputBarBottomConstraint?.isActive = true

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        tableView.addGestureRecognizer(tapGesture)
    }
    
    override func setupBindings() {
        viewModel.$comments
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.tableView.reloadData()
            }
            .store(in: &subscriptions)
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow(notification:)),
            name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide(notification:)),
            name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    
    func setupData() {
        if let profileImageUrl = viewModel.userProfileImageUrl {
            inputBarProfileImageView.setImage(with: URL(string: profileImageUrl))
        }
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let keyboardHeight = keyboardSize.height
            
            inputBarBottomConstraint?.isActive = false
            inputBarBottomConstraint = inputBar.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -keyboardHeight)
            inputBarBottomConstraint?.isActive = true

            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        let safeArea = view.safeAreaLayoutGuide
        inputBarBottomConstraint?.isActive = false
        inputBarBottomConstraint = inputBar.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor)
        inputBarBottomConstraint?.isActive = true

        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension CommentViewController: UITableViewDelegate {

}

extension CommentViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CommentCell.reuseIdentifier, for: indexPath) as? CommentCell else { return UITableViewCell() }
        cell.update(with: viewModel.comments[indexPath.row])
        return cell
    }
}

extension CommentViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if let text = textField.text, !text.isEmpty {
            sendButton.isEnabled = true
        } else {
            sendButton.isEnabled = false
        }
    }
}
