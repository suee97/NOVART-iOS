//
//  PlainProfileImageView.swift
//  Novart
//
//  Created by Jinwook Huh on 2/18/24.
//

import UIKit
import Kingfisher

final class PlainProfileImageView: UIView {
    
    private lazy var placeholderImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(named: "default_profile_image")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var profileImageView: UIImageView = {
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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setCornerRadius()
    }
    
    private func setCornerRadius() {
        clipsToBounds = true
        layer.cornerRadius = bounds.height / 2
    }
    
    private func setupView() {
        addSubview(placeholderImageView)
        addSubview(profileImageView)
        
        NSLayoutConstraint.activate([
            placeholderImageView.topAnchor.constraint(equalTo: self.topAnchor),
            placeholderImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            placeholderImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            placeholderImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            profileImageView.topAnchor.constraint(equalTo: self.topAnchor),
            profileImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            profileImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            profileImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor)
        ])
    }
}

extension PlainProfileImageView {
    func setImage(with url: URL?) {
        let retryStrategy = DelayRetryStrategy(maxRetryCount: 3, retryInterval: .seconds(1))
        profileImageView.kf.setImage(with: url, options: [.retryStrategy(retryStrategy)])
    }
    
    func removeImage() {
        profileImageView.image = nil
    }
}
