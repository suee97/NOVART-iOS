//
//  FilterMenuCell.swift
//  Novart
//
//  Created by Jinwook Huh on 2023/09/08.
//

import UIKit

class FilterMenuCell: UITableViewCell {

    // MARK: - Constants
    
    private enum Constants {
        static let leadingMargin: CGFloat = 16
        static let font: UIFont = .systemFont(ofSize: 16, weight: .regular)
        static let color: UIColor = UIColor.Common.grey04
        static let selectedFont: UIFont = .systemFont(ofSize: 16, weight: .bold)
        static let selectedColor: UIColor = UIColor.Common.main
    }
    
    // MARK: - UI
    
    private lazy var filterLabel: UILabel = {
        let label = UILabel()
        label.font = Constants.font
        label.textColor = Constants.color
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var isSelected: Bool {
        didSet {
            filterLabel.textColor = isSelected ? Constants.selectedColor : Constants.color
            filterLabel.font = isSelected ? Constants.selectedFont : Constants.font
        }
    }
    
    private func setupView() {
        backgroundColor = .clear
        selectionStyle = .none
        contentView.addSubview(filterLabel)
        NSLayoutConstraint.activate([
            filterLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.leadingMargin),
            filterLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            filterLabel.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor)
        ])
    }
    
    func update(with type: CategoryType) {
        filterLabel.text = type.rawValue

        
    }
}
