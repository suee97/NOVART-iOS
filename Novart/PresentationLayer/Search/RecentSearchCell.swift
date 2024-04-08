//
//  RecentSearchCell.swift
//  Novart
//
//  Created by Jinwook Huh on 4/6/24.
//

import UIKit

final class RecentSearchCell: UICollectionViewCell {
    
    private enum Constants {
        static let height: CGFloat = 42
        static let backgroundColor: UIColor = UIColor.Common.grey00
        static let horizontalMargin: CGFloat = 12
        static let cornerRadius: CGFloat = 12
        
        enum Title {
            static let font: UIFont = .systemFont(ofSize: 14)
            static let textColor: UIColor = .Common.grey04
            static let trailingMargin: CGFloat = 4
        }
    }
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = Constants.Title.font
        label.textColor = Constants.Title.textColor
        label.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var closeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "icon_recent_close"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addAction(UIAction(handler: { [weak self] _ in
            self?.didTapDelete?()
        }), for: .touchUpInside)
        return button
    }()
    
    var didTapDelete: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        contentView.backgroundColor = Constants.backgroundColor
        contentView.addSubview(titleLabel)
        contentView.addSubview(closeButton)
        
        NSLayoutConstraint.activate([
            self.heightAnchor.constraint(equalToConstant: Constants.height),
            contentView.heightAnchor.constraint(equalToConstant: Constants.height),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.horizontalMargin),
            closeButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            closeButton.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: Constants.Title.trailingMargin),
            closeButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.horizontalMargin)
        ])
        
        clipsToBounds = true
        layer.cornerRadius = Constants.cornerRadius
    }
    
    func update(text: String) {
        titleLabel.text = text
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
    }
}
