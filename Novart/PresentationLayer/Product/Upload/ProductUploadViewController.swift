//
//  ProductUploadViewController.swift
//  Novart
//
//  Created by Jinwook Huh on 2023/12/10.
//

import UIKit
import Combine

final class ProductUploadViewController: BaseViewController, MediaPickerPresentable {
    
    // MARK: - DataSource
    
    private typealias CoverDataSource = UICollectionViewDiffableDataSource<Section, UploadMediaItem>
    private typealias DetailDataSource = UICollectionViewDiffableDataSource<Section, UploadMediaItem>

    enum Section: Int, CaseIterable, Hashable {
        case image
    }
    
    // MARK: - Constants
    
    private enum Constants {
        static let topMargin: CGFloat = 16
        static let horizontalMargin: CGFloat = 24
        static let screenWidth: CGFloat = UIScreen.main.bounds.width

        enum NextButton {
            static let font: UIFont = .systemFont(ofSize: 16, weight: .medium)
            static let textColor: UIColor = UIColor.Common.main
            static let disabledColor: UIColor = UIColor.Common.grey02
        }
        
        enum Title {
            static let font: UIFont = .systemFont(ofSize: 16, weight: .semibold)
            static let textColor: UIColor = UIColor.Common.grey03
            static let subtitleFont: UIFont = .systemFont(ofSize: 16, weight: .medium)
            static let subtitleColor: UIColor = UIColor.Common.black
            static let imageCountFont: UIFont = .systemFont(ofSize: 12, weight: .regular)
            static let spacing: CGFloat = 8
        }
        
        enum AddImage {
            static let topMargin: CGFloat = 20
            static let backgroundColor: UIColor = UIColor.Common.grey00
            static let textColor: UIColor = UIColor.Common.grey04
            static let font: UIFont = UIFont.systemFont(ofSize: 16, weight: .bold)
            static let cornerRadius: CGFloat = 12
            static let height: CGFloat = 54
            static let bottomMargin: CGFloat = 16
            static let coverText: String = "표지 추가하기+"
            static let coverTitle: String = "작품 표지*"
            static let coverDescription: String = "3장까지 표지로 등록이 가능하며,\n첫번째 이미지가 대표 표지로 활용돼요"
            static let detailText: String = "상세이미지 추가하기+"
            static let detailTitle: String = "작품 상세이미지*"
            static let detailDescription: String = "작품을 잘 나타내는 여러 이미지를 추가해 보세요"
        }
        
        enum CollectionView {
            static let spacing: CGFloat = 12
            static let detailSpacing: CGFloat = 8
            static let size: CGFloat = (screenWidth - spacing * 2 - horizontalMargin * 2) / 3
        }
        
    }
    
    // MARK: - UI
    
