//
//  ExhibitionArtCell.swift
//  Novart
//
//  Created by Jinwook Huh on 2023/11/05.
//

import UIKit
import Kingfisher
import Combine

final class ExhibitionArtCell: UICollectionViewCell {
    
    
    // MARK: - Constants
    
    private enum Constants {
        
        static let horizontalMargin: CGFloat = 24
        static let screenWidth: CGFloat = UIScreen.main.bounds.width
        
        enum CoverImage {
            static let imageSize: CGFloat = screenWidth
            static let bottomMagrin: CGFloat = 16
        }
        
        enum Description {
            static let topMargin: CGFloat = 32
            static let titleFont: UIFont = UIFont.systemFont(ofSize: 24, weight: .semibold)
            static let artistNameFont: UIFont = UIFont.systemFont(ofSize: 16, weight: .medium)
            static let artistNameColor: UIColor = UIColor.Common.black
            static let textColor: UIColor = UIColor.Common.warmBlack
            static let descriptionFont: UIFont = UIFont.systemFont(ofSize: 14, weight: .regular)
            static let lineSpacing: CGFloat = 4
            static let descriptionTopMargin: CGFloat = 24
            static let bottomMargin: CGFloat = 32
        }
        
        enum DetailImage {
            static let topMargin: CGFloat = 32
            static let spacing: CGFloat = 8
        }
        
        enum ArtistInfo {
            static let topMargin: CGFloat = 40
            static let buttonTextColor: UIColor = UIColor.Common.white
            static let buttonFont: UIFont = UIFont.systemFont(ofSize: 16, weight: .semibold)
            static let cornerRadius: CGFloat = 12
            static let buttonHeight: CGFloat = 40
            static let contactButtonWidth: CGFloat = 60
            static let followButtonWidth: CGFloat = 74
            static let contactButtonColor: UIColor = UIColor.Common.grey04
            static let followButtonColor: UIColor = UIColor.Common.main
            static let followingButtonColor: UIColor = UIColor.Common.grey04
            static let horizontalMargin: CGFloat = 10
            static let imageSize: CGFloat = 40
            static let artistNameFont: UIFont = .systemFont(ofSize: 20, weight: .semibold)
            static let artistNameTextColor: UIColor = UIColor.Common.black
            static let backgroundColor: UIColor = UIColor.Common.grey00
            static let spacing: CGFloat = 8
            static let height: CGFloat = 68
        }
        
    }
    
    // MARK: - UI
    private lazy var coverCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .clear
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(ProductCoverCell.self, forCellWithReuseIdentifier: ProductCoverCell.reuseIdentifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        return collectionView
    }()
    
    private lazy var pageController: CustomPageController = {
        let pageController = CustomPageController()
        pageController.spacing = 8
        pageController.size = 4
        pageController.translatesAutoresizingMaskIntoConstraints = false
        return pageController
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = Constants.Description.titleFont
        label.textColor = Constants.Description.textColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var artistLabel: UILabel = {
        let label = UILabel()
        label.font = Constants.Description.artistNameFont
        label.textColor = Constants.Description.artistNameColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = Constants.Description.descriptionFont
        label.textColor = Constants.Description.textColor
        label.numberOfLines = 0
        label.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        label.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var detailImageStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = Constants.DetailImage.spacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var contactButton: UIButton = {
        let button = UIButton()
        button.setTitle("문의", for: .normal)
        button.setTitleColor(Constants.ArtistInfo.buttonTextColor, for: .normal)
        button.titleLabel?.font = Constants.ArtistInfo.buttonFont
        button.backgroundColor = Constants.ArtistInfo.contactButtonColor
        button.layer.cornerRadius = Constants.ArtistInfo.cornerRadius
        button.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            button.widthAnchor.constraint(equalToConstant: Constants.ArtistInfo.contactButtonWidth),
            button.heightAnchor.constraint(equalToConstant: Constants.ArtistInfo.buttonHeight)
        ])
        return button
    }()
    
