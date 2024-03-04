//
//  TagView.swift
//  Novart
//
//  Created by Jinwook Huh on 2023/11/06.
//

import UIKit
import Combine

protocol TagViewDelegate: AnyObject {
    func tagView(_ tagView: TagView, didSelectItemAt indexPath: IndexPath)
    func tagView(_ tagView: TagView, didDeselectItemAt indexPath: IndexPath)
    func invalidateLayout(_ tagView: TagView, contentHeight: CGFloat)
    func tagView(_ tagView: TagView, shouldSelectItemAt indexPath: IndexPath) -> Bool
    func tagView(_ tagView: TagView, shouldDeselectItemAt indexPath: IndexPath) -> Bool
}

extension TagViewDelegate {
    func tagView(_ tagView: TagView, didSelectItemAt indexPath: IndexPath) {}
    func tagView(_ tagView: TagView, didDeselectItemAt indexPath: IndexPath) {}
    func tagView(_ tagView: TagView, shouldSelectItemAt indexPath: IndexPath) -> Bool { return true }
    func tagView(_ tagView: TagView, shouldDeselectItemAt indexPath: IndexPath) -> Bool { return true }
}

final class TagView: UIView {
    typealias TagDataSource = UICollectionViewDiffableDataSource<Int, TagItem.ID>
    typealias TagSnapshot = NSDiffableDataSourceSnapshot<Int, TagItem.ID>
    
    private lazy var collectionView: UICollectionView = {
        let layout = TagCollectionLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.allowsMultipleSelection = true
        collectionView.alwaysBounceVertical = true
        collectionView.alwaysBounceHorizontal = true
        collectionView.backgroundColor = .clear
        collectionView.isScrollEnabled = false
        collectionView.delegate = self
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    private var cancellables: Set<AnyCancellable> = .init()
    private lazy var dataSource = createDataSource()
    private var viewModel: TagViewModel = TagViewModel()
    
    weak var delegate: TagViewDelegate?
    var isSelectable: Bool = true
    
    func contentHeight() -> CGFloat {
        collectionView.contentSize.height
    }
    
    func selectItems(indexes: [Int]) {
        for index in indexes {
            collectionView.selectItem(at: .init(row: index, section: 0), animated: false, scrollPosition: .centeredVertically)
        }
    }
    
    init() {
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: self.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
}

extension TagView {
    func createDataSource() -> TagDataSource {
        let cellRegistration = UICollectionView.CellRegistration<TagCell, TagItem> { _, _, _ in }
        
        let dataSource = TagDataSource(collectionView: collectionView) { [weak self] collectionView, indexPath, itemIdentifier in
            guard let self, let item = self.viewModel.item(with: itemIdentifier) else {
                return UICollectionViewCell()
            }
            let cell = collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: item)
            let cellMaxwidth = collectionView.frame.width
            cell.update(with: item, cellMaxWidth: cellMaxwidth, isSelectable: isSelectable)
            if item.isSelected {
                collectionView.selectItem(at: indexPath, animated: false, scrollPosition: .init())
            }
            return cell
        }
        
        return dataSource
    }
    
    func applyItems(_ items: [TagItem], completion: (() -> Void)? = nil) {
        viewModel.setTagItems(items)
        var prevSnapshot = dataSource.snapshot()
        prevSnapshot.deleteAllItems()
        dataSource.apply(prevSnapshot)
        
        var snaphot = TagSnapshot()
        snaphot.appendSections([.zero])
        snaphot.appendItems(viewModel.tagIDs())
        dataSource.apply(snaphot, animatingDifferences: false) { [weak self] in
            self?.reloadCollectionLayout()
            completion?()
        }
    }
    
    func reloadCollectionLayout() {
        collectionView.collectionViewLayout.invalidateLayout()
        delegate?.invalidateLayout(self, contentHeight: contentHeight())
    }
    
}

extension TagView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = viewModel.items()[indexPath.row]
        let updatedItem = TagItem(id: item.id, tag: item.tag, isSelected: true)
        
        viewModel.update(updatedItem)
        delegate?.tagView(self, didSelectItemAt: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let item = viewModel.items()[indexPath.row]
        let updatedItem = TagItem(id: item.id, tag: item.tag, isSelected: false)
        
        viewModel.update(updatedItem)
        delegate?.tagView(self, didDeselectItemAt: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        guard let delegate else { return true }
        return delegate.tagView(self, shouldSelectItemAt: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldDeselectItemAt indexPath: IndexPath) -> Bool {
        guard let delegate else { return true }
        return delegate.tagView(self, shouldDeselectItemAt: indexPath)
    }
}
