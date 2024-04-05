//
//  ExhibitionEndCell.swift
//  Novart
//
//  Created by Jinwook Huh on 2023/11/19.
//

import UIKit
import Combine

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
    
    class DetailButton: UIView {
        
        private lazy var iconImageView: UIImageView = {
            let imageView = UIImageView()
            imageView.contentMode = .scaleAspectFit
            imageView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                imageView.widthAnchor.constraint(equalToConstant: 24),
                imageView.heightAnchor.constraint(equalToConstant: 24)
            ])
            return imageView
        }()
        
        private lazy var titleLabel: UILabel = {
            let label = UILabel()
            label.font = .systemFont(ofSize: 14)
            label.textColor = UIColor.Common.warmBlack
            label.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
        
        init() {
            super.init(frame: .zero)
            setupView()
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        private func setupView() {
            addSubview(iconImageView)
            addSubview(titleLabel)
            NSLayoutConstraint.activate([
                iconImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 12),
                iconImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 6),
                iconImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -6),
                titleLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 4),
                titleLabel.centerYAnchor.constraint(equalTo: iconImageView.centerYAnchor),
                titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -12)
            ])
            
            clipsToBounds = true
            layer.cornerRadius = 18
            backgroundColor = UIColor.Common.white.withAlphaComponent(0.65)
        }
        
        func setImage(_ image: UIImage?) {
            iconImageView.image = image
        }
        
        func setTitle(_ title: String?) {
            titleLabel.text = title
        }
    }
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = Constants.Title.font
        label.textColor = Constants.Title.textColor
        label.text = "즐거운 관람되셨나요?"
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.heightAnchor.constraint(equalToConstant: 22)
        ])
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = Constants.Title.subtitleFont
        label.textColor = Constants.Title.textColor
        label.text = "여러분의 관람후기를 작성하고 공유해 보세요"
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.heightAnchor.constraint(equalToConstant: 18)
        ])
        return label
    }()
    
    private lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "icon_plain_black")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.heightAnchor.constraint(equalToConstant: 24),
            imageView.widthAnchor.constraint(equalToConstant: 24)
        ])
        return imageView
    }()
    
    private lazy var likeButton: DetailButton = {
        let button = DetailButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let tapGuestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapLikeButton))
        button.addGestureRecognizer(tapGuestureRecognizer)
        return button
    }()
    
    @objc
    private func didTapLikeButton() {
        if !Authentication.shared.isLoggedIn {
            self.input?.send((.shouldShowLogin, 0))
        } else {
            let updatedLikeCount = currentLikeState ? (currentLikeCount - 1) : (currentLikeCount + 1)
            self.updateLikeButton(like: !currentLikeState)
            self.likeButton.setTitle(convertNumToString(updatedLikeCount))
            self.input?.send((.didTapLikeButton(like: !currentLikeState), 0))
            self.currentLikeState.toggle()
            self.currentLikeCount = updatedLikeCount
        }
    }
    
    private lazy var commentButton: DetailButton = {
        let button = DetailButton()
        button.setImage(UIImage(named: "icon_exhibition_comment"))
        button.translatesAutoresizingMaskIntoConstraints = false
        let tapGuestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapCommentButton))
        button.addGestureRecognizer(tapGuestureRecognizer)
        return button
    }()
    
    @objc
    private func didTapCommentButton() {
        input?.send((.didTapCommentButton, 0))
    }
    
    private lazy var shareButton: DetailButton = {
        let button = DetailButton()
        let image = UIImage(named: "icon_exhibition_share")
        button.setImage(image)
        button.setTitle("공유")
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var buttonStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [likeButton, commentButton, shareButton])
        stackView.spacing = Constants.Button.spacing
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var titleStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [iconImageView, titleLabel, subtitleLabel])
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        stackView.setCustomSpacing(Constants.Title.topMargin, after: iconImageView)
        stackView.setCustomSpacing(Constants.Title.spacing, after: titleLabel)
        stackView.alignment = .center
        return stackView
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [titleStackView, buttonStackView])
        stackView.spacing = Constants.Title.bottomMargin
        stackView.axis = .vertical
        stackView.alignment = .center
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

    var input: PassthroughSubject<(ExhibitionDetailViewController.ArtCellInput, Int64), Never>?
    var currentLikeState: Bool = false
    var currentLikeCount: Int = 0
    
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
        
        contentView.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
}

extension ExhibitionEndCell {
    func update(with item: ExhibitionEndItem) {
        contentView.backgroundColor = UIColor(red: 242/255.0, green: 242/255.0, blue: 242/255.0, alpha: 1.0)
        
        likeButton.setTitle(convertNumToString(item.likeCount))
        commentButton.setTitle(convertNumToString(item.commentCount))
        updateLikeButton(like: item.likes)
        currentLikeState = item.likes
        currentLikeCount = item.likeCount
    }
    
    private func updateLikeButton(like: Bool) {
        let likeImage = like ? UIImage(named: "icon_exhibition_heart_fill") : UIImage(named: "icon_exhibition_heart")
        likeButton.setImage(likeImage)
        
    }
}

extension ExhibitionEndCell {
    private func convertNumToString(_ num: Int) -> String {
        if num < 1000 {
            return "\(num)"
        } else if num < 10000 {
            let numberInK = Double(num) / 1000.0
            return String(format: "%.2f천", numberInK)
        } else {
            let numberIn10K = Double(num) / 10000.0
            return String(format: "%.2f만", numberIn10K)
        }
    }
}
