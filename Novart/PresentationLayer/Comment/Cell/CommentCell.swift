//
//  CommentCell.swift
//  Novart
//
//  Created by Jinwook Huh on 2023/10/28.
//

import UIKit
import Kingfisher

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
            static let font: UIFont = .systemFont(ofSize: 16, weight: .regular)
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
    
    private lazy var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.heightAnchor.constraint(equalToConstant: Constants.Profile.size),
            imageView.widthAnchor.constraint(equalToConstant: Constants.Profile.size)
        ])
        return imageView
    }()
    
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
            dateLabel.topAnchor.constraint(equalTo: nameLabel.topAnchor),
            dateLabel.leadingAnchor.constraint(equalTo: nameLabel.trailingAnchor, constant: Constants.Name.trailingMargin)
        ])
        
        contentView.addSubview(contentLabel)
        NSLayoutConstraint.activate([
            contentLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            contentLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: Constants.Date.bottomMargin),
            contentLabel.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor),
            contentLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Constants.bottomMargin)
        ])
    }
    
}

extension CommentCell {
    func update(with data: CommentModel) {
        let url = URL(string: data.profileImageUrl ?? "")
        profileImageView.kf.setImage(with: url)
        nameLabel.text = data.nickname
        dateLabel.text = data.createdAt
        contentLabel.text = data.content
    }
}
