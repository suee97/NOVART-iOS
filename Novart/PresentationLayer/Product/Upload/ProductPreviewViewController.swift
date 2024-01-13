//
//  ProductPreviewViewController.swift
//  Novart
//
//  Created by Jinwook Huh on 2023/12/31.
//

import UIKit
import Combine

final class ProductPreviewViewController: BaseViewController {
    
    // MARK: - Constant
    
    private enum Constants {
        static let horizontalMargin: CGFloat = 24
        static let topMargin: CGFloat = 54
        static let screenWidth: CGFloat = UIScreen.main.bounds.width
        
        enum TitleLabel {
            static let font: UIFont = .systemFont(ofSize: 20, weight: .semibold)
            static let textColor: UIColor = UIColor.Common.warmBlack
        }
        
        enum UploadButton {
            static let font: UIFont = .systemFont(ofSize: 16, weight: .medium)
            static let textColor: UIColor = UIColor.Common.main
            static let disabledColor: UIColor = UIColor.Common.grey02
        }
        
        enum ArtistView {
            static let topMargin: CGFloat = 4
            static let spacing: CGFloat = 8
            static let font: UIFont = .systemFont(ofSize: 14, weight: .regular)
            static let textColor: UIColor = UIColor.Common.warmGrey04
            static let imageSize: CGFloat = 24
        }
        
        enum CoverImage {
            static let topMargin: CGFloat = 8
            static let imageSize: CGFloat = screenWidth
            static let bottomMagrin: CGFloat = 16
        }
        
        enum Description {
            static let topMargin: CGFloat = 32
            static let spacing: CGFloat = 8
            static let titleFont: UIFont = .systemFont(ofSize: 16, weight: .semibold)
            static let font: UIFont = .systemFont(ofSize: 14, weight: .regular)
            static let textColor: UIColor = UIColor.Common.warmBlack
        }
        
        enum DetailImage {
            static let topMargin: CGFloat = 32
            static let spacing: CGFloat = 16
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
            static let horizontalMargin: CGFloat = 10
            static let imageSize: CGFloat = 40
            static let artistNameFont: UIFont = .systemFont(ofSize: 20, weight: .semibold)
            static let artistNameTextColor: UIColor = UIColor.Common.black
            static let backgroundColor: UIColor = UIColor.Common.grey00
            static let spacing: CGFloat = 8
            static let height: CGFloat = 68
        }
        
        enum ProductInfo {
            static let topMargin: CGFloat = 40
            static let trailingMargin: CGFloat = 80
        }
        
        enum Recommendation {
            static let topMargin: CGFloat = 40
            static let itemSpacing: CGFloat = 12
            static let productItemWidth: CGFloat = (screenWidth - horizontalMargin * 2 - itemSpacing) / 2
            static let productItemHeight: CGFloat = productItemWidth * 1.34
            static let exhibitionItemWidth: CGFloat = (screenWidth - horizontalMargin * 2)
            static let exthibitionItemHeight: CGFloat = exhibitionItemWidth * 1.23
            static let headerHeight: CGFloat = 34
            static let sectionBottomInset: CGFloat = 40
            static let collectionViewBottomInset: CGFloat = 16
        }
        
        enum FloatingButton {
            static let bottomMargin: CGFloat = 42
            static let spacing: CGFloat = 10
            static let buttonSize: CGFloat = 40
        }
    }

    // MARK: - UI
    
    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.contentInsetAdjustmentBehavior = .never
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()

    private lazy var uploadButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = Constants.UploadButton.font
        button.setTitle("등록", for: .normal)
        button.setTitleColor(Constants.UploadButton.textColor, for: .normal)
        button.setTitleColor(Constants.UploadButton.disabledColor, for: .disabled)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.addAction(UIAction(handler: { [weak self] _ in
            self?.viewModel.startUploadScene()
        }), for: .touchUpInside)
        
