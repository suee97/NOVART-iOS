//
//  TagCell.swift
//  Novart
//
//  Created by Jinwook Huh on 2023/10/08.
//

import UIKit

final class TagCell: UICollectionViewCell {
    
    enum Constants {
        static let font: UIFont = .systemFont(ofSize: 16, weight: .medium)
        static let textColor: UIColor = UIColor.Common.black
        static let backgroundColor: UIColor = UIColor.Common.grey00
        static let horizontalMargin: CGFloat = 12
        static let height: CGFloat = 33
    }
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = Constants.font
        label.textColor = Constants.textColor
        label.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = frame.height / 2
        clipsToBounds = true
    }
    
    private func setupView() {
        backgroundColor = Constants.backgroundColor
        contentView.addSubview(titleLabel)
        NSLayoutConstraint.activate([
//            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.horizontalMargin),
//            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.horizontalMargin),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
            //            self.heightAnchor.constraint(equalToConstant: Constants.height)
        ])
    }
}

extension TagCell {
    func update(with title: String) {
        titleLabel.text = title
    }
}
