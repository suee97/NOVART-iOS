//
//  ProductCoverCell.swift
//  Novart
//
//  Created by Jinwook Huh on 2023/10/07.
//

import UIKit
import Kingfisher

final class ProductCoverCell: UICollectionViewCell {
    
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
        imageView.kf.setImage(with: url)
    }
    
    func update(image: UIImage) {
        imageView.image = image
    }
}

