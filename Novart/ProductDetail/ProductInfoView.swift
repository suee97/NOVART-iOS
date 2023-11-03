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
            static let bottomMagin: CGFloat = 32
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
    
    private let tagCollectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.backgroundColor = .clear
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    var viewModel: ProductDetailModel? {
        didSet {
            if let viewModel {
                setNeedsLayout()
                tagCollectionView.reloadData()
                setupData(viewModel: viewModel)
            }
        }
    }
    
    init() {
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: self.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: self.trailingAnchor)
        ])
        
        addSubview(priceIconView)
        addSubview(priceLabel)
        NSLayoutConstraint.activate([
            priceIconView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: Constants.TitleLabel.bottomMargin),
            priceIconView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            priceLabel.centerYAnchor.constraint(equalTo: priceIconView.centerYAnchor),
            priceLabel.leadingAnchor.constraint(equalTo: priceIconView.trailingAnchor, constant: Constants.PriceLabel.iconSpacing),
            priceLabel.trailingAnchor.constraint(lessThanOrEqualTo: self.trailingAnchor)
        ])
        
        addSubview(tagLabel)
        NSLayoutConstraint.activate([
            tagLabel.topAnchor.constraint(equalTo: priceIconView.bottomAnchor, constant: Constants.PriceLabel.bottomMagin),
            tagLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
        ])
        
        addSubview(tagCollectionView)
        NSLayoutConstraint.activate([
            tagCollectionView.topAnchor.constraint(equalTo: tagLabel.bottomAnchor, constant: Constants.Tag.spacing),
            tagCollectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            tagCollectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            tagCollectionView.heightAnchor.constraint(equalToConstant: 80)
        ])
        
        tagCollectionView.dataSource = self
        tagCollectionView.delegate = self
        tagCollectionView.register(TagCell.self, forCellWithReuseIdentifier: TagCell.reuseIdentifier)
        
        addSubview(dateTitleLabel)
        addSubview(dateLabel)
        NSLayoutConstraint.activate([
            dateTitleLabel.topAnchor.constraint(equalTo: tagCollectionView.bottomAnchor, constant: Constants.Date.topMargin),
            dateTitleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            dateLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            dateLabel.topAnchor.constraint(equalTo: dateTitleLabel.bottomAnchor, constant: Constants.Date.spacing),
            dateLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
    
    private func setupData(viewModel: ProductDetailModel) {
        titleLabel.text = viewModel.name
        priceLabel.text = "\(viewModel.price)원"
        dateLabel.text = viewModel.createdAt
    }
}

extension ProductInfoView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let viewModel else { return .zero }
        let tag = viewModel.artTagList[indexPath.row]
        let size = tag.size(withAttributes: [NSAttributedString.Key.font: TagCell.Constants.font])
        print("\(tag): \(size)")
        return CGSize(width: size.width + 2 * TagCell.Constants.horizontalMargin, height: TagCell.Constants.height)
    }
}

extension ProductInfoView: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 4
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 4
    }
}

extension ProductInfoView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let viewModel else { return 0 }
        return viewModel.artTagList.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TagCell.reuseIdentifier, for: indexPath) as? TagCell, let viewModel else {
            return UICollectionViewCell()
        }
        let tag = viewModel.artTagList[indexPath.row]
        cell.update(with: tag)
        return cell
    }

}
