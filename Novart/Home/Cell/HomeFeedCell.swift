//
//  HomeFeedCell.swift
//  Novart
//
//  Created by Jinwook Huh on 2023/08/19.
//

import UIKit

final class HomeFeedCell: UICollectionViewCell {
    
    // MARK: - Constants
    
    private enum Constants {
        static let cornerRadius: CGFloat = 12
        static let horizontalInsets: CGFloat = 24
        static let screenWidth: CGFloat = UIScreen.main.bounds.width
        static let leadingMargin: CGFloat = 24
        static let trailingMargin: CGFloat = 24
        static let bottomMargin: CGFloat = 40
        static let topMargin: CGFloat = 24
        
        enum Shadow {
            static let color: CGColor = UIColor.black.cgColor
            static let radius: CGFloat = 5
            static let opacity: Float = 0.4
        }
        
        enum Image {
            static let itemWidth: CGFloat = screenWidth - horizontalInsets * 2
            static let itemHeight: CGFloat = itemWidth * 4 / 3
            static let spacing: CGFloat = 24
        }
        
        enum Label {
            static let itemNameFont: UIFont = .systemFont(ofSize: 24, weight: .bold)
            static let artistNameFont: UIFont = .systemFont(ofSize: 20, weight: .regular)
            static let color: UIColor = UIColor.Common.white
            static let spacing: CGFloat = 4
        }
        
        enum Dim {
            static let height: CGFloat = Image.itemWidth * 0.418
        }
        
        enum PageIndicator {
            static let height: CGFloat = 32
        }
    }
    
    // MARK: - UI
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .clear
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    private lazy var itemNameLabel: UILabel = {
        let label = UILabel()
        label.font = Constants.Label.itemNameFont
        label.textColor = Constants.Label.color
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var artistNameLabel: UILabel = {
        let label = UILabel()
        label.font = Constants.Label.artistNameFont
        label.textColor = Constants.Label.color
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var likeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "icon_heart"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var categoryBadge: BadgeView = {
        let view = BadgeView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var dimView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(named: "feed_dim")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.currentPage = 0
        pageControl.isUserInteractionEnabled = false
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        return pageControl
    }()
    
    // MARK: - Properties
    
    private var dataSource: FeedImageDataSource?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        layer.cornerRadius = Constants.cornerRadius
        layer.shadowColor = Constants.Shadow.color
        layer.shadowOffset = CGSize(width: 0, height: 0)
        layer.shadowRadius = Constants.Shadow.radius
        layer.shadowOpacity = Constants.Shadow.opacity
        
        collectionView.setCollectionViewLayout(feedImageLayout, animated: false)
        collectionView.layer.cornerRadius = Constants.cornerRadius
        collectionView.clipsToBounds = true
        collectionView.delegate = self
        
        
        contentView.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: contentView.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
        contentView.addSubview(dimView)
        NSLayoutConstraint.activate([
            dimView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            dimView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            dimView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            dimView.heightAnchor.constraint(equalToConstant: Constants.Dim.height)
        ])
        
        contentView.addSubview(artistNameLabel)
        NSLayoutConstraint.activate([
            artistNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.leadingMargin),
            artistNameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Constants.bottomMargin)
        ])
        
        contentView.addSubview(itemNameLabel)
        NSLayoutConstraint.activate([
            itemNameLabel.leadingAnchor.constraint(equalTo: artistNameLabel.leadingAnchor),
            itemNameLabel.bottomAnchor.constraint(equalTo: artistNameLabel.topAnchor, constant: -Constants.Label.spacing)
        ])
        
        contentView.addSubview(likeButton)
        NSLayoutConstraint.activate([
            likeButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.trailingMargin),
            likeButton.bottomAnchor.constraint(equalTo: artistNameLabel.bottomAnchor)
        ])
        
        contentView.addSubview(categoryBadge)
        NSLayoutConstraint.activate([
            categoryBadge.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.trailingMargin),
            categoryBadge.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constants.topMargin)
        ])
        
        contentView.addSubview(pageControl)
        NSLayoutConstraint.activate([
            pageControl.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            pageControl.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            pageControl.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            pageControl.heightAnchor.constraint(equalToConstant: Constants.PageIndicator.height)
        ])
    }
    
    func update(with item: FeedItemViewModel) {
        itemNameLabel.text = item.name
        artistNameLabel.text = item.artist
        categoryBadge.text = "그래픽"
        pageControl.numberOfPages = 2
        
        dataSource = FeedImageDataSource(collectionView: collectionView)
        dataSource?.apply(item.imageUrls)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        dataSource = nil
    }
}

// MARK: - CollectionViewLayout
private extension HomeFeedCell {
    var imageSectionLayout: NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(Constants.Image.itemWidth), heightDimension: .absolute(Constants.Image.itemHeight))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(Constants.Image.itemWidth), heightDimension: .absolute(Constants.Image.itemHeight))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPaging
        section.interGroupSpacing = 0
        
        section.visibleItemsInvalidationHandler = { [weak self] _, point, _ in
            let itemWidth = Constants.Image.itemWidth
            let margin = itemWidth / 2
            let horizontalOffset = point.x + margin
            let pageIndex = Int(horizontalOffset / itemWidth)
            self?.pageControl.currentPage = pageIndex
        }
        
        return section
    }
    
    var feedImageLayout: UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { [weak self] (sectionIndex: Int, layoutEnv: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            
            guard let self else { return nil }
            return self.imageSectionLayout
        }
        return layout
    }
}

// MARK: - CollectionViewDelegate
extension HomeFeedCell: UICollectionViewDelegate, UIScrollViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    }
}