    private lazy var nextButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = Constants.NextButton.font
        button.setTitle("다음", for: .normal)
        button.setTitleColor(Constants.NextButton.textColor, for: .normal)
        button.setTitleColor(Constants.NextButton.disabledColor, for: .disabled)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.addAction(UIAction(handler: { [weak self] _ in
            guard let self else { return }
            switch self.viewModel.step {
            case .cover:
                self.viewModel.moveToDetailImageUpload()
            case .detail:
                self.viewModel.moveToDetailInfoUpload()
            }
        }), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var productCoverLabel: UILabel = {
        let label = UILabel()
        label.font = Constants.Title.font
        label.textColor = Constants.Title.textColor
        label.text = viewModel.step == .cover ? Constants.AddImage.coverTitle : Constants.AddImage.detailTitle
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = Constants.Title.subtitleFont
        label.textColor = Constants.Title.subtitleColor
        label.numberOfLines = 2
        label.text = viewModel.step == .cover ? Constants.AddImage.coverDescription : Constants.AddImage.detailDescription
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let imageCountLabel: UILabel = {
        let label = UILabel()
        label.font = Constants.Title.imageCountFont
        label.textColor = Constants.Title.textColor
        label.text = "0/3"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var addImageButton: UIButton = {
        let button = UIButton()
        let title = viewModel.step == .cover ? Constants.AddImage.coverText : Constants.AddImage.detailText
        button.setTitle(title, for: .normal)
        button.setTitleColor(Constants.AddImage.textColor, for: .normal)
        button.titleLabel?.font = Constants.AddImage.font
        button.backgroundColor = Constants.AddImage.backgroundColor
        button.layer.cornerRadius = Constants.AddImage.cornerRadius
        button.clipsToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.addAction(UIAction(handler: { [weak self] _ in
            self?.viewModel.showMediaPicker()
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
    
    private lazy var detailCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .clear
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    // MARK: - Properties

    private var viewModel: ProductUploadViewModel
    private lazy var coverDataSource: CoverDataSource = createCoverDataSource()
    private lazy var detailDataSource: DetailDataSource = createDetailDataSource()
    var mediaPicker: MediaPickerController = MediaPickerController()
    private var cancellables: Set<AnyCancellable> = .init()
    
    // MARK: - Init
    
    init(viewModel: ProductUploadViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.setAsMediaPresenter(viewController: self)
        updateNavButtonState()
    }
    
    override func setupNavigationBar() {
        
        let closeButton = UIButton()
        closeButton.setBackgroundImage(UIImage(named: "icon_nav_chevron_left"), for: .normal)
        closeButton.addAction(UIAction(handler: { [weak self] _ in
            guard let self else { return }
            switch self.viewModel.step {
            case .cover:
                self.viewModel.closeCoordinator()
            case .detail:
                self.navigationController?.popViewController(animated: true)
            }
        }), for: .touchUpInside)
        let closeItem = UIBarButtonItem(customView: closeButton)
        navigationItem.leftBarButtonItem = closeItem
        
        let nextItem = UIBarButtonItem(customView: nextButton)
        navigationItem.rightBarButtonItem = nextItem
        
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        
        title = "작품 등록"
        nextButton.isEnabled = false
    }
    
    override func setupView() {
        view.backgroundColor = .white
        
        let safeArea = view.safeAreaLayoutGuide
        view.addSubview(productCoverLabel)
        view.addSubview(descriptionLabel)
        view.addSubview(imageCountLabel)
        
        NSLayoutConstraint.activate([
            productCoverLabel.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: Constants.topMargin),
            productCoverLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: Constants.horizontalMargin),
            imageCountLabel.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -Constants.horizontalMargin),
            imageCountLabel.centerYAnchor.constraint(equalTo: productCoverLabel.centerYAnchor),
            descriptionLabel.topAnchor.constraint(equalTo: productCoverLabel.bottomAnchor, constant: Constants.Title.spacing),
            descriptionLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: Constants.horizontalMargin)
        ])
        
        imageCountLabel.isHidden = viewModel.step == .detail
        
        view.addSubview(addImageButton)
        NSLayoutConstraint.activate([
            addImageButton.heightAnchor.constraint(equalToConstant: Constants.AddImage.height),
            addImageButton.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: Constants.AddImage.topMargin),
            addImageButton.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: Constants.horizontalMargin),
            addImageButton.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -Constants.horizontalMargin)
        ])
        
        if viewModel.step == .cover {
            view.addSubview(coverCollectionView)
            coverCollectionView.setCollectionViewLayout(coverImageLayout, animated: false)
            NSLayoutConstraint.activate([
                coverCollectionView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: Constants.horizontalMargin),
                coverCollectionView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -Constants.horizontalMargin),
                coverCollectionView.topAnchor.constraint(equalTo: addImageButton.bottomAnchor, constant: Constants.AddImage.bottomMargin),
                coverCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
        } else {
            view.addSubview(detailCollectionView)
            detailCollectionView.setCollectionViewLayout(detailImageLayout, animated: false)
            NSLayoutConstraint.activate([
                detailCollectionView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
                detailCollectionView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
                detailCollectionView.topAnchor.constraint(equalTo: addImageButton.bottomAnchor, constant: Constants.AddImage.bottomMargin),
                detailCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
        }
    }
    
    override func setupBindings() {
        switch viewModel.step {
        case .cover:
            viewModel.$selectedCoverImages
                .receive(on: DispatchQueue.main)
                .sink { [weak self] media in
                    guard let self else { return }
                    self.imageCountLabel.text = "\(media.count)/3"
                    self.nextButton.isEnabled = !media.isEmpty
                    self.applyCoverDataSource(media)
                }
                .store(in: &cancellables)
            
        case .detail:
            viewModel.$selectedDetailImages
                .receive(on: DispatchQueue.main)
                .sink { [weak self] images in
                    guard let self else { return }
                    self.applyDetailDataSource(images)
                    self.nextButton.isEnabled = !images.isEmpty
                }
                .store(in: &cancellables)
        }
        viewModel.$isNextEnabled
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isEnabled in
                guard let self else { return }
                self.nextButton.isEnabled = isEnabled
            }
            .store(in: &cancellables)
    }
    
    private func updateNavButtonState() {
        nextButton.isEnabled = viewModel.isNextEnabled
    }
}

// MARK: - CollectionView
private extension ProductUploadViewController {
    private func createCoverDataSource() -> CoverDataSource {
        
        let uploadMediaCoverCellRegistration = UICollectionView.CellRegistration<UploadMediaCoverCell, UploadMediaItem> { [weak self] cell, _, item in
            guard let self else { return }
            cell.delegate = self
            cell.update(with: item)
        }
        
        return CoverDataSource(collectionView: coverCollectionView) { collectionView, indexPath, itemIdentifier in
            return collectionView.dequeueConfiguredReusableCell(using: uploadMediaCoverCellRegistration, for: indexPath, item: itemIdentifier)
        }
    }

