import UIKit
import SnapKit
import Combine

final class ExhibitionViewController: BaseViewController {
    
    // MARK: - Constants
    private enum Constants {
        static let screenWidth: CGFloat = UIScreen.main.bounds.width
        static let leftMargin: CGFloat = 24
        static let rightMargin: CGFloat = 24
        static let animateDuration: CGFloat = 0.2
        
        enum CollectionView {
            static let itemWidth: CGFloat = Constants.screenWidth - (Constants.leftMargin + Constants.rightMargin)
            static let itemHeight: CGFloat = Constants.CollectionView.itemWidth * (616/342)
            static let groupSpacing: CGFloat = 16
            
            static let topMargin: CGFloat = 8
            static let height: CGFloat = Constants.CollectionView.itemHeight
        }
        
        enum PageControl {
            static let currentIndicatorColor = UIColor.Common.warmBlack
            static let indicatorColor = UIColor.Common.warmBlack.withAlphaComponent(0.2)
            static let transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
            
            static let topMargin: CGFloat = 12
            static let height: CGFloat = 4
        }
        
        enum ButtonsView {
            static let topMargin: CGFloat = 20
            static let height: CGFloat = 36
        }
    }
    
    
    // MARK: - Properties
    private let viewModel: ExhibitionViewModel
    private var cancellables = Set<AnyCancellable>()
    private let exhibitionMainDataSource: ExhibitionMainDataSource
    
    
    // MARK: - LifeCycle
    init(viewModel: ExhibitionViewModel) {
        self.viewModel = viewModel
        self.exhibitionMainDataSource = ExhibitionMainDataSource(collectionView: collectionView)
        super.init()
        setupCollectionView()
        viewModel.fetchExhibitions()
    }
    
    required init? (coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
        viewModel.fetchExhibitions()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isNavigationBarHidden = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.cellIndex = viewModel.cellIndex
    }
    
    
    // MARK: - Binding
    override func setupBindings() {
        viewModel.$processedExhibitions
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] items in
                guard let self else { return }
                self.exhibitionMainDataSource.apply(items)
                self.pageControl.numberOfPages = items.count
            })
            .store(in: &cancellables)
        
        viewModel.$cellIndex.sink(receiveValue: { [weak self] cellIndex in
            guard let self, let cellIndex else { return }
            self.pageControl.currentPage = cellIndex
            
            // 배경 색상 변경
            UIView.animate(withDuration: Constants.animateDuration, animations: {
                self.view.backgroundColor = self.viewModel.processedExhibitions[cellIndex].backgroundColor
            })
            
            // 투명도 변경
            if let visibleCells = self.collectionView.visibleCells as? [ExhibitionCell],
               let currentCell = self.collectionView.cellForItem(at: [0, cellIndex]) as? ExhibitionCell {
                visibleCells.forEach({
                    $0.container.layer.opacity = 0.8
                })
                currentCell.container.layer.opacity = 1.0
            }
            
        }).store(in: &cancellables)
    }
    
    
    // MARK: - UI
    private let collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.bounces = false
        collectionView.backgroundColor = .clear
        collectionView.clipsToBounds = false
        return collectionView
    }()
    
    private lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.numberOfPages = 0
        pageControl.currentPage = 0
        pageControl.pageIndicatorTintColor = Constants.PageControl.indicatorColor
        pageControl.currentPageIndicatorTintColor = Constants.PageControl.currentIndicatorColor
        pageControl.transform = Constants.PageControl.transform // indicator 크기
        return pageControl
    }()
    
    private lazy var buttonsView = ExhibitionButtonsView(viewModel: viewModel)
    
    override func setupView() {
        view.backgroundColor = UIColor.Common.defaultGrey
        
        view.addSubview(collectionView)
        view.addSubview(pageControl)
        view.addSubview(buttonsView)
        
        collectionView.snp.makeConstraints({ m in
            m.left.right.equalToSuperview()
            m.top.equalTo(view.safeAreaLayoutGuide).inset(Constants.CollectionView.topMargin)
            m.height.equalTo(Constants.CollectionView.height)
        })
        
        pageControl.snp.makeConstraints({ m in
            m.centerX.equalToSuperview()
            m.top.equalTo(collectionView.snp.bottom).offset(Constants.PageControl.topMargin)
            m.height.equalTo(Constants.PageControl.height)
            m.width.equalToSuperview()
        })
        
        buttonsView.snp.makeConstraints({ m in
            m.left.right.equalToSuperview()
            m.top.equalTo(pageControl.snp.bottom).offset(Constants.ButtonsView.topMargin)
            m.height.equalTo(Constants.ButtonsView.height)
        })
        buttonsView.delegate = self
    }
}


// MARK: - CollectionView
extension ExhibitionViewController: UICollectionViewDelegate {
    private func createCollectionViewLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .absolute(Constants.CollectionView.itemWidth),
            heightDimension: .absolute(Constants.CollectionView.itemHeight)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .absolute(Constants.CollectionView.itemWidth),
            heightDimension: .absolute(Constants.CollectionView.itemHeight)
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPagingCentered
        section.interGroupSpacing = Constants.CollectionView.groupSpacing
        
        
        /* reference https://stackoverflow.com/questions/18649920/uicollectionview-current-visible-cell-index
        */
        section.visibleItemsInvalidationHandler = { [weak self] visibleItems, point, env in
            
            // 좌우로 cell 스크롤 시 viewModel.cellIndex 변경
            guard let self = self else { return }
            let visibleRect = CGRect(origin: collectionView.contentOffset, size: collectionView.bounds.size)
            let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
            let visibleIndexPath = collectionView.indexPathForItem(at: visiblePoint)
            if let index = visibleIndexPath?.row,
               !self.viewModel.processedExhibitions.isEmpty {
                self.viewModel.cellIndex = index
            }
        }
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        
        return layout
    }
    
    private func setupCollectionView() {
        collectionView.setCollectionViewLayout(createCollectionViewLayout(), animated: false)
        collectionView.delegate = self
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        viewModel.cellIndex = viewModel.cellIndex
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard !viewModel.processedExhibitions.isEmpty else { return }
        let exhibition = viewModel.processedExhibitions[indexPath.row]
        viewModel.showExhibitionDetail(exhibitionId: Int64(exhibition.id))
    }
}

extension ExhibitionViewController: ExhibitionButtonsViewDelegate {
    func didTapLikeButton(shouldLike: Bool) {
        viewModel.didTapLikeButton(shouldLike: shouldLike)
    }
    
    func didTapCommentButton() {
        viewModel.didTapCommentButton()
    }
    
    func shouldShowLogin() {
        viewModel.presentLoginModal()
    }
    
    func didTapShareButton() {
        viewModel.didTapShareButton()
    }
    
    func didTapGuideButton() {
        viewModel.showExhibitionGuide()
    }
}