    private lazy var followButton: UIButton = {
        let button = UIButton()
        button.setTitle("팔로우", for: .normal)
        button.setTitleColor(Constants.ArtistInfo.buttonTextColor, for: .normal)
        button.titleLabel?.font = Constants.ArtistInfo.buttonFont
        button.backgroundColor = Constants.ArtistInfo.followButtonColor
        button.layer.cornerRadius = Constants.ArtistInfo.cornerRadius
        button.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            button.widthAnchor.constraint(equalToConstant: Constants.ArtistInfo.followButtonWidth),
            button.heightAnchor.constraint(equalToConstant: Constants.ArtistInfo.buttonHeight)
        ])
        button.addAction(UIAction(handler: { [weak self] _ in
            guard let self, let artistId = self.viewModel?.artistInfo.userId else { return }
            self.updateFollowButton(isFollowing: !self.currentFollowingState)
            self.input?.send((.didTapFollowButton(following: !self.currentFollowingState), artistId))
            self.currentFollowingState.toggle()
        }), for: .touchUpInside)
        return button
    }()
    
    private lazy var artistImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: Constants.ArtistInfo.imageSize),
            imageView.heightAnchor.constraint(equalToConstant: Constants.ArtistInfo.imageSize)
        ])
        imageView.layer.cornerRadius = Constants.ArtistInfo.imageSize / 2
        imageView.clipsToBounds = true
        imageView.image = UIImage(named: "mock_artist")
        return imageView
    }()
    
    private lazy var artistNameLabel: UILabel = {
        let label = UILabel()
        label.font = Constants.ArtistInfo.artistNameFont
        label.textColor = Constants.ArtistInfo.artistNameTextColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var artistInfoView: UIView = {
        let view = UIView()
        view.backgroundColor = Constants.ArtistInfo.backgroundColor
        view.layer.cornerRadius = Constants.ArtistInfo.cornerRadius
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(artistImageView)
        view.addSubview(artistNameLabel)
        view.addSubview(contactButton)
        view.addSubview(followButton)
        NSLayoutConstraint.activate([
            artistImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.ArtistInfo.horizontalMargin),
            artistImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            artistNameLabel.leadingAnchor.constraint(equalTo: artistImageView.trailingAnchor, constant: Constants.ArtistInfo.spacing),
            artistNameLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            followButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.ArtistInfo.horizontalMargin),
            followButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            contactButton.trailingAnchor.constraint(equalTo: followButton.leadingAnchor, constant: -Constants.ArtistInfo.spacing),
            contactButton.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        return view
    }()
    
    // MARK: - Properties
    
    var input: PassthroughSubject<(ExhibitionDetailViewController.ArtCellInput, Int64), Never>?
    
    var currentFollowingState: Bool = false
    
    private var viewModel: ExhibitionArtItem? {
        didSet {
            if let viewModel {
                setupData(viewModel: viewModel)
            }
        }
    }

    private var detailImageStackViewHeightConstraint: NSLayoutConstraint?
    
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
        contentView.addSubview(coverCollectionView)
        NSLayoutConstraint.activate([
            coverCollectionView.topAnchor.constraint(equalTo: contentView.topAnchor),
            coverCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            coverCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            coverCollectionView.heightAnchor.constraint(equalTo: contentView.widthAnchor)
        ])
        
        coverCollectionView.setCollectionViewLayout(coverImageLayout, animated: false)
        
        contentView.addSubview(pageController)
        NSLayoutConstraint.activate([
            pageController.topAnchor.constraint(equalTo: coverCollectionView.bottomAnchor, constant: Constants.CoverImage.bottomMagrin),
            pageController.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
        ])
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(artistLabel)
        contentView.addSubview(descriptionLabel)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: pageController.bottomAnchor, constant: Constants.Description.topMargin),
            titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            artistLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: Constants.Description.lineSpacing),
            artistLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            descriptionLabel.topAnchor.constraint(equalTo: artistLabel.bottomAnchor, constant: Constants.Description.descriptionTopMargin),
            descriptionLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            descriptionLabel.leadingAnchor.constraint(greaterThanOrEqualTo: contentView.leadingAnchor, constant: Constants.horizontalMargin),
            descriptionLabel.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -Constants.horizontalMargin),
        ])
        
        contentView.addSubview(detailImageStackView)
        NSLayoutConstraint.activate([
            detailImageStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            detailImageStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            detailImageStackView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: Constants.DetailImage.topMargin)
        ])
        detailImageStackViewHeightConstraint = detailImageStackView.heightAnchor.constraint(equalToConstant: 1000)
        detailImageStackViewHeightConstraint?.priority = UILayoutPriority(999)
        detailImageStackViewHeightConstraint?.isActive = true
        
        contentView.addSubview(artistInfoView)
        NSLayoutConstraint.activate([
            artistInfoView.topAnchor.constraint(equalTo: detailImageStackView.bottomAnchor, constant: Constants.ArtistInfo.topMargin),
            artistInfoView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.horizontalMargin),
            artistInfoView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.horizontalMargin),
            artistInfoView.heightAnchor.constraint(equalToConstant: Constants.ArtistInfo.height),
            artistInfoView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -32)
        ])
        
    }

    private func setupData(viewModel: ExhibitionArtItem) {
        pageController.totalCount = viewModel.thumbnailImageUrls.count
        titleLabel.text = viewModel.title
        artistLabel.text = viewModel.artistInfo.nickname
        descriptionLabel.text = viewModel.description
        artistNameLabel.text = viewModel.artistInfo.nickname
        if let profileImageUrl = viewModel.artistInfo.profileImageUrl {
            let artistImageUrl = URL(string: profileImageUrl)
            artistImageView.kf.setImage(with: artistImageUrl)
        }
        coverCollectionView.reloadData()
        setupDetailImageViews(with: viewModel.detailImages)
        currentFollowingState = viewModel.artistInfo.following
        updateFollowButton(isFollowing: currentFollowingState)
    }
    
    private func setupDetailImageViews(with images: [ExhibitionDetailImageInfoModel]) {
        var stackViewHeight: CGFloat = 0
        for image in images {
            let imageView = UIImageView()
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.contentMode = .scaleToFill
            
            let widthConstraint = imageView.widthAnchor.constraint(equalToConstant: Constants.CoverImage.imageSize)
            let aspectRatio = CGFloat(image.height) / CGFloat(image.width)
            let heightConstraint = imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: aspectRatio)

            NSLayoutConstraint.activate([
               widthConstraint,
               heightConstraint
            ])
            let url = URL(string: image.url)
            imageView.kf.setImage(with: url)
            detailImageStackView.addArrangedSubview(imageView)

            stackViewHeight += (Constants.CoverImage.imageSize * aspectRatio + Constants.DetailImage.spacing)
        }
        stackViewHeight -= Constants.DetailImage.spacing
        detailImageStackViewHeightConstraint?.constant = stackViewHeight
        layoutIfNeeded()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        detailImageStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
    }
    
    private func updateFollowButton(isFollowing: Bool) {
        let title: String = isFollowing ? "팔로잉" : "팔로우"
        let buttonColor: UIColor = isFollowing ? Constants.ArtistInfo.followingButtonColor : Constants.ArtistInfo.followButtonColor
        followButton.setTitle(title, for: .normal)
        followButton.backgroundColor = buttonColor
    }
}

