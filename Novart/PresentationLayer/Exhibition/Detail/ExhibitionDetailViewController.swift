//
//  ExhibitionDetailViewController.swift
//  Novart
//
//  Created by Jinwook Huh on 2023/11/03.
//

import UIKit
import Combine

final class ExhibitionDetailViewController: BaseViewController {
    
    private enum Constants {
        static let shortcutViewCornerRadius: CGFloat = 12
        static let endSectionHeight: CGFloat = 552
    }
    
    // MARK: - DataSource
    
    private typealias DataSource = UICollectionViewDiffableDataSource<Section, ExhibitionDetailItem>
    
    enum Section: Int, CaseIterable, Hashable {
        case info
        case art
        case end
    }
    
    // MARK: - UI
    
    private let collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
        collectionView.backgroundColor = .clear
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    private lazy var shortcutView: ExhibitionShortcutView = {
        let view = ExhibitionShortcutView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.roundCorners(cornerRadius: Constants.shortcutViewCornerRadius, maskCorners: [.layerMinXMaxYCorner, .layerMaxXMaxYCorner])
        view.delegate = self
        return view
    }()
    
    // MARK: - Properties
    
    private var viewModel: ExhibitionDetailViewModel
    private lazy var dataSource: DataSource = createDataSource()
    private var cancellables: Set<AnyCancellable> = .init()
    private weak var detailInfoCell: ExhibitionDetailInfoCell?
    private var isShortcutScrolling: Bool = false
    private var artCellInputSubject: PassthroughSubject<(ArtCellInput, Int64), Never> = .init()
    
    enum ArtCellInput {
        case didTapFollowButton(following: Bool)
        case didTapLikeButton(like: Bool)
        case didTapShareButton
        case didTapContactButton
        case didTapCommentButton
        case shouldShowLogin
        case shouldShowProfile
    }
        
    // MARK: - Init
    
    init(viewModel: ExhibitionDetailViewModel) {
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
    
    override func setupNavigationBar() {
        navigationController?.navigationBar.isHidden = false
        title = "전시회"
        
        let commentButton = UIButton()
        commentButton.setBackgroundImage(UIImage(named: "icon_nav_comment"), for: .normal)
        commentButton.addAction(UIAction(handler: { [weak self] _ in
            self?.viewModel.showCommentViewController()
        }), for: .touchUpInside)
        let commentItem = UIBarButtonItem(customView: commentButton)
        navigationItem.rightBarButtonItem = commentItem
        
        let closeButton = UIButton()
        closeButton.setBackgroundImage(UIImage(named: "icon_nav_chevron_down"), for: .normal)
        closeButton.addAction(UIAction(handler: { [weak self] _ in
            self?.viewModel.closeCoordinator()
        }), for: .touchUpInside)
        let closeItem = UIBarButtonItem(customView: closeButton)
        navigationItem.leftBarButtonItem = closeItem
    }
    
    override func setupView() {
        view.backgroundColor = UIColor.Common.white
        
        let safeArea = view.safeAreaLayoutGuide
        
        view.addSubview(collectionView)
        collectionView.setCollectionViewLayout(exhibitionDetailCollectionViewLayout, animated: false)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        collectionView.delegate = self
        
        view.addSubview(shortcutView)
        NSLayoutConstraint.activate([
            shortcutView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            shortcutView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            shortcutView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor)
        ])
        shortcutView.isHidden = true
    }
    
    override func setupBindings() {
        viewModel.detailInfoItemSubject
            .receive(on: DispatchQueue.main)
            .sink { [weak self] item in
                guard let self else { return }
                self.apply(item)
            }
            .store(in: &cancellables)
        
        viewModel.shortcutThumbnailUrlsSubject
            .receive(on: DispatchQueue.main)
            .sink { [weak self] urls in
                guard let self else { return }
                self.shortcutView.setThumbnails(urls: urls)
            }
            .store(in: &cancellables)
        
        artCellInputSubject
            .sink { [weak self] input, id in
                guard let self else { return }
                switch input {
                case let .didTapFollowButton(shouldFollow):
                    self.viewModel.didTapFollowButton(id: id, shouldFollow: shouldFollow)
                case let .didTapLikeButton(shouldLike):
                    self.viewModel.didTapLikeButton(shouldLike: shouldLike)
                case .didTapShareButton:
                    break
                case .didTapCommentButton:
                    self.viewModel.showCommentViewController()
                case .didTapContactButton:
                    self.viewModel.didTapContactButton(userId: id)
                case.shouldShowLogin:
                    self.viewModel.showLoginModal()
                case .shouldShowProfile:
                    self.viewModel.showArtistProfile(userId: id)
                }
            }
            .store(in: &cancellables)
    }
}

