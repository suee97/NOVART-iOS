//
//  ParticipantCell.swift
//  Novart
//
//  Created by Jinwook Huh on 2023/11/05.
//

import UIKit
import Kingfisher

final class ParticipantCell: UICollectionViewCell {
    
    private enum Constants {
        static let height: CGFloat = 70
        enum Image {
            static let size: CGFloat = 32
            static let bottomMargin: CGFloat = 4
        }
        
        enum Title {
            static let nameFont: UIFont = .systemFont(ofSize: 14, weight: .semibold)
            static let roleFont: UIFont = .systemFont(ofSize: 12, weight: .regular)
            static let textColor: UIColor = UIColor.Common.warmBlack
        }
    }
    
    private lazy var imageView: PlainProfileImageView = {
        let imageView = PlainProfileImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: Constants.Image.size),
            imageView.heightAnchor.constraint(equalToConstant: Constants.Image.size)
        ])
        imageView.layer.cornerRadius = Constants.Image.size / 2
        imageView.clipsToBounds = true
        return imageView
    }()
    
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = Constants.Title.nameFont
        label.textColor = Constants.Title.textColor
        label.textAlignment = .center
        label.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    private lazy var roleLabel: UILabel = {
        let label = UILabel()
        label.font = Constants.Title.roleFont
        label.textColor = Constants.Title.textColor
        label.textAlignment = .center
        label.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        backgroundColor = .clear
        contentView.addSubview(imageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(roleLabel)
        NSLayoutConstraint.activate([
            contentView.heightAnchor.constraint(equalToConstant: Constants.height),
            imageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            nameLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            roleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            roleLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor),
            roleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            roleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            roleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        nameLabel.text = ""
        roleLabel.text = ""
        imageView.removeImage()
    }
}

extension ParticipantCell {
    func update(with data: ExhibitionParticipantModel) {
        if let profileImageUrl = data.profileImageUrl {
            let url = URL(string: profileImageUrl)
            imageView.setImage(with: url)
        }
        nameLabel.text = data.nickname
        roleLabel.text = data.job
    }
}
