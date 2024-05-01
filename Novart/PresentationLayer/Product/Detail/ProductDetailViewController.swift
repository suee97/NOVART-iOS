//
//  ProductDetailViewController.swift
//  Novart
//
//  Created by Jinwook Huh on 2023/10/07.
//

import UIKit
import Combine

final class ProductDetailViewController: BaseViewController {
    
    // MARK: - Constant
    
    private enum Constants {
        static let horizontalMargin: CGFloat = 24
        static let topMargin: CGFloat = 62
        static let screenWidth: CGFloat = UIScreen.main.bounds.width
        static let closeButtonTopMargin: CGFloat = 72
        
        enum TitleLabel {
            static let font: UIFont = .systemFont(ofSize: 20, weight: .semibold)
            static let textColor: UIColor = UIColor.Common.warmBlack
            static let trailingMargin: CGFloat = 96
        }
        
        enum ButtonShadow {
            static let color: CGColor = UIColor.black.withAlphaComponent(0.2).cgColor
            static let radius: CGFloat = 4
            static let offset: CGSize = CGSize(width: 0, height: 0)
            static let opacity: Float = 1
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
            static let topMargin: CGFloat = 12
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
            static let profileButtonWidth: CGFloat = 106
            static let contactButtonColor: UIColor = UIColor.Common.grey01
            static let contactButtonDisabledColor: UIColor = UIColor.Common.warmGrey02
            static let followButtonColor: UIColor = UIColor.Common.main
            static let followingButtonColor: UIColor = UIColor.Common.grey04
            static let profileButtonColor: UIColor = UIColor.Common.white
            static let profileButtonTextColor: UIColor = UIColor.Common.black
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
    
    private lazy var barTitleLabel: UILabel = {
        let label = UILabel()
        label.font = Constants.TitleLabel.font
        label.textColor = Constants.TitleLabel.textColor
        label.textAlignment = .left
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var barArtistImageView: PlainProfileImageView = {
        let imageView = PlainProfileImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var barArtistLabel: UILabel = {
        let label = UILabel()
        label.font = Constants.ArtistView.font
        label.textColor = Constants.ArtistView.textColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var closeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "icon_close_round"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addAction(UIAction(handler: { [weak self] _ in
            self?.viewModel.closeCoordinator()
        }), for: .touchUpInside)
        
        button.layer.shadowColor = Constants.ButtonShadow.color
        button.layer.shadowOffset = Constants.ButtonShadow.offset
        button.layer.shadowRadius = Constants.ButtonShadow.radius
        button.layer.shadowOpacity = Constants.ButtonShadow.opacity
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
        
        button.addAction(UIAction(handler: { [weak self] _ in
            guard let self else { return }
            self.viewModel.didTapContactButton()
        }), for: .touchUpInside)
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
            guard let self else { return }
            self.viewModel.didTapFollowButton()
        }), for: .touchUpInside)
        return button
    }()
    
    private lazy var myProfileButton: UIButton = {
        let button = UIButton()
        button.setTitle("프로필 보기", for: .normal)
        button.setTitleColor(Constants.ArtistInfo.profileButtonTextColor, for: .normal)
        button.titleLabel?.font = Constants.ArtistInfo.buttonFont
        button.backgroundColor = Constants.ArtistInfo.profileButtonColor
        button.layer.cornerRadius = Constants.ArtistInfo.cornerRadius
        button.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            button.widthAnchor.constraint(equalToConstant: Constants.ArtistInfo.profileButtonWidth),
            button.heightAnchor.constraint(equalToConstant: Constants.ArtistInfo.buttonHeight)
        ])
        