// MARK: - CollectionView
private extension ExhibitionDetailViewController {
    private func createDataSource() -> DataSource {
        let infoCellRegistration = UICollectionView.CellRegistration<ExhibitionDetailInfoCell, ExhibitionDetailInfoModel> { [weak self] cell, _, item in
            guard let self else { return }
            self.detailInfoCell = cell
            
            self.detailInfoCell?.exhibitionShortcutViewXOffsetSubject
                .receive(on: DispatchQueue.main)
                .sink(receiveValue: { xOffset in
                    self.shortcutView.contentXOffset = xOffset
                })
                .store(in: &self.cancellables)
            
            self.detailInfoCell?.selectedShorcutIndexSubject
                .receive(on: DispatchQueue.main)
                .sink(receiveValue: { index in
                    self.scrollToExhibition(idx: index)
                })
                .store(in: &self.cancellables)
            
            cell.input = self.artCellInputSubject
            cell.update(with: item)
        }
        
        let artCellRegistration = UICollectionView.CellRegistration<ExhibitionArtCell, ExhibitionArtItem> { [weak self] cell, _, item in
            guard let self else { return }
            cell.input = self.artCellInputSubject
            cell.update(with: item)
        }
        
        let endCellRegistration = UICollectionView.CellRegistration<ExhibitionEndCell, ExhibitionEndItem> { [weak self] cell, _, item in
            guard let self else { return }
            cell.input = self.artCellInputSubject
            cell.update(with: item)
        }
        
        
        return DataSource(collectionView: collectionView) { collectionView, indexPath, itemIdentifier in
            switch itemIdentifier {
            case let exhibitionDetailInfoItem as ExhibitionDetailInfoModel:
                return collectionView.dequeueConfiguredReusableCell(using: infoCellRegistration, for: indexPath, item: exhibitionDetailInfoItem)
                
            case let exhibitionArtItem as ExhibitionArtItem:
                return collectionView.dequeueConfiguredReusableCell(using: artCellRegistration, for: indexPath, item: exhibitionArtItem)
            case let exhibitionEndItem as ExhibitionEndItem:
                return collectionView.dequeueConfiguredReusableCell(using: endCellRegistration, for: indexPath, item: exhibitionEndItem)
            default:
                return nil
            }
        }
    }
    
    func apply(_ items: [Section: [ExhibitionDetailItem]]) {
        var snapshot = dataSource.snapshot()
        snapshot.appendSections([.info])
        snapshot.appendItems(items[.info] ?? [], toSection: .info)
        snapshot.appendSections([.art])
        snapshot.appendItems(items[.art] ?? [], toSection: .art)
        snapshot.appendSections([.end])
        snapshot.appendItems(items[.end] ?? [], toSection: .end)
        dataSource.apply(snapshot, animatingDifferences: false)
    }
    
    private func scrollToExhibition(idx: Int) {
        let indexPath = IndexPath(item: idx, section: 1)
        collectionView.scrollToItem(at: indexPath, at: .top, animated: true)

    }
}

// MARK: - CollectionViewLayout
private extension ExhibitionDetailViewController {
    var infoSectionLayout: NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(1.0))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        return section
    }
    
    var artSectionLayout: NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(1.0))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        return section
    }
    
    var endSectionLayout: NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(Constants.endSectionHeight))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(Constants.endSectionHeight))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets.bottom = -view.safeAreaInsets.bottom
        return section
    }
    
    
    var exhibitionDetailCollectionViewLayout: UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { [weak self] (sectionIndex: Int, layoutEnv: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            
            guard let self else { return nil }
            let section = self.dataSource.snapshot().sectionIdentifiers[sectionIndex]
            switch section {
                
            case .info:
                return self.infoSectionLayout
            case .art:
                return self.artSectionLayout
                
            case .end:
                return self.endSectionLayout
            }
        }
        
        return layout
    }
}

// MARK: - ScrollViewDelegate
extension ExhibitionDetailViewController: UICollectionViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let detailInfoCell else { return }
        collectionView.convert(detailInfoCell.frame, to: self.view)
        let shortcutViewBottomOffset = collectionView.convert(detailInfoCell.frame, to: self.view).maxY
        let fixedShortcutViewBottomOffset = shortcutView.frame.maxY

        let shouldShowFixedView = shortcutViewBottomOffset < fixedShortcutViewBottomOffset
        
        if shouldShowFixedView {
            if shortcutView.isHidden {
                shortcutView.isHidden = false
            }
        } else {
            if !shortcutView.isHidden {
                shortcutView.isHidden = true
            }
        }
        
        guard !isShortcutScrolling else { return }
        
        let visibleRect = CGRect(origin: collectionView.contentOffset, size: collectionView.bounds.size)
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.minY + shortcutView.bounds.height)
        guard let indexPath = collectionView.indexPathForItem(at: visiblePoint),
              indexPath.section == 1 else { return }
        
        shortcutView.setSelected(at: indexPath.row)
        
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        if isShortcutScrolling {
            isShortcutScrolling = false
        }
    }
}

extension ExhibitionDetailViewController: ExhibitionShortcutViewDelegate {
    func exhibitionShortcutViewDidScroll(scrollView: UIScrollView) {
        let contentXOffset = scrollView.contentOffset.x
        detailInfoCell?.shortcutViewXOffset = contentXOffset
    }
    
    func exhibitionShortcutViewDidSelectIndexAt(index: Int) {
        isShortcutScrolling = true
        scrollToExhibition(idx: index)
    }
}
