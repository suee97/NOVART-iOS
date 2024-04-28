//
//  HomeFeedCell.swift
//  Novart
//
//  Created by Jinwook Huh on 2023/08/19.
//

import UIKit
import Combine

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
            static let itemNameFont: UIFont = .systemFont(ofSize: 20, weight: .bold)
            static let artistNameFont: UIFont = .systemFont(ofSize: 14, weight: .regular)
            static let color: UIColor = UIColor.Common.white
            static let spacing: CGFloat = 2
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
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleCellTap))
        collectionView.addGestureRecognizer(tapGesture)
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
        button.addAction(UIAction(handler: { [weak self] _ in
            guard let self else { return }
            self.viewModel?.didTapLikeButton()
        }), for: .touchUpInside)
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
    private var viewModel: FeedItemViewModel?
    private var cancellables: Set<AnyCancellable> = .init()
    private var setupComplete: Bool = false
    
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
        cancellables.removeAll()
        
        viewModel = item
        itemNameLabel.text = item.name
        artistNameLabel.text = item.artist
        categoryBadge.text = item.category.rawValue
        pageControl.numberOfPages = item.imageUrls.count
        dataSource = FeedImageDataSource(collectionView: collectionView, dataProvider: item.dataProvider(index:))
        let applyData = Array(0..<item.loopedImageUrls.count)
        dataSource?.apply(applyData)
        
        if item.imageUrls.count < 2 {
            collectionView.isScrollEnabled = false
            pageControl.isHidden = true
        } else {
            collectionView.isScrollEnabled = true
            pageControl.isHidden = false
        }
        
        item.$liked
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isLiked in
                guard let self else { return }
                let image = isLiked ? UIImage(named: "icon_heart_fill") : UIImage(named: "icon_heart")
                self.likeButton.setImage(image, for: .normal)
            }
            .store(in: &cancellables)
    }
    
    @objc
    private func handleCellTap(_ sender: UITapGestureRecognizer) {
        guard let outerCollectionView = self.superview as? UICollectionView else { return }
        let locationInCollectionView = sender.location(in: outerCollectionView)
        if let indexPath = outerCollectionView.indexPathForItem(at: locationInCollectionView) {
            outerCollectionView.delegate?.collectionView?(outerCollectionView, didSelectItemAt: indexPath)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        dataSource = nil
        setupComplete = false
    }
    
    func scrollToMiddle() {
        guard let viewModel,
              viewModel.imageUrls.count > 1 else { return }
        let middleSectionIndex = viewModel.imageUrls.count
        collectionView.scrollToItem(at: IndexPath(item: middleSectionIndex, section: 0), at: .centeredHorizontally, animated: false)
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
            guard let self else { return }
            guard let viewModel = self.viewModel, self.setupComplete else { return }
            let offset = point.x
            let width = collectionView.bounds.size.width
            let originalCount = viewModel.imageUrls.count
            let itemWidth = Constants.Image.itemWidth
            let margin = itemWidth / 2
            let horizontalOffset = point.x + margin - width * CGFloat(viewModel.imageUrls.count)
            let pageIndex = Int(horizontalOffset / itemWidth)
            self.pageControl.currentPage = pageIndex

            if offset <= width * CGFloat(originalCount - 1) {
                self.collectionView.scrollToItem(at: .init(row: originalCount * 2 - 1, section: 0), at: .centeredHorizontally, animated: false)
            } else if offset >= width * CGFloat(originalCount * 2) {
                self.collectionView.scrollToItem(at: .init(row: originalCount, section: 0), at: .centeredHorizontally, animated: false)
            }
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
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if !setupComplete {
            scrollToMiddle()
            setupComplete = true
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let viewModel else { return }
        let offset = scrollView.contentOffset.x
        let width = scrollView.bounds.size.width
        let totalCount = viewModel.loopedImageUrls.count
        let originalCount = viewModel.imageUrls.count

//        if offset <= width * CGFloat(originalCount) { // Reached the beginning
//            collectionView.contentOffset = CGPoint(x: width * CGFloat(originalCount) + offset, y: 0)
//        } else if offset >= width * CGFloat(originalCount * 2) { // Reached the end
//            collectionView.contentOffset = CGPoint(x: offset - width * CGFloat(originalCount), y: 0)
//        }
    }
}
