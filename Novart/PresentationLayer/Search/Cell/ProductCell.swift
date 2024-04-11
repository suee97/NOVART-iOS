//
//  ProductCell.swift
//  Novart
//
//  Created by Jinwook Huh on 2023/09/24.
//

import UIKit
import Kingfisher

final class ProductCell: UICollectionViewCell {
    
    // MARK: - Constants
    
    private enum Constants {

        static let cornerRadius: CGFloat = 12

        enum BottomInfo {
            static let leadingMargin: CGFloat = 12
            static let trailingMargin: CGFloat = 12
            static let productTextColor: UIColor = UIColor.Common.black
            static let productFont: UIFont = UIFont.systemFont(ofSize: 14, weight: .bold)
            static let artistTextColor: UIColor = UIColor.Common.grey03
            static let artistFont: UIFont = UIFont.systemFont(ofSize: 12, weight: .regular)
            static let backgroundColor: UIColor = UIColor.Common.grey01_light
            static let height: CGFloat = 56
        }
    }
    
    // MARK: - UI

    private lazy var productImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var bottomInfoView: UIView = {
        let view = UIView()
        view.backgroundColor = Constants.BottomInfo.backgroundColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var productLabel: UILabel = {
        let label = UILabel()
        label.font = Constants.BottomInfo.productFont
        label.textColor = Constants.BottomInfo.productTextColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var artistLabel: UILabel = {
        let label = UILabel()
        label.font = Constants.BottomInfo.artistFont
        label.textColor = Constants.BottomInfo.artistTextColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var infoStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [productLabel, artistLabel])
        stackView.spacing = 0
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
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
        
        contentView.addSubview(bottomInfoView)
        NSLayoutConstraint.activate([
            bottomInfoView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            bottomInfoView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            bottomInfoView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            bottomInfoView.heightAnchor.constraint(equalToConstant: Constants.BottomInfo.height)
        ])
        
        contentView.addSubview(productImageView)
        NSLayoutConstraint.activate([
            productImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            productImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            productImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            productImageView.bottomAnchor.constraint(equalTo: bottomInfoView.topAnchor)
        ])
        
        bottomInfoView.addSubview(infoStackView)
        NSLayoutConstraint.activate([
            infoStackView.leadingAnchor.constraint(equalTo: bottomInfoView.leadingAnchor, constant: Constants.BottomInfo.leadingMargin),
            infoStackView.centerYAnchor.constraint(equalTo: bottomInfoView.centerYAnchor)
        ])
        
        
        contentView.layer.cornerRadius = Constants.cornerRadius
        contentView.clipsToBounds = true
        
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.1
        layer.shadowOffset = CGSize(width: 0, height: 2)
    }
}

extension ProductCell {
    func update(with data: ProductModel) {
        productLabel.text = data.name
        artistLabel.text = data.nickname
        
        if let thumbnailUrl = data.thumbnailImageUrl,
           let url = URL(string: thumbnailUrl) {
            productImageView.kf.setImage(with: url)
        }
    }
}
