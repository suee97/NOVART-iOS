//
//  ProductPreviewViewController.swift
//  Novart
//
//  Created by Jinwook Huh on 2023/12/31.
//

import UIKit
import Combine
import Lottie

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
        
        enum ArtistViewShadow {
            static let color: CGColor = UIColor.black.withAlphaComponent(0.1).cgColor
            static let radius: CGFloat = 6
            static let offset: CGSize = CGSize(width: 0, height: 0)
            static let opacity: Float = 1
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
            static let bottomInset: CGFloat = 56
        }
        
        enum FloatingButton {
            static let bottomMargin: CGFloat = 42
            static let spacing: CGFloat = 10
            static let buttonSize: CGFloat = 40
        }
        
        enum Loading {
            static let color: UIColor = UIColor.Common.black.withAlphaComponent(0.4)
            static let size: CGFloat = 24
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
        let buttonTitle: String = viewModel.isEditScene ? "수정" : "등록"
        button.setTitle(buttonTitle, for: .normal)
        button.setTitleColor(Constants.UploadButton.textColor, for: .normal)
        button.setTitleColor(Constants.UploadButton.disabledColor, for: .disabled)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.addAction(UIAction(handler: { [weak self] _ in
            self?.viewModel.didTapUploadButton()
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
    
    private lazy var artistImageView: PlainProfileImageView = {
        let imageView = PlainProfileImageView()
        imageView.contentMode = .scaleToFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: Constants.ArtistInfo.imageSize),
            imageView.heightAnchor.constraint(equalToConstant: Constants.ArtistInfo.imageSize)
        ])
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
            artistNameLabel.trailingAnchor.constraint(equalTo: contactButton.leadingAnchor, constant: -Constants.ArtistInfo.spacing),
            contactButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            contactButton.trailingAnchor.constraint(equalTo: followButton.leadingAnchor, constant: -Constants.ArtistInfo.spacing)
        ])

        view.layer.shadowColor = Constants.ArtistViewShadow.color
        view.layer.shadowOffset = Constants.ArtistViewShadow.offset
        view.layer.shadowRadius = Constants.ArtistViewShadow.radius
        view.layer.shadowOpacity = Constants.ArtistViewShadow.opacity
        return view
    }()
    
    private lazy var productInfoView: ProductInfoView = {
        let view = ProductInfoView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var dimView: UIView = {
        let view = UIView()
        view.backgroundColor = Constants.Loading.color
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var loadingAnimationView: LottieAnimationView = {
        let view = LottieAnimationView(name: "loading_indicator")
        view.translatesAutoresizingMaskIntoConstraints = false
        view.loopMode = .loop
        return view
    }()
    
    // MARK: - Properties
    
    private var viewModel: ProductPreviewViewModel
    private lazy var productPreviewCoverDataSource: ProductPreviewImageDataSource = ProductPreviewImageDataSource(collectionView: coverCollectionView)
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
        
        title = "미리보기"
        uploadButton.isEnabled = true
    }
    
    override func setupView() {
        view.backgroundColor = UIColor.Common.white
        
        let safeArea = view.safeAreaLayoutGuide
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: safeArea.topAnchor),
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
            productInfoView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.ProductInfo.trailingMargin),
            productInfoView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Constants.ProductInfo.bottomInset)
        ])
        
        view.addSubview(dimView)
        view.addSubview(loadingAnimationView)
        NSLayoutConstraint.activate([
            dimView.topAnchor.constraint(equalTo: view.topAnchor),
            dimView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            dimView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            dimView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            loadingAnimationView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingAnimationView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            loadingAnimationView.widthAnchor.constraint(equalToConstant: Constants.Loading.size),
            loadingAnimationView.heightAnchor.constraint(equalToConstant: Constants.Loading.size)
        ])
        dimView.isHidden = true
        loadingAnimationView.isHidden = true

    }
    
    override func setupBindings() {
        viewModel.isUploadingSubject
            .receive(on: DispatchQueue.main)
            .sink { [weak self] uploading in
                if uploading {
                    self?.showLoadingIndicator()
                } else {
                    self?.hideLoadingIndicator()
                }
            }
            .store(in: &cancellables)
        
        viewModel.uploadingSuccessSubject
            .receive(on: DispatchQueue.main)
            .sink { [weak self] success in
                self?.showUpdatedProductDetail()
            }
            .store(in: &cancellables)
    }
    
    private func setupDetailImageViews(with items: [UIImage]) {
        for image in items {
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
        setupDetailImageViews(with: data.detailImages.map { $0.image})
        if let artistImageUrl = data.artist.profileImageUrl {
            let url = URL(string: artistImageUrl)
            artistImageView.setImage(with: url)
        }
        
        productDescriptionLabel.text = data.description
        artistNameLabel.text = data.artist.nickname
        
    }
    
    private func setupInfoView(data: ProductPreviewModel) {
        let productDetailModel = ProductDetailModel(previewData: data)
        productInfoView.viewModel = productDetailModel
    }
    
    private func showLoadingIndicator() {
        dimView.isHidden = false
        loadingAnimationView.isHidden = false
        loadingAnimationView.play()
    }
    
    private func hideLoadingIndicator() {
        dimView.isHidden = true
        loadingAnimationView.isHidden = true
        loadingAnimationView.play()
    }
    
    @MainActor
    private func showUpdatedProductDetail() {
        viewModel.returnToProductDetail()
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
}
