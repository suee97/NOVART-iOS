//
//  ReportDoneViewController.swift
//  Novart
//
//  Created by Jinwook Huh on 2/17/24.
//

import UIKit

final class ReportDoneViewController: BaseViewController {
    
    // MARK: - Constants
    private enum Constants {
        
        enum TopBar {
            static let backgroundColor = UIColor.Common.grey01
            static let width: CGFloat = 40
            static let height: CGFloat = 4
            static let topMargin: CGFloat = 12
            static let bottomMargin: CGFloat = 64
        }

        enum Title {
            static let text: String = "알려주셔서 감사합니다"
            static let font: UIFont = .systemFont(ofSize: 20, weight: .bold)
            static let textColor: UIColor = .Common.black
            static let topMargin: CGFloat = 24
        }
        
        enum Description {
            static let text: String = "회원님의 소중한 의견을 반영하여 더 나은 PLAIN을\n만들기 위해 노력하겠습니다."
            static let font: UIFont = .systemFont(ofSize: 14, weight: .regular)
            static let textColor: UIColor = .Common.grey04
            static let topMargin: CGFloat = 8
        }
        
        enum DoneButton {
            static let text = "확인"
            static let font = UIFont.systemFont(ofSize: 16, weight: .bold)
            static let radius: CGFloat = 12
            static let enabledBackgroundColor = UIColor.Common.black
            static let enabledTextColor = UIColor.Common.white
            static let topMargin: CGFloat = 60
            static let height: CGFloat = 54
            static let horizontalMargin: CGFloat = 24
        }
    }

    // MARK: - UI
    private let topBar: UIView = {
        let view = UIView()
        view.backgroundColor = Constants.TopBar.backgroundColor
        view.layer.cornerRadius = Constants.TopBar.height / 2
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "icon_check_report")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = Constants.Title.text
        label.textColor = Constants.Title.textColor
        label.font = Constants.Title.font
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = Constants.Description.text
        label.textColor = Constants.Description.textColor
        label.font = Constants.Description.font
        label.numberOfLines = 2
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var doneButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = Constants.DoneButton.radius
        button.setTitle(Constants.DoneButton.text, for: .normal)
        button.titleLabel?.font = Constants.DoneButton.font
        button.backgroundColor = Constants.DoneButton.enabledBackgroundColor
        button.titleLabel?.textColor = Constants.DoneButton.enabledTextColor
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addAction(UIAction(handler: { [weak self] _ in
            guard let self else { return }
            self.viewModel.closeCoordinator()
        }), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Properties
    private var viewModel: ReportDoneViewModel

    // MARK: - Initialization
    init(viewModel: ReportDoneViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    override func setupView() {
        navigationController?.isNavigationBarHidden = true
        view.backgroundColor = UIColor.Common.white
        
        view.addSubview(topBar)
        NSLayoutConstraint.activate([
            topBar.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            topBar.topAnchor.constraint(equalTo: view.topAnchor, constant: Constants.TopBar.topMargin),
            topBar.widthAnchor.constraint(equalToConstant: Constants.TopBar.width),
            topBar.heightAnchor.constraint(equalToConstant: Constants.TopBar.height)
        ])
        
        view.addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.topAnchor.constraint(equalTo: topBar.bottomAnchor, constant: Constants.TopBar.bottomMargin)
        ])
        
        view.addSubview(titleLabel)
        view.addSubview(descriptionLabel)
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: Constants.Title.topMargin),
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: Constants.Description.topMargin),
            descriptionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        view.addSubview(doneButton)
        NSLayoutConstraint.activate([
            doneButton.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: Constants.DoneButton.topMargin),
            doneButton.heightAnchor.constraint(equalToConstant: Constants.DoneButton.height),
            doneButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.DoneButton.horizontalMargin),
            doneButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.DoneButton.horizontalMargin)
        ])
    }
}
