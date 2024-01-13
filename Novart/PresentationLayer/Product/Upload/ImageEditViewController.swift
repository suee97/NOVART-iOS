//
//  ImageEditViewController.swift
//  Novart
//
//  Created by Jinwook Huh on 2024/01/01.
//

import UIKit

final class ImageEditViewController: BaseViewController {
    
    // MARK: - Constant

    private enum Constants {
        
        static let screenWidth: CGFloat = UIScreen.main.bounds.width
        
        enum DoneButton {
            static let font: UIFont = .systemFont(ofSize: 16, weight: .medium)
            static let textColor: UIColor = UIColor.Common.main
            static let disabledColor: UIColor = UIColor.Common.grey02
        }
        
        enum Border {
            static let squareHeight: CGFloat = 136
            static let rectHeight: CGFloat = 72
            static let backgroundColor: UIColor = UIColor.black.withAlphaComponent(0.85)
            static let borderColor: UIColor = UIColor.white
            static let borderWidth: CGFloat = 1
        }
        
    }
    
    // MARK: - UI
    
    private lazy var doneButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = Constants.DoneButton.font
        button.setTitle("완료", for: .normal)
        button.setTitleColor(Constants.DoneButton.textColor, for: .normal)
        button.setTitleColor(Constants.DoneButton.disabledColor, for: .disabled)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.addAction(UIAction(handler: { [weak self] _ in
            
        }), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var topBorder: UIView = {
        let view = UIView()
        view.backgroundColor = Constants.Border.backgroundColor
        view.translatesAutoresizingMaskIntoConstraints = false
        let border = UIView()
        border.backgroundColor = Constants.Border.borderColor
        border.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(border)
        NSLayoutConstraint.activate([
            border.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            border.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            border.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            border.heightAnchor.constraint(equalToConstant: Constants.Border.borderWidth)
        ])
        return view
    }()
    
    private lazy var bottomBorder: UIView = {
        let view = UIView()
        view.backgroundColor = Constants.Border.backgroundColor
        view.translatesAutoresizingMaskIntoConstraints = false
        let border = UIView()
        border.backgroundColor = Constants.Border.borderColor
        border.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(border)
        NSLayoutConstraint.activate([
            border.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            border.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            border.topAnchor.constraint(equalTo: view.topAnchor),
            border.heightAnchor.constraint(equalToConstant: Constants.Border.borderWidth)
        ])
        return view
    }()
    
    private lazy var squareButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "button_frame_square"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var rectButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "button_frame_rect"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var buttonStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [squareButton, rectButton])
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupData()
    }
    
    // MARK: - Properties
    
    private var viewModel: ImageEditViewModel
    
    init(viewModel: ImageEditViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupNavigationBar() {
        let closeButton = UIButton()
        closeButton.setBackgroundImage(UIImage(named: "icon_close"), for: .normal)
        closeButton.addAction(UIAction(handler: { [weak self] _ in
            guard let self else { return }
            self.navigationController?.popViewController(animated: true)
        }), for: .touchUpInside)
        let closeItem = UIBarButtonItem(customView: closeButton)
        navigationItem.leftBarButtonItem = closeItem
        
        let nextItem = UIBarButtonItem(customView: doneButton)
        navigationItem.rightBarButtonItem = nextItem
        
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        
        title = "표지 편집"
        doneButton.isEnabled = true
    }
    
    override func setupView() {
        view.backgroundColor = UIColor.Common.white
        
        let safeArea = view.safeAreaLayoutGuide
        
        view.addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
            imageView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor)
        ])
        
        view.addSubview(topBorder)
        view.addSubview(bottomBorder)
        print("his is \(safeArea.layoutFrame.minY)")
        let bottomBorderHeight = UIScreen.main.bounds.height - (navigationController?.navigationBar.frame.height ?? 0) - Constants.screenWidth - Constants.Border.squareHeight
        NSLayoutConstraint.activate([
            topBorder.topAnchor.constraint(equalTo: imageView.topAnchor),
            topBorder.leadingAnchor.constraint(equalTo: imageView.leadingAnchor),
            topBorder.trailingAnchor.constraint(equalTo: imageView.trailingAnchor),
            topBorder.heightAnchor.constraint(equalToConstant: Constants.Border.squareHeight),
            bottomBorder.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            bottomBorder.leadingAnchor.constraint(equalTo: imageView.leadingAnchor),
            bottomBorder.trailingAnchor.constraint(equalTo: imageView.trailingAnchor),
            bottomBorder.heightAnchor.constraint(equalToConstant: bottomBorderHeight)
        ])
        
        view.addSubview(buttonStackView)
        NSLayoutConstraint.activate([
            buttonStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            buttonStackView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -38)
        ])
        
    }
    
    private func setupData() {
        imageView.image = UIImage(named: "mock_bed")
    }
}
