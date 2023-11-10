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
        static let selectedColor: UIColor = UIColor.Common.grey04
        static let font: UIFont = .systemFont(ofSize: 16, weight: .medium)
        static let textColor: UIColor = UIColor.Common.grey04
        static let selectedTextColor: UIColor = UIColor.Common.white
        static let height: CGFloat = 32
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
    func update(with item: TagItem, cellMaxWidth: CGFloat) {
        self.cellMaxWidth = cellMaxWidth
        titleLabel.text = item.tag
        
        if item.isSelected {
            contentView.backgroundColor = Constants.selectedColor
            titleLabel.textColor = Constants.selectedTextColor
        } else {
            contentView.backgroundColor = Constants.color
            titleLabel.textColor = Constants.textColor
        }
    }
}
