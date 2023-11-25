//
//  TagCell.swift
//  Novart
//
//  Created by Jinwook Huh on 2023/11/07.
//

import UIKit

final class TagCell: UICollectionViewCell {
    
    enum Constants {
        static let color: UIColor = UIColor.Common.grey00
        static let selectedColor: UIColor = UIColor.Common.main
        static let font: UIFont = .systemFont(ofSize: 16, weight: .regular)
        static let selectedFont: UIFont = .systemFont(ofSize: 16, weight: .semibold)
        static let textColor: UIColor = UIColor.Common.grey04
        static let selectedTextColor: UIColor = UIColor.Common.white
        static let height: CGFloat = 36
        static let inset: CGFloat = 12
    }
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = Constants.textColor
        label.font = Constants.font
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var cellMaxWidth: CGFloat = Constants.inset * 2 {
        didSet {
            if oldValue != cellMaxWidth {
                labelWidthConstraint?.constant = cellMaxWidth - Constants.inset * 2
                layoutIfNeeded()
            }
        }
    }
    
    override var isSelected: Bool {
        didSet {
            if isSelectable {
                contentView.backgroundColor = isSelected ? Constants.selectedColor : Constants.color
                titleLabel.textColor = isSelected ? Constants.selectedTextColor : Constants.textColor
                titleLabel.font = isSelected ? Constants.selectedFont : Constants.font
            }
        }
    }
    
    private var isSelectable: Bool = false
    
    private var labelWidthConstraint: NSLayoutConstraint?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSubviews() {
        contentView.backgroundColor = Constants.color
        contentView.layer.cornerRadius = Constants.height / 2
        contentView.clipsToBounds = true
        contentView.addSubview(titleLabel)
        
        labelWidthConstraint = titleLabel.widthAnchor.constraint(lessThanOrEqualToConstant: 0)
        labelWidthConstraint?.isActive = true
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.inset),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.inset),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            contentView.heightAnchor.constraint(equalToConstant: Constants.height)
        ])
        
    }
}

extension TagCell {
    func update(with item: TagItem, cellMaxWidth: CGFloat, isSelectable: Bool) {
        self.isSelectable = isSelectable
        self.cellMaxWidth = cellMaxWidth
        self.isSelected = item.isSelected
        titleLabel.text = item.tag
    }
}
