//
//  ExhibitionCell.swift
//  Novart
//
//  Created by Jinwook Huh on 2023/10/22.
//

import UIKit

final class ExhibitionCell: UICollectionViewCell {
    
    // MARK: - Constants
    
    private enum Constants {

        static let cornerRadius: CGFloat = 12
        static let horizontalMargin: CGFloat = 24
        static let bottomMargin: CGFloat = 8
        static let spacing: CGFloat = 4
        static let textColor: UIColor = UIColor.Common.white
        static let titleFont: UIFont = .systemFont(ofSize: 28, weight: .bold)
        static let dateFont: UIFont = .systemFont(ofSize: 20, weight: .semibold)
    }
    
    // MARK: - UI

    private lazy var posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = Constants.titleFont
        label.textColor = Constants.textColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.font = Constants.dateFont
        label.textColor = Constants.textColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
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
        
        contentView.addSubview(posterImageView)
        NSLayoutConstraint.activate([
            posterImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            posterImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            posterImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            posterImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(dateLabel)
        NSLayoutConstraint.activate([
            dateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.horizontalMargin),
            dateLabel.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -Constants.horizontalMargin),
            dateLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Constants.bottomMargin),
            titleLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: Constants.spacing),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.horizontalMargin),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -Constants.horizontalMargin)
        ])
        
        contentView.layer.cornerRadius = Constants.cornerRadius
        contentView.clipsToBounds = true
        
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.1
        layer.shadowOffset = CGSize(width: 0, height: 2)
    }
}

extension ExhibitionCell {
    func update(with data: ExhibitionModel) {
        titleLabel.text = data.name
        dateLabel.text = data.date
        posterImageView.image = UIImage(named: "mock_catalog_poster")
    }
}
