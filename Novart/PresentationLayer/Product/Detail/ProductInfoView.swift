//
//  ProductInfoView.swift
//  Novart
//
//  Created by Jinwook Huh on 2023/10/08.
//

import UIKit

final class ProductInfoView: UIView {
    
    // MARK: - Constant

    private enum Constants {
        enum TitleLabel {
            static let font: UIFont = .systemFont(ofSize: 24, weight: .semibold)
            static let textColor: UIColor = UIColor.Common.black
            static let bottomMargin: CGFloat = 12
        }
        
        enum PriceLabel {
            static let font: UIFont = .systemFont(ofSize: 20, weight: .semibold)
            static let textColor: UIColor = UIColor.Common.black
            static let iconSpacing: CGFloat = 8
            static let bottomMagin: CGFloat = 24
        }
        
        enum DisplayOnlyLabel {
            static let font: UIFont = .systemFont(ofSize: 16, weight: .regular)
            static let textColor: UIColor = UIColor.Common.black
            static let bottomMagin: CGFloat = 24
        }
        
        enum Tag {
            static let titleFont: UIFont = .systemFont(ofSize: 16, weight: .medium)
            static let titleColor: UIColor = UIColor.Common.warmGrey03
            static let spacing: CGFloat = 8
        }
        
        enum Date {
            static let titleFont: UIFont = .systemFont(ofSize: 16, weight: .medium)
            static let titleColor: UIColor = UIColor.Common.warmGrey03
            static let font: UIFont = .systemFont(ofSize: 18, weight: .semibold)
            static let textColor: UIColor = UIColor.Common.black
            static let topMargin: CGFloat = 24
            static let spacing: CGFloat = 8
            static let bottomMargin: CGFloat = 24
        }
    }
    
    // MARK: - UI
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = Constants.TitleLabel.textColor
        label.font = Constants.TitleLabel.font
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var priceIconView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "icon_won")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.textColor = Constants.PriceLabel.textColor
        label.font = Constants.PriceLabel.font
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var priceStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [priceIconView, priceLabel])
        stackView.spacing = Constants.PriceLabel.iconSpacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var displayOnlyLabel: UILabel = {
        let label = UILabel()
        label.textColor = Constants.DisplayOnlyLabel.textColor
        label.font = Constants.DisplayOnlyLabel.font
        label.text = "DISPLAY ONLY"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var leftStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [titleLabel, priceStackView, displayOnlyLabel])
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.spacing = Constants.PriceLabel.iconSpacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var tagLabel: UILabel = {
        let label = UILabel()
        label.textColor = Constants.Tag.titleColor
        label.font = Constants.Tag.titleFont
        label.text = "태그"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var dateTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = Constants.Date.titleColor
        label.font = Constants.Date.titleFont
        label.text = "게시일"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = Constants.Date.textColor
        label.font = Constants.Date.font
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var tagView: TagView = {
        let tagView = TagView()
        tagView.delegate = self
        tagView.translatesAutoresizingMaskIntoConstraints = false
        return tagView
    }()
    
    private lazy var copyrightImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "product_detail_copyright")
        return imageView
    }()
    
    var viewModel: ProductDetailModel? {
        didSet {
            if let viewModel {
                setNeedsLayout()
                setupData(viewModel: viewModel)
            }
        }
    }
    
    private var tagViewHeightConstraint: NSLayoutConstraint?
    
    init() {
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        addSubview(leftStackView)
        NSLayoutConstraint.activate([
            leftStackView.topAnchor.constraint(equalTo: self.topAnchor),
            leftStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            leftStackView.trailingAnchor.constraint(lessThanOrEqualTo: self.trailingAnchor)
        ])
        
        addSubview(tagLabel)
        NSLayoutConstraint.activate([
            tagLabel.topAnchor.constraint(equalTo: leftStackView.bottomAnchor, constant: Constants.PriceLabel.bottomMagin),
            tagLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
        ])
        
        addSubview(tagView)
        tagViewHeightConstraint = tagView.heightAnchor.constraint(equalToConstant: 1000)
        tagViewHeightConstraint?.priority = UILayoutPriority(999)
        tagViewHeightConstraint?.isActive = true
        
        NSLayoutConstraint.activate([
            tagView.topAnchor.constraint(equalTo: tagLabel.bottomAnchor, constant: Constants.Tag.spacing),
            tagView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            tagView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
        
        addSubview(dateTitleLabel)
        addSubview(dateLabel)
        NSLayoutConstraint.activate([
            dateTitleLabel.topAnchor.constraint(equalTo: tagView.bottomAnchor, constant: Constants.Date.topMargin),
            dateTitleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            dateLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            dateLabel.topAnchor.constraint(equalTo: dateTitleLabel.bottomAnchor, constant: Constants.Date.spacing)
        ])
        
        addSubview(copyrightImageView)
        NSLayoutConstraint.activate([
            copyrightImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            copyrightImageView.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: Constants.Date.bottomMargin),
            copyrightImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
    
    private func setupData(viewModel: ProductDetailModel) {
        titleLabel.text = viewModel.name
        if viewModel.forSale {
            priceStackView.isHidden = false
            displayOnlyLabel.isHidden = true
            let priceText = Int(viewModel.price).toDecimalString() ?? "0"
            priceLabel.text = "\(priceText)원"
        } else {
            priceStackView.isHidden = true
            displayOnlyLabel.isHidden = false
        }
        if let createdAt = viewModel.createdAt.toDateFormattedString() {
            dateLabel.text = createdAt
        } else {
            dateLabel.text = viewModel.createdAt
        }
        let tagItems = viewModel.artTagList.map { TagItem(tag: $0) }
        tagView.applyItems(tagItems)
    }
}

extension ProductInfoView: TagViewDelegate {
    func invalidateLayout(_ tagView: TagView, contentHeight: CGFloat) {
        tagViewHeightConstraint?.constant = contentHeight
        layoutIfNeeded()
    }

}
