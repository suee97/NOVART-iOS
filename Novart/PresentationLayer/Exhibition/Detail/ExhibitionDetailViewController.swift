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
        return view
    }()
    
    // MARK: - Properties
    
    private var viewModel: ExhibitionDetailViewModel
    private lazy var dataSource: DataSource = createDataSource()
    private var cancellables: Set<AnyCancellable> = .init()
    
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
        
        view.addSubview(shortcutView)
        NSLayoutConstraint.activate([
            shortcutView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            shortcutView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            shortcutView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor)
        ])
    }
    
    override func setupBindings() {
        viewModel.detailInfoItemSubject
            .receive(on: DispatchQueue.main)
            .sink { [weak self] item in
                self?.apply(item)
            }
            .store(in: &cancellables)
    }
    

}

// MARK: - CollectionView
private extension ExhibitionDetailViewController {
    private func createDataSource() -> DataSource {
        let infoCellRegistration = UICollectionView.CellRegistration<ExhibitionDetailInfoCell, ExhibitionDetailInfoModel> { cell, _, item in
            cell.update(with: item)
        }
        
        let artCellRegistration = UICollectionView.CellRegistration<ExhibitionArtCell, ExhibitionArtItem> { cell, _, item in
            cell.update(with: item)
        }
        
        let endCellRegistration = UICollectionView.CellRegistration<ExhibitionEndCell, ExhibitionEndItem> { cell, _, item in
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
        snapshot.deleteSections(Section.allCases)
        dataSource.apply(snapshot, animatingDifferences: false)
        
        snapshot.appendSections([.info])
        snapshot.appendItems(items[.info] ?? [], toSection: .info)
        snapshot.appendSections([.art])
        snapshot.appendItems(items[.art] ?? [], toSection: .art)
        snapshot.appendSections([.end])
        snapshot.appendItems(items[.end] ?? [], toSection: .end)
        dataSource.apply(snapshot, animatingDifferences: false)
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
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(1.0))
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

