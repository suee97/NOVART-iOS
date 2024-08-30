//
//  HomeProductImageCell.swift
//  Novart
//
//  Created by Jinwook Huh on 2023/08/19.
//

import UIKit
import Kingfisher

final class HomeProductImageCell: UICollectionViewCell {
    
    enum Constants {
        static let screenWidth: CGFloat = UIScreen.main.bounds.width
        static let leadingMargin: CGFloat = 24
        static let itemWidth: CGFloat = screenWidth - leadingMargin * 2
        static let itemHeight: CGFloat = itemWidth * 4 / 3
    }
    
    // MARK: - UI
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        self.clipsToBounds = true
        contentView.addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    func update(with item: String) {
        let url = URL(string: item)
        imageView.kf.setImageWithDownsampling(with: url, size: CGSize(width: Constants.itemWidth, height: Constants.itemHeight))
    }
}
