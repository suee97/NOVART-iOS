//
//  FilterMenuView.swift
//  Novart
//
//  Created by Jinwook Huh on 2023/09/08.
//

import UIKit



final class FilterMenuView: UIView {
    
    // MARK: - Constants
    
    private enum Constants {
        static let width: CGFloat = 118
        static let itemHeight: CGFloat = 38
        static let cornerRadius: CGFloat = 12
        static let topInset: CGFloat = 8
        static let bottomInset: CGFloat = 8
        static let menuBackgroundColor: UIColor = UIColor.Common.white
        
        enum Shadow {
            static let color: CGColor = UIColor.black.withAlphaComponent(0.25).cgColor
            static let radius: CGFloat = 4
            static let offset: CGSize = CGSize(width: 0, height: 4)
            static let opacity: Float = 1
        }
    }
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(FilterMenuCell.self, forCellReuseIdentifier: FilterMenuCell.reuseIdentifier)
        tableView.separatorStyle = .none
        tableView.contentInset = UIEdgeInsets(top: Constants.topInset, left: 0, bottom: Constants.bottomInset, right: 0)
        tableView.tag = 999
        tableView.isScrollEnabled = false
        tableView.backgroundColor = Constants.menuBackgroundColor
        return tableView
    }()
    
    // MARK: - Properties
    let anchorPosition: CGPoint
    let filterTypes: [CategoryType]
    weak var delegate: FilterMenuViewDelegate?
    weak var senderDelegate: FilterMenuViewSendable?
    
    // MARK: - Initialization

    init(filterTypes: [CategoryType], anchorPosition: CGPoint) {
        self.anchorPosition = anchorPosition
        self.filterTypes = filterTypes
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        guard let touch = touches.first else { return }

        if touch.view?.tag != 999 {
            senderDelegate?.didHideMenu()
            removeFromSuperview()
        }
    }
    
    private func setupView() {
        backgroundColor = .clear
        addSubview(tableView)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.frame = CGRect(
            x: anchorPosition.x,
            y: anchorPosition.y - (Constants.itemHeight * CGFloat(filterTypes.count) + Constants.topInset + Constants.bottomInset),
            width: Constants.width,
            height: Constants.itemHeight * CGFloat(filterTypes.count) + Constants.topInset + Constants.bottomInset)
        tableView.layer.cornerRadius = Constants.cornerRadius
        layer.shadowColor = Constants.Shadow.color
        layer.shadowOffset = Constants.Shadow.offset
        layer.shadowRadius = Constants.Shadow.radius
        layer.shadowOpacity = Constants.Shadow.opacity
        
        tableView.reloadData()
        tableView.selectRow(at: IndexPath(row: 0, section: 0), animated: false, scrollPosition: .none)
    }
}

extension FilterMenuView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        Constants.itemHeight
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? FilterMenuCell {
            cell.isSelected = false
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? FilterMenuCell {
            cell.isSelected = true
        }
        let selectedCategory = filterTypes[indexPath.row]
        delegate?.didTapRowAt(menuView: self, category: selectedCategory)
    }
}

extension FilterMenuView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filterTypes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FilterMenuCell.reuseIdentifier, for: indexPath) as? FilterMenuCell else { return UITableViewCell() }
        cell.update(with: filterTypes[indexPath.row])
        return cell
    }
}