    func applyCoverDataSource(_ items: [UploadMediaItem]) {
        var snapshot = coverDataSource.snapshot()
        snapshot.deleteSections(Section.allCases)
        coverDataSource.apply(snapshot, animatingDifferences: false)
        
        snapshot.appendSections([.image])
        snapshot.appendItems(items, toSection: .image)
        coverDataSource.apply(snapshot, animatingDifferences: false)
    }
    
    private func createDetailDataSource() -> DetailDataSource {
        
        let uploadMediaDetailCellRegistration = UICollectionView.CellRegistration<UploadMediaDetailCell, UploadMediaItem> { [weak self] cell, _, item in
            guard let self else { return }
            cell.delegate = self
            cell.update(with: item)
        }
        
        return DetailDataSource(collectionView: detailCollectionView) { collectionView, indexPath, itemIdentifier in
            return collectionView.dequeueConfiguredReusableCell(using: uploadMediaDetailCellRegistration, for: indexPath, item: itemIdentifier)
        }
    }

    func applyDetailDataSource(_ items: [UploadMediaItem]) {
        var snapshot = detailDataSource.snapshot()
        snapshot.deleteSections(Section.allCases)
        detailDataSource.apply(snapshot, animatingDifferences: false)
        
        snapshot.appendSections([.image])
        snapshot.appendItems(items, toSection: .image)
        detailDataSource.apply(snapshot, animatingDifferences: false)
    }
    
    var coverSectionLayout: NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(Constants.CollectionView.size), heightDimension: .absolute(Constants.CollectionView.size))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(Constants.CollectionView.size))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.interItemSpacing = NSCollectionLayoutSpacing.fixed(Constants.CollectionView.spacing)
        
        let section = NSCollectionLayoutSection(group: group)
        return section
    }
    
    var coverImageLayout: UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { [weak self] (sectionIndex: Int, layoutEnv: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            return self?.coverSectionLayout
        }
        return layout
    }
    
    var deatilSectionLayout: NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(100))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(100))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = Constants.CollectionView.detailSpacing
        return section
    }
    
    var detailImageLayout: UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { [weak self] (sectionIndex: Int, layoutEnv: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            return self?.deatilSectionLayout
        }
        return layout
    }
}

// MARK: - Cell Action
extension ProductUploadViewController: UploadCellActionDelegate {
    func didTapDeleteButton(identifier: String) {
        viewModel.removeItem(identifier: identifier)
    }
    
    func didTapCropButton(identifier: String) {
        viewModel.showImageEditScene()
    }
}

