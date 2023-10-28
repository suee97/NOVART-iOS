//
//  RecommendationSectionHeaderView.swift
//  Novart
//
//  Created by Jinwook Huh on 2023/10/22.
//

import UIKit

final class RecommendationSectionHeaderView: UICollectionReusableView {
    
    private enum Constants {
        static let font: UIFont = .systemFont(ofSize: 16, weight: .medium)
        static let color: UIColor = UIColor.Common.warmGrey03
    }
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = Constants.color
        label.font = Constants.font
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var title: String? {
        didSet {
            titleLabel.text = title
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: self.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor)
        ])
    }
}