        return button
    }()
    
    
    private lazy var coverCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .clear
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    private lazy var pageController: CustomPageController = {
        let pageController = CustomPageController()
        pageController.spacing = 8
        pageController.size = 4
        pageController.translatesAutoresizingMaskIntoConstraints = false
        return pageController
    }()
    
    private lazy var productDescriptionLabel: UILabel = {
        let label = UILabel()
        label.font = Constants.Description.font
        label.textColor = Constants.Description.textColor
        label.numberOfLines = 0
        label.lineBreakMode = .byCharWrapping
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
    
    private lazy var productInfoView: ProductInfoView = {
        let view = ProductInfoView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let recommendationCollectionView: AutoResizableCollectionView = {
        let collectionView = AutoResizableCollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = .clear
        collectionView.isScrollEnabled = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    
    // MARK: - Properties
    
    private var viewModel: ProductPreviewViewModel
    private lazy var productPreviewCoverDataSource: ProductPreviewImageDataSource = ProductPreviewImageDataSource(collectionView: coverCollectionView)
    private lazy var recommendationDataSource: RecommendationDataSource = RecommendationDataSource(collectionView: recommendationCollectionView)
    private var floatingButtonStackViewTopContraint: NSLayoutConstraint?
    private var cancellables: Set<AnyCancellable> = .init()
    
    init(viewModel: ProductPreviewViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupData(data: viewModel.productPreviewData)
        setupDetailImageViews(with: viewModel.productPreviewData.detailImages)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupInfoView(data: viewModel.productPreviewData)
    }
    
    override func setupNavigationBar() {
        
        let closeButton = UIButton()
        closeButton.setBackgroundImage(UIImage(named: "icon_nav_chevron_left"), for: .normal)
        closeButton.addAction(UIAction(handler: { [weak self] _ in
            guard let self else { return }
            self.navigationController?.popViewController(animated: true)
        }), for: .touchUpInside)
        let closeItem = UIBarButtonItem(customView: closeButton)
        navigationItem.leftBarButtonItem = closeItem
        
        let nextItem = UIBarButtonItem(customView: uploadButton)
        navigationItem.rightBarButtonItem = nextItem
        
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        
        title = "작품 등록"
        uploadButton.isEnabled = true
    }
    
    override func setupView() {
        view.backgroundColor = UIColor.Common.white
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
        
        contentView.addSubview(coverCollectionView)
        NSLayoutConstraint.activate([
            coverCollectionView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constants.topMargin),
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
        
        contentView.addSubview(productDescriptionLabel)
        NSLayoutConstraint.activate([
            productDescriptionLabel.topAnchor.constraint(equalTo: pageController.bottomAnchor, constant: Constants.Description.topMargin),
            productDescriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.horizontalMargin),
            productDescriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.horizontalMargin)
        ])
        
        contentView.addSubview(detailImageStackView)
        NSLayoutConstraint.activate([
            detailImageStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            detailImageStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            detailImageStackView.topAnchor.constraint(equalTo: productDescriptionLabel.bottomAnchor, constant: Constants.DetailImage.topMargin),
        ])
        
        contentView.addSubview(artistInfoView)
        NSLayoutConstraint.activate([
            artistInfoView.topAnchor.constraint(equalTo: detailImageStackView.bottomAnchor, constant: Constants.ArtistInfo.topMargin),
            artistInfoView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.horizontalMargin),
            artistInfoView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.horizontalMargin),
            artistInfoView.heightAnchor.constraint(equalToConstant: Constants.ArtistInfo.height)
        ])
        
        contentView.addSubview(productInfoView)
        NSLayoutConstraint.activate([
            productInfoView.topAnchor.constraint(equalTo: artistInfoView.bottomAnchor, constant: Constants.ProductInfo.topMargin),
            productInfoView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.horizontalMargin),
            productInfoView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.ProductInfo.trailingMargin)
        ])
        
        
        contentView.addSubview(recommendationCollectionView)
        NSLayoutConstraint.activate([
            recommendationCollectionView.topAnchor.constraint(equalTo: productInfoView.bottomAnchor, constant: Constants.Recommendation.topMargin),
            recommendationCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            recommendationCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            recommendationCollectionView.heightAnchor.constraint(greaterThanOrEqualToConstant: 1),
            recommendationCollectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Constants.Recommendation.collectionViewBottomInset)
        ])
        
        recommendationCollectionView.setCollectionViewLayout(recommendationLayout, animated: false)

    }
    
    override func setupBindings() {
    }
    
    private func setupDetailImageViews(with images: [UIImage]) {
        for image in images {
            let imageView = UIImageView()
            imageView.contentMode = .scaleToFill
            imageView.image = image
            
            detailImageStackView.addArrangedSubview(imageView)
            
            let widthConstraint = imageView.widthAnchor.constraint(equalToConstant: Constants.CoverImage.imageSize)
            let aspectRatio = image.size.height / image.size.width
            let heightConstraint = imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: aspectRatio)
            
            NSLayoutConstraint.activate([widthConstraint, heightConstraint])
        }
    }
    
    private func setupData(data: ProductPreviewModel) {
        let coverImages = data.coverImages
        pageController.totalCount = coverImages.count
        productPreviewCoverDataSource = ProductPreviewImageDataSource(collectionView: coverCollectionView)
        productPreviewCoverDataSource.apply(coverImages)
        
        if let artistImageUrl = data.artist.profileImageUrl {
            let url = URL(string: artistImageUrl)
            artistImageView.kf.setImage(with: url)
        }
        
        productDescriptionLabel.text = data.description
        artistNameLabel.text = data.artist.nickname
        
        let artistProducts = [
            ProductModel(id: 1, name: "작품이름", nickname: "작가이름", thumbnailImageUrl: nil),
            ProductModel(id: 1, name: "작품이름", nickname: "작가이름", thumbnailImageUrl: nil),
            ProductModel(id: 1, name: "작품이름", nickname: "작가이름", thumbnailImageUrl: nil),
            ProductModel(id: 1, name: "작품이름", nickname: "작가이름", thumbnailImageUrl: nil)
            ]
        
        var artistExhibitions = [ExhibitionModel]()
        for i in 0..<4 {
            artistExhibitions.append(ExhibitionModel(id: Int64(i), posterImageUrl: "https://t3.ftcdn.net/jpg/02/30/40/74/240_F_230407433_uF2iM6tUs1Sge24999FWdo241t8FMBi7.jpg", description: "description", likesCount: 1, commentCount: 1, liked: true))

        }
        
        let similarProducts = [
            ProductModel(id: 1, name: "작품이름", nickname: "작가이름", thumbnailImageUrl: nil),
            ProductModel(id: 1, name: "작품이름", nickname: "작가이름", thumbnailImageUrl: nil),
            ProductModel(id: 1, name: "작품이름", nickname: "작가이름", thumbnailImageUrl: nil),
            ProductModel(id: 1, name: "작품이름", nickname: "작가이름", thumbnailImageUrl: nil)
            ]
        
        let recommendationDic: [RecommendationDataSource.Section: [PlainItem]] = [.artistProduct: artistProducts,
                                                                                .artistExhibition: artistExhibitions,
                                                                                .similarProduct: similarProducts]
        recommendationDataSource.apply(recommendationDic)
    }
    
    private func setupInfoView(data: ProductPreviewModel) {
        let productDetailModel = ProductDetailModel(previewData: data)
        productInfoView.viewModel = productDetailModel
    }
}

