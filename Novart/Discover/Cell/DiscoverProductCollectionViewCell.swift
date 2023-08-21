//
//  DiscoverProductCollectionViewCell.swift
//  Novart
//
//  Created by Jinwook Huh on 2023/07/16.
//

import UIKit

class DiscoverProductCollectionViewCell: UICollectionViewCell {
    // MARK: - Constants
    
    enum Constants {
        
        enum ProductLabel {
            static let font: UIFont = UIFont.systemFont(ofSize: 16, weight: .bold)
            static let textColor: UIColor = UIColor.Common.black
            static let bottomMargin: CGFloat = 4
        }
        
        enum PriceLabel {
            static let font: UIFont = UIFont.systemFont(ofSize: 14, weight: .regular)
            static let textColor: UIColor = UIColor.Common.grey03
            static let bottomMargin: CGFloat = 4
        }
        
        enum ArtistNameBadge {
            static let font: UIFont = UIFont.systemFont(ofSize: 12, weight: .semibold)
            static let textColor: UIColor = UIColor.Common.main
            static let backgroundColor: UIColor = UIColor.Common.lightMain
        }
        
        enum SoldBadge {
            static let font: UIFont = UIFont.systemFont(ofSize: 12, weight: .regular)
            static let textColor: UIColor = UIColor.Common.black
            static let backgroundColor: UIColor = UIColor.Common.grey00
            static let text: String = "판매완료"
        }
        
        enum ProductImageView {
            static let bottomMargin: CGFloat = 4
            static let cornerRadius: CGFloat = 4
        }
    }
    
    // MARK: - UI
    
    private var productImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private var productLabel: UILabel = {
        let label = UILabel()
        label.font = Constants.ProductLabel.font
        label.textColor = Constants.ProductLabel.textColor
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var priceLabel: UILabel = {
        let label = UILabel()
        label.font = Constants.PriceLabel.font
        label.textColor = Constants.PriceLabel.textColor
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var likeButton: NoHighlightButton = {
        let button = NoHighlightButton()
        button.setImage(UIImage(named: "icon_heart"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.addAction(UIAction(handler: { _ in
            print("like")
        }), for: .touchUpInside)
        
        return button
    }()
    
    private var artistNameBadge: BadgeView = {
        let view = BadgeView()
        view.textColor = Constants.ArtistNameBadge.textColor
        view.backgroundColor = Constants.ArtistNameBadge.backgroundColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var soldBadge: BadgeView = {
        let view = BadgeView()
        view.textColor = Constants.SoldBadge.textColor
        view.backgroundColor = Constants.SoldBadge.backgroundColor
        view.text = Constants.SoldBadge.text
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        contentView.addSubview(productImageView)
        NSLayoutConstraint.activate([
            productImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            productImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            productImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            productImageView.heightAnchor.constraint(equalTo: contentView.widthAnchor)
        ])
        
        productImageView.layer.cornerRadius = Constants.ProductImageView.cornerRadius
        productImageView.clipsToBounds = true
        
        contentView.addSubview(productLabel)
        NSLayoutConstraint.activate([
            productLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            productLabel.topAnchor.constraint(equalTo: productImageView.bottomAnchor, constant: Constants.ProductImageView.bottomMargin)
        ])
        
        contentView.addSubview(priceLabel)
        NSLayoutConstraint.activate([
            priceLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            priceLabel.topAnchor.constraint(equalTo: productLabel.bottomAnchor, constant: Constants.ProductLabel.bottomMargin)
        ])
        
        contentView.addSubview(likeButton)
        NSLayoutConstraint.activate([
            likeButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            likeButton.topAnchor.constraint(equalTo: productImageView.bottomAnchor, constant: Constants.ProductImageView.bottomMargin)
        ])
        
        contentView.addSubview(artistNameBadge)
        NSLayoutConstraint.activate([
            artistNameBadge.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            artistNameBadge.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: Constants.PriceLabel.bottomMargin)
        ])
        
        contentView.addSubview(soldBadge)
        NSLayoutConstraint.activate([
            soldBadge.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            soldBadge.centerYAnchor.constraint(equalTo: artistNameBadge.centerYAnchor)
        ])
    }
    
    func update(with data: Int) {
        productImageView.image = UIImage(named: "mock_chair")
        productLabel.text = "의자"
        priceLabel.text = "100,000원"
        artistNameBadge.text = "방태림 작가"
    }
}