private extension ExhibitionArtCell {
    var coverSectionLayout: NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(Constants.CoverImage.imageSize), heightDimension: .absolute(Constants.CoverImage.imageSize))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(Constants.CoverImage.imageSize), heightDimension: .absolute(Constants.CoverImage.imageSize))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPaging
        section.interGroupSpacing = 0
        
        section.visibleItemsInvalidationHandler = { [weak self] _, point, _ in
            let itemWidth = Constants.CoverImage.imageSize
            let margin = itemWidth / 2
            let horizontalOffset = point.x + margin
            let pageIndex = Int(horizontalOffset / itemWidth)
            self?.pageController.index = pageIndex
        }
        
        return section
    }
    
    var coverImageLayout: UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { [weak self] (sectionIndex: Int, layoutEnv: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            
            guard let self else { return nil }
            return self.coverSectionLayout
        }
        return layout
    }
}

extension ExhibitionArtCell {
    func update(with data: ExhibitionArtItem) {
        viewModel = data
    }
}

extension ExhibitionArtCell: UICollectionViewDelegate {
    
}

extension ExhibitionArtCell: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.thumbnailImageUrls.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let viewModel, let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductCoverCell.reuseIdentifier, for: indexPath) as? ProductCoverCell else { return UICollectionViewCell() }
        let imageUrl = viewModel.thumbnailImageUrls[indexPath.row]
        cell.update(with: imageUrl)
        return cell
    }
}