// MARK: - CollectionViewLayout
private extension ProductPreviewViewController {
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
    
    // recommendationLayout
    
    func productSectionLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(Constants.Recommendation.productItemWidth), heightDimension: .absolute(Constants.Recommendation.productItemHeight))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(Constants.Recommendation.productItemWidth), heightDimension: .absolute(Constants.Recommendation.productItemHeight))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(Constants.Recommendation.headerHeight))
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: RecommendationDataSource.sectionHeaderElementKind, alignment: .top)

        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.interGroupSpacing = Constants.Recommendation.itemSpacing
        section.boundarySupplementaryItems = [sectionHeader]
        section.contentInsets = .init(top: 0, leading: Constants.horizontalMargin, bottom: Constants.Recommendation.sectionBottomInset, trailing: Constants.horizontalMargin)
        return section
    }
    
    func exhibitionSectionLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(Constants.Recommendation.exhibitionItemWidth), heightDimension: .absolute(Constants.Recommendation.exthibitionItemHeight))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(Constants.Recommendation.exhibitionItemWidth), heightDimension: .absolute(Constants.Recommendation.exthibitionItemHeight))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(Constants.Recommendation.headerHeight))
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: RecommendationDataSource.sectionHeaderElementKind, alignment: .top)

        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.interGroupSpacing = Constants.Recommendation.itemSpacing
        section.boundarySupplementaryItems = [sectionHeader]
        section.contentInsets = .init(top: 0, leading: Constants.horizontalMargin, bottom: Constants.Recommendation.sectionBottomInset, trailing: Constants.horizontalMargin)
        return section
    }
    
    var recommendationLayout: UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { [weak self] (sectionIndex: Int, layoutEnv: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            
            guard let self else { return nil }
            let section = self.recommendationDataSource.snapshot().sectionIdentifiers[sectionIndex]
            
            switch section {
            case .artistProduct: return self.productSectionLayout()
            case .artistExhibition: return self.exhibitionSectionLayout()
            case .similarProduct: return self.productSectionLayout()
            }
        }
        
        return layout
    }
}
