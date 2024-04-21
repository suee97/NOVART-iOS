//
//  BlockViewController.swift
//  Novart
//
//  Created by Jinwook Huh on 2024/02/11.
//

import UIKit
import Kingfisher

final class BlockViewController: BaseViewController, BottomSheetable {
    
    // MARK: - Constants

    private enum Constants {
        enum Handle {
            static let color: UIColor = UIColor.Common.grey01
            static let width: CGFloat = 40
            static let height: CGFloat = 4
            static let topMargin: CGFloat = 12
        }
        
        enum Close {
            static let margin: CGFloat = 24
        }
        
        enum Profile {
            static let borderSize: CGFloat = 64
            static let imageSize: CGFloat = 60
            static let topMargin: CGFloat = 24
            static let bottomMargin: CGFloat = 24
            static let borderColor: UIColor = UIColor.Common.warmGrey01
        }
        
        enum Description {
            static let titleTextColor: UIColor = UIColor.Common.black
            static let titleTextFont: UIFont = UIFont.systemFont(ofSize: 20, weight: .bold)
            static let titleText: String = "이 사용자를 차단하시겠어요?"
            static let horizontalMargin: CGFloat = 40
            static let spacing: CGFloat = 8
            static let descriptionFont: UIFont = UIFont.systemFont(ofSize: 14)
        }
        
        enum BlockButton {
            static let backgroundColor: UIColor = UIColor.Common.black
            static let textColor: UIColor = UIColor.Common.white
            static let font: UIFont = UIFont.systemFont(ofSize: 16, weight: .bold)
            static let cornerRadius: CGFloat = 12
            static let height: CGFloat = 54
            static let bottomMargin: CGFloat = 48
            static let horizontalMargin: CGFloat = 24
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
    
    private lazy var closeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "icon_close"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addAction(UIAction(handler: { [weak self] _ in
            guard let self else { return }
            self.viewModel.closeCoordinator()
        }), for: .touchUpInside)
        return button
    }()
    
    private lazy var profileImageView: PlainProfileImageView = {
        let imageView = PlainProfileImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: Constants.Profile.imageSize),
            imageView.heightAnchor.constraint(equalToConstant: Constants.Profile.imageSize)
        ])
        return imageView
    }()
    
    private lazy var profileBorderView: UIView = {
        let view = UIView()
        view.backgroundColor = Constants.Profile.borderColor
        view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            view.widthAnchor.constraint(equalToConstant: Constants.Profile.borderSize),
            view.heightAnchor.constraint(equalToConstant: Constants.Profile.borderSize)
        ])
        
        view.clipsToBounds = true
        view.layer.cornerRadius = Constants.Profile.borderSize / 2
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = Constants.Description.titleText
        label.textColor = Constants.Description.titleTextColor
        label.font = Constants.Description.titleTextFont
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.lineBreakMode = .byCharWrapping
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var blockButton: UIButton = {
        let button = UIButton()
        button.setTitle("네, 차단할게요", for: .normal)
        button.setTitleColor(Constants.BlockButton.textColor, for: .normal)
        button.titleLabel?.font = Constants.BlockButton.font
        button.backgroundColor = Constants.BlockButton.backgroundColor
        button.layer.cornerRadius = Constants.BlockButton.cornerRadius
        button.clipsToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.addAction(UIAction(handler: { [weak self] _ in
            self?.viewModel.makeBlockRequest()
        }), for: .touchUpInside)
        
        return button
    }()
    
    // MARK: - Properties
    private var viewModel: BlockViewModel

    // MARK: - Initialization
    init(viewModel: BlockViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupData()
    }
    
    override func setupView() {
        view.backgroundColor = UIColor.Common.white
        
        view.addSubview(handleView)
        view.addSubview(closeButton)
        NSLayoutConstraint.activate([
            handleView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            handleView.topAnchor.constraint(equalTo: view.topAnchor, constant: Constants.Handle.topMargin),
            closeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.Close.margin),
            closeButton.topAnchor.constraint(equalTo: view.topAnchor, constant: Constants.Close.margin)
        ])
        
        view.addSubview(profileBorderView)
        view.addSubview(profileImageView)
        NSLayoutConstraint.activate([
            profileBorderView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            profileBorderView.topAnchor.constraint(equalTo: closeButton.bottomAnchor, constant: Constants.Profile.topMargin),
            profileImageView.centerXAnchor.constraint(equalTo: profileBorderView.centerXAnchor),
            profileImageView.centerYAnchor.constraint(equalTo: profileBorderView.centerYAnchor)
        ])
        
        view.addSubview(titleLabel)
        view.addSubview(descriptionLabel)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: profileBorderView.bottomAnchor, constant: Constants.Profile.bottomMargin),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: Constants.Description.spacing),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.Description.horizontalMargin),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.Description.horizontalMargin)
        ])
        
        let descText = "서로에게 문의를 보내거나 프로필 또는 작업을 확인할 수 없게 되며, 차단할 경우 복구가 불가능합니다."
        
        let attributedString = NSMutableAttributedString(string: descText, attributes: [.foregroundColor: UIColor.Common.grey03])

        let length = descText.count
        let start = max(0, length - 18)
        let range = NSRange(location: start, length: length - start)
        attributedString.addAttribute(.foregroundColor, value: UIColor.red, range: range)
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        paragraphStyle.lineSpacing = 3
        attributedString.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: length))
        attributedString.addAttribute(.font, value: Constants.Description.descriptionFont, range: NSRange(location: 0, length: length))
        descriptionLabel.attributedText = attributedString
        
        view.addSubview(blockButton)
        NSLayoutConstraint.activate([
            blockButton.heightAnchor.constraint(equalToConstant: Constants.BlockButton.height),
            blockButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.BlockButton.horizontalMargin),
            blockButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.BlockButton.horizontalMargin),
            blockButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -Constants.BlockButton.bottomMargin)
        ])
    }
    
    private func setupData() {
        if let profileImageUrl = viewModel.user.profileImageUrl {
            profileImageView.setImage(with: URL(string: profileImageUrl))
        }
    }
}
