//
//  ExhibitionEndCell.swift
//  Novart
//
//  Created by Jinwook Huh on 2023/11/19.
//

import UIKit

final class ExhibitionEndCell: UICollectionViewCell {
    
    // MARK: - Constants
    
    private enum Constants {
        static let topMargin: CGFloat = 205
        static let bottomMargin: CGFloat = 56
        static let horizontalMargin: CGFloat = 24
        
        enum Title {
            static let topMargin: CGFloat = 8
            static let font: UIFont = .systemFont(ofSize: 16,  weight: .semibold)
            static let textColor: UIColor = UIColor.Common.warmBlack
            static let subtitleFont: UIFont = .systemFont(ofSize: 14)
            static let spacing: CGFloat = 4
            static let bottomMargin: CGFloat = 32
        }
        
        enum Button {
            static let backgroundColor: UIColor = .Common.white.withAlphaComponent(0.65)
            static let textColor: UIColor = UIColor.Common.warmBlack
            static let font: UIFont = .systemFont(ofSize: 14)
            static let height: CGFloat = 36
            static let imageInset: CGFloat = 2
            static let contentInset: UIEdgeInsets = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12)
            static let spacing: CGFloat = 8
        }
        
        enum NextButton {
            static let topMargin: CGFloat = 205
            static let textColor: UIColor = UIColor.Common.white
            static let font: UIFont = UIFont.systemFont(ofSize: 16, weight: .bold)
            static let backgroundColor: UIColor = UIColor.Common.warmBlack
            static let cornerRadius: CGFloat = 12
            static let height: CGFloat = 56
        }
    }
    
    // MARK: - UI
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = Constants.Title.font
        label.textColor = Constants.Title.textColor
        label.text = "즐거운 관람되셨나요?"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = Constants.Title.subtitleFont
        label.textColor = Constants.Title.textColor
        label.text = "여러분의 관람후기를 작성하고 공유해 보세요"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "icon_plain_black")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let likeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "icon_heart_exhibition"), for: .normal)
        button.backgroundColor = Constants.Button.backgroundColor
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -Constants.Button.imageInset, bottom: 0, right: Constants.Button.imageInset)
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: Constants.Button.imageInset, bottom: 0, right: -Constants.Button.imageInset)
        button.contentEdgeInsets = Constants.Button.contentInset
        button.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            button.heightAnchor.constraint(equalToConstant: Constants.Button.height)
        ])
        button.titleLabel?.font = Constants.Button.font
        button.layer.cornerRadius = Constants.Button.height / 2
        button.clipsToBounds = true
        
        return button
    }()
    
    private let commentButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "icon_comment_exhibition"), for: .normal)
        button.backgroundColor = Constants.Button.backgroundColor
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -Constants.Button.imageInset, bottom: 0, right: Constants.Button.imageInset)
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: Constants.Button.imageInset, bottom: 0, right: -Constants.Button.imageInset)
        button.contentEdgeInsets = Constants.Button.contentInset
        button.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            button.heightAnchor.constraint(equalToConstant: Constants.Button.height)
        ])
        button.titleLabel?.font = Constants.Button.font
        button.layer.cornerRadius = Constants.Button.height / 2
        button.clipsToBounds = true
        
        return button
    }()
    
    private let shareButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "icon_share_exhibition"), for: .normal)
        button.backgroundColor = Constants.Button.backgroundColor
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -Constants.Button.imageInset, bottom: 0, right: Constants.Button.imageInset)
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: Constants.Button.imageInset, bottom: 0, right: -Constants.Button.imageInset)
        button.contentEdgeInsets = Constants.Button.contentInset
        button.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            button.heightAnchor.constraint(equalToConstant: Constants.Button.height)
        ])
        button.titleLabel?.font = Constants.Button.font
        button.setTitle("공유", for: .normal)
        button.layer.cornerRadius = Constants.Button.height / 2
        button.clipsToBounds = true
        
        return button
    }()
    
    private lazy var buttonStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [likeButton, commentButton, shareButton])
        stackView.spacing = Constants.Button.spacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var nextExhibitionButton: UIButton = {
        let button = UIButton()
        button.setTitle("다음 전시 이어서 관람", for: .normal)
        button.setTitleColor(Constants.NextButton.textColor, for: .normal)
        button.titleLabel?.font = Constants.NextButton.font
        button.backgroundColor = Constants.NextButton.backgroundColor
        button.layer.cornerRadius = Constants.NextButton.cornerRadius
        button.clipsToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.addAction(UIAction(handler: { [weak self] _ in
        
        }), for: .touchUpInside)
        
        return button
    }()
    
    // MARK: - Initialization

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    
    private func setupView() {
        contentView.addSubview(iconImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(subtitleLabel)
        NSLayoutConstraint.activate([
            iconImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            iconImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constants.topMargin),
            titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: iconImageView.bottomAnchor, constant: Constants.Title.topMargin),
            subtitleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: Constants.Title.spacing),
        ])
        
        contentView.addSubview(buttonStackView)
        NSLayoutConstraint.activate([
            buttonStackView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            buttonStackView.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: Constants.Title.bottomMargin)
        ])
        
        contentView.addSubview(nextExhibitionButton)
        NSLayoutConstraint.activate([
            nextExhibitionButton.topAnchor.constraint(equalTo: buttonStackView.bottomAnchor, constant: Constants.NextButton.topMargin),
            nextExhibitionButton.heightAnchor.constraint(equalToConstant: Constants.NextButton.height),
            nextExhibitionButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.horizontalMargin),
            nextExhibitionButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.horizontalMargin),
            nextExhibitionButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Constants.bottomMargin)
        ])
        
    }
}

extension ExhibitionEndCell {
    func update(with item: ExhibitionEndItem) {
        contentView.backgroundColor = UIColor(red: 242/255.0, green: 242/255.0, blue: 242/255.0, alpha: 1.0)
        likeButton.setTitle("9.9천", for: .normal)
        likeButton.titleLabel?.textColor = Constants.Button.textColor
        commentButton.setTitle("9.9만", for: .normal)
        commentButton.titleLabel?.textColor = Constants.Button.textColor
        shareButton.titleLabel?.textColor = Constants.Button.textColor
    }
    
}