        button.addAction(UIAction(handler: { [weak self] _ in
            guard let self else { return }
            self.viewModel.didTapMyProfileButton()
        }), for: .touchUpInside)
        return button
    }()
    
    private lazy var artistImageView: PlainProfileImageView = {
        let imageView = PlainProfileImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: Constants.ArtistInfo.imageSize),
            imageView.heightAnchor.constraint(equalToConstant: Constants.ArtistInfo.imageSize)
        ])
        return imageView
    }()
    
    private lazy var artistNameLabel: UILabel = {
        let label = UILabel()
        label.font = Constants.ArtistInfo.artistNameFont
        label.textColor = Constants.ArtistInfo.artistNameTextColor
        label.textAlignment = .left
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
        view.addSubview(myProfileButton)
        NSLayoutConstraint.activate([
            artistImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.ArtistInfo.horizontalMargin),
            artistImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            artistNameLabel.leadingAnchor.constraint(equalTo: artistImageView.trailingAnchor, constant: Constants.ArtistInfo.spacing),
            artistNameLabel.trailingAnchor.constraint(equalTo: contactButton.leadingAnchor, constant: -Constants.ArtistInfo.spacing),
            artistNameLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            followButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.ArtistInfo.horizontalMargin),
            followButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            artistNameLabel.trailingAnchor.constraint(equalTo: contactButton.leadingAnchor, constant: Constants.ArtistInfo.spacing),
            contactButton.trailingAnchor.constraint(equalTo: followButton.leadingAnchor, constant: -Constants.ArtistInfo.spacing),
            contactButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            myProfileButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.ArtistInfo.horizontalMargin),
            myProfileButton.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])

        view.layer.shadowColor = Constants.ArtistViewShadow.color
        view.layer.shadowOffset = Constants.ArtistViewShadow.offset
        view.layer.shadowRadius = Constants.ArtistViewShadow.radius
        view.layer.shadowOpacity = Constants.ArtistViewShadow.opacity
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapArtistInfoView))
        view.addGestureRecognizer(tapGestureRecognizer)
        return view
    }()
    
    private lazy var productInfoView: ProductInfoView = {
        let view = ProductInfoView()
        view.delegate = self
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
    
    private lazy var floatingButtonStackView = createFloatingButtons()
    private lazy var fixedButtonStackView = createFloatingButtons()
    
    private func createFloatingButtons() -> UIStackView {
        let likeButton = UIButton()
        likeButton.backgroundColor = UIColor.Common.white.withAlphaComponent(0.72)
        likeButton.setImage(UIImage(named: "icon_heart_fill"), for: .normal)
        likeButton.translatesAutoresizingMaskIntoConstraints = false
        likeButton.layer.cornerRadius = Constants.FloatingButton.buttonSize / 2
        
        likeButton.layer.shadowColor = UIColor.black.cgColor
        likeButton.layer.shadowOpacity = 0.15
        likeButton.layer.shadowOffset = CGSize(width: 0, height: 2)
        likeButton.tag = 99
        
        NSLayoutConstraint.activate([
            likeButton.widthAnchor.constraint(equalToConstant: Constants.FloatingButton.buttonSize),
            likeButton.heightAnchor.constraint(equalToConstant: Constants.FloatingButton.buttonSize)
        ])
        
        likeButton.addAction(UIAction(handler: { [weak self] _ in
            self?.viewModel.didTapLikeButton()
        }), for: .touchUpInside)
        
        let commentButton = UIButton()
        commentButton.backgroundColor = UIColor.Common.white.withAlphaComponent(0.72)
        commentButton.setImage(UIImage(named: "icon_comment"), for: .normal)
        commentButton.translatesAutoresizingMaskIntoConstraints = false
        commentButton.layer.cornerRadius = Constants.FloatingButton.buttonSize / 2
        
        commentButton.layer.shadowColor = UIColor.black.cgColor
        commentButton.layer.shadowOpacity = 0.15
        commentButton.layer.shadowOffset = CGSize(width: 0, height: 2)
        
        NSLayoutConstraint.activate([
            commentButton.widthAnchor.constraint(equalToConstant: Constants.FloatingButton.buttonSize),
            commentButton.heightAnchor.constraint(equalToConstant: Constants.FloatingButton.buttonSize)
        ])
        commentButton.addAction(UIAction(handler: { [weak self] _ in
            self?.viewModel.didTapCommentButton()
        }), for: .touchUpInside)
        
        let shareButton = UIButton()
        shareButton.backgroundColor = UIColor.Common.white.withAlphaComponent(0.72)
        shareButton.setImage(UIImage(named: "icon_share"), for: .normal)
        shareButton.translatesAutoresizingMaskIntoConstraints = false
        shareButton.layer.cornerRadius = Constants.FloatingButton.buttonSize / 2
        
        shareButton.layer.shadowColor = UIColor.black.cgColor
        shareButton.layer.shadowOpacity = 0.15
        shareButton.layer.shadowOffset = CGSize(width: 0, height: 2)
        shareButton.addAction(UIAction(handler: { [weak self] _ in
            self?.viewModel.didTapShareButton()
        }), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            shareButton.widthAnchor.constraint(equalToConstant: Constants.FloatingButton.buttonSize),
            shareButton.heightAnchor.constraint(equalToConstant: Constants.FloatingButton.buttonSize)
        ])
        
        let moreButton = UIButton()
        moreButton.backgroundColor = UIColor.Common.white.withAlphaComponent(0.72)
        moreButton.setImage(UIImage(named: "icon_more"), for: .normal)
        moreButton.translatesAutoresizingMaskIntoConstraints = false
        moreButton.layer.cornerRadius = Constants.FloatingButton.buttonSize / 2
        
        moreButton.layer.shadowColor = UIColor.black.cgColor
        moreButton.layer.shadowOpacity = 0.15
        moreButton.layer.shadowOffset = CGSize(width: 0, height: 2)
        moreButton.addAction(UIAction(handler: { [weak self] _ in
            self?.viewModel.didTapMoreButton()
        }), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            moreButton.widthAnchor.constraint(equalToConstant: Constants.FloatingButton.buttonSize),
            moreButton.heightAnchor.constraint(equalToConstant: Constants.FloatingButton.buttonSize)
        ])
        
        let stackView = UIStackView(arrangedSubviews: [likeButton, commentButton, shareButton, moreButton])
        stackView.axis = .vertical
        stackView.spacing = Constants.FloatingButton.spacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }
    
    // MARK: - Properties
    
    private var viewModel: ProductDetailViewModel
    private lazy var productCoverDataSource: ProductCoverImageDataSource = ProductCoverImageDataSource(collectionView: coverCollectionView, retrieveHandler: viewModel.imageRetrieveHandler(image:))
    private lazy var recommendationDataSource: RecommendationDataSource = RecommendationDataSource(collectionView: recommendationCollectionView)
    private var floatingButtonStackViewTopContraint: NSLayoutConstraint?
    private var cancellables: Set<AnyCancellable> = .init()
    
    init(viewModel: ProductDetailViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.loadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.viewWillAppear()
    }
    
    override func setupNavigationBar() {
        navigationController?.navigationBar.isHidden = true
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
        scrollView.delegate = self
        
        contentView.addSubview(barTitleLabel)
        NSLayoutConstraint.activate([
            barTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.horizontalMargin),
            barTitleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constants.topMargin),
            barTitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.TitleLabel.trailingMargin)
        ])
        
        contentView.addSubview(barArtistImageView)
        contentView.addSubview(barArtistLabel)
        NSLayoutConstraint.activate([
            barArtistImageView.leadingAnchor.constraint(equalTo: barTitleLabel.leadingAnchor),
            barArtistImageView.topAnchor.constraint(equalTo: barTitleLabel.bottomAnchor, constant: Constants.ArtistView.topMargin),
            barArtistImageView.widthAnchor.constraint(equalToConstant: Constants.ArtistView.imageSize),
            barArtistImageView.heightAnchor.constraint(equalToConstant: Constants.ArtistView.imageSize),
            barArtistLabel.leadingAnchor.constraint(equalTo: barArtistImageView.trailingAnchor, constant: Constants.ArtistView.spacing),
            barArtistLabel.centerYAnchor.constraint(equalTo: barArtistImageView.centerYAnchor)
        ])
        barArtistImageView.layer.cornerRadius = Constants.ArtistView.imageSize / 2
        barArtistImageView.clipsToBounds = true
        
        view.addSubview(closeButton)
        NSLayoutConstraint.activate([
            closeButton.centerYAnchor.constraint(equalTo: view.topAnchor, constant: Constants.closeButtonTopMargin),
            closeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.horizontalMargin)
        ])
        
        contentView.addSubview(coverCollectionView)
        NSLayoutConstraint.activate([
            coverCollectionView.topAnchor.constraint(equalTo: barArtistImageView.bottomAnchor, constant: Constants.CoverImage.topMargin),
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
        recommendationCollectionView.delegate = self
        
        view.addSubview(floatingButtonStackView)
        NSLayoutConstraint.activate([
            floatingButtonStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -Constants.FloatingButton.bottomMargin),
            floatingButtonStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.horizontalMargin)
        ])
        
        contentView.addSubview(fixedButtonStackView)
        NSLayoutConstraint.activate([
            fixedButtonStackView.topAnchor.constraint(equalTo: productInfoView.topAnchor),
            fixedButtonStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.horizontalMargin)
        ])
        fixedButtonStackView.isHidden = true
    }
    
    override func setupBindings() {
        viewModel.productDetailSubject
            .receive(on: DispatchQueue.main)
            .sink { [weak self] data in
                guard let self, let data else { return }
                self.setupData(data: data)
            }
            .store(in: &cancellables)
        
        viewModel.productImages
            .receive(on: DispatchQueue.main)
            .sink { [weak self] images in
                guard let self else { return }
                self.setupDetailImageViews(with: images)
            }
            .store(in: &cancellables)
        
        viewModel.isLikedSubject
            .receive(on: DispatchQueue.main)
            .sink { [weak self] liked in
                guard let self else { return }
                self.updateLikeButton(isLiked: liked)
            }
            .store(in: &cancellables)
        
        viewModel.isFollowingSubject
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isFollowing in
                guard let self else { return }
                self.updateFollowButton(isFollowing: isFollowing)
            }
            .store(in: &cancellables)
        
        viewModel.recommendDataSubject
            .receive(on: DispatchQueue.main)
            .sink { [weak self] data in
                guard let self else { return }
                self.setupRecommendData(data: data)
            }
            .store(in: &cancellables)
    }
    
    private func setupDetailImageViews(with images: [UIImage?]) {
        for image in images {
            if let image {
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
    }
    
    private func setupData(data: ProductDetailModel) {
        let thumbnailUrls = data.thumbnailImageUrls
        pageController.totalCount = thumbnailUrls.count
        productCoverDataSource.apply(thumbnailUrls)
        
        barTitleLabel.text = data.name
        barArtistLabel.text = data.artist.nickname
        
        if let artistImageUrl = data.artist.profileImageUrl {
            let url = URL(string: artistImageUrl)
            barArtistImageView.setImage(with: url)
            artistImageView.setImage(with: url)
        }
        
        productDescriptionLabel.attributedText = viewModel.attributedDescriptionsString(for: data.description)
        artistNameLabel.text = data.artist.nickname
        
        if viewModel.isMine {
            myProfileButton.isHidden = false
            followButton.isHidden = true
            contactButton.isHidden = true
        } else {
            myProfileButton.isHidden = true
            followButton.isHidden = false
            contactButton.isHidden = false
            followButton.backgroundColor = data.artist.following ? Constants.ArtistInfo.followingButtonColor : Constants.ArtistInfo.followButtonColor
        }
        
        productInfoView.viewModel = data
        
        if data.thumbnailImageUrls.count < 2 {
            pageController.isHidden = true
        } else {
            pageController.isHidden = false
        }
    }
    
    private func setupRecommendData(data: ProductDetailRecommendData) {
        let recommendationDic: [RecommendationDataSource.Section: [PlainItem]] = [.artistProduct: data.otherProducts,
                                                                                  .artistExhibition: data.exhibitions,
                                                                                  .similarProduct: data.relatedProducts]
        recommendationDataSource.apply(recommendationDic)
    }
    
    private func updateLikeButton(isLiked: Bool) {
        guard let floatingLikeButton = floatingButtonStackView.arrangedSubviews.first(where: { $0.tag == 99 }) as? UIButton,
              let fixedLikeButton = fixedButtonStackView.arrangedSubviews.first(where: { $0.tag == 99 }) as? UIButton else { return }
        
        let image = isLiked ? UIImage(named: "icon_heart_fill") : UIImage(named: "icon_heart_grey")
        floatingLikeButton.setImage(image, for: .normal)
        fixedLikeButton.setImage(image, for: .normal)
    }
    
    private func updateFollowButton(isFollowing: Bool) {
        let title: String = isFollowing ? "팔로잉" : "팔로우"
        let buttonColor: UIColor = isFollowing ? Constants.ArtistInfo.followingButtonColor : Constants.ArtistInfo.followButtonColor
        followButton.setTitle(title, for: .normal)
        followButton.backgroundColor = buttonColor
    }
}

// MARK: - Tap
private extension ProductDetailViewController {
    @objc
    private func didTapArtistInfoView() {
        viewModel.didTapUserProfile()
    }
}

extension ProductDetailViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.didTapRecommendItem(at: indexPath)
    }
}

// MARK: - CollectionViewLayout
private extension ProductDetailViewController {
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

// MARK: - ScrollViewDelegate
extension ProductDetailViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let scrollViewContentBottomOffset = scrollView.contentOffset.y + UIScreen.main.bounds.height
        let floatingButtonStackViewBottomOffset = fixedButtonStackView.frame.maxY + Constants.FloatingButton.bottomMargin
        let shouldFollow = scrollViewContentBottomOffset < floatingButtonStackViewBottomOffset

        if shouldFollow {
            if floatingButtonStackView.isHidden {
                floatingButtonStackView.isHidden = false
                fixedButtonStackView.isHidden = true
            }
        } else {
            if fixedButtonStackView.isHidden {
                fixedButtonStackView.isHidden = false
                floatingButtonStackView.isHidden = true
            }
        }
        
    }
}

// MARK: - ProductInfoView
extension ProductDetailViewController: ProductInfoViewDelegate {
    func didTapTag(index: Int) {
        viewModel.didTapTag(at: index)
    }
}
