//
//  CommentCell.swift
//  Novart
//
//  Created by Jinwook Huh on 2023/10/28.
//

import UIKit
import Kingfisher

protocol CommentCellDelegate: AnyObject {
    func didTapUserProfile(userId: Int64)
}

final class CommentCell: UITableViewCell {
    
    enum Constants {
        static let backgroundColor: UIColor = UIColor.Common.white
        static let topMargin: CGFloat = 16
        static let bottomMargin: CGFloat = 16
        
        enum Name {
            static let font: UIFont = .systemFont(ofSize: 16, weight: .semibold)
            static let textColor: UIColor = UIColor.Common.black
            static let trailingMargin: CGFloat = 8
        }
        
        enum Date {
            static let font: UIFont = .systemFont(ofSize: 12, weight: .regular)
            static let textColor: UIColor = UIColor.Common.grey02
            static let bottomMargin: CGFloat = 8
        }
        
        enum Content {
            static let font: UIFont = .systemFont(ofSize: 16, weight: .regular)
            static let textColor: UIColor = UIColor.Common.black
        }
        
        enum Profile {
            static let size: CGFloat = 24
            static let trailingMargin: CGFloat = 12
        }
    }
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = Constants.Name.font
        label.textColor = Constants.Name.textColor
        label.translatesAutoresizingMaskIntoConstraints = false
        label.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapUserProfile))
        label.addGestureRecognizer(tapGestureRecognizer)
        label.isUserInteractionEnabled = true
        return label
    }()
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.font = Constants.Date.font
        label.textColor = Constants.Date.textColor
        label.translatesAutoresizingMaskIntoConstraints = false
        label.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
        return label
    }()
    
    private lazy var contentLabel: UILabel = {
        let label = UILabel()
        label.font = Constants.Content.font
        label.textColor = Constants.Content.textColor
        label.numberOfLines = 0
        label.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        label.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var profileImageView: PlainProfileImageView = {
        let imageView = PlainProfileImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.heightAnchor.constraint(equalToConstant: Constants.Profile.size),
            imageView.widthAnchor.constraint(equalToConstant: Constants.Profile.size)
        ])
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapUserProfile))
        imageView.addGestureRecognizer(tapGestureRecognizer)
        return imageView
    }()
    
    private lazy var commentMoreButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "icon_comment_more"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    weak var delegate: CommentCellDelegate?
    private var data: CommentModel?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        backgroundColor = Constants.backgroundColor
        selectionStyle = .none
        contentView.addSubview(profileImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(dateLabel)
        NSLayoutConstraint.activate([
            profileImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constants.topMargin),
            profileImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            nameLabel.topAnchor.constraint(equalTo: profileImageView.topAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: Constants.Profile.trailingMargin),
            dateLabel.bottomAnchor.constraint(equalTo: nameLabel.bottomAnchor),
            dateLabel.leadingAnchor.constraint(equalTo: nameLabel.trailingAnchor, constant: Constants.Name.trailingMargin)
        ])
        
        contentView.addSubview(contentLabel)
        NSLayoutConstraint.activate([
            contentLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            contentLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: Constants.Date.bottomMargin),
            contentLabel.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor),
            contentLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Constants.bottomMargin)
        ])
        
        contentView.addSubview(commentMoreButton)
        NSLayoutConstraint.activate([
            commentMoreButton.topAnchor.constraint(equalTo: profileImageView.topAnchor),
            commentMoreButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        data = nil
        dateLabel.text = nil
        nameLabel.text = nil
        contentLabel.text = nil
        profileImageView.removeImage()
        delegate = nil
    }
    
}

extension CommentCell {
    func update(with data: CommentModel) {
        self.data = data
        let url = URL(string: data.profileImageUrl ?? "")
        profileImageView.setImage(with: url)
        nameLabel.text = data.nickname
        dateLabel.text = data.createdAt.toDateFormattedString()
        contentLabel.text = data.content
        
        commentMoreButton.isHidden = !data.isMine
    }
}

extension CommentCell {
    @objc
    private func didTapUserProfile() {
        guard let data else { return }
        let userId = data.userId
        delegate?.didTapUserProfile(userId: userId)
    }
}
