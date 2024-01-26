//
//  ExhibitionShortcutItemView.swift
//  Novart
//
//  Created by Jinwook Huh on 2024/01/14.
//

import UIKit
import Kingfisher

final class ExhibitionShortcutItemView: UIView {
    
    private enum Constants {
        static let itemSize: CGFloat = 40
        static let bottomMargin: CGFloat = 12
        static let cornerRadius: CGFloat = 8
        static let indicatorColor: UIColor = UIColor.Common.warmGrey04
        static let indicatorSize: CGFloat = 4
    }
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.heightAnchor.constraint(equalToConstant: Constants.itemSize),
            imageView.widthAnchor.constraint(equalToConstant: Constants.itemSize)
        ])
        imageView.layer.cornerRadius = Constants.cornerRadius
        return imageView
    }()
    
    private lazy var indicatorView: UIView = {
        let view = UIView()
        view.backgroundColor = Constants.indicatorColor
        view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            view.heightAnchor.constraint(equalToConstant: Constants.indicatorSize),
            view.widthAnchor.constraint(equalToConstant: Constants.indicatorSize)
        ])
        view.layer.cornerRadius = Constants.indicatorSize / 2
        return view
    }()
    
    var isSelected: Bool = false {
        didSet {
            indicatorView.isHidden = !isSelected
        }
    }
    
    var didTap: (() -> Void)?
    
    let thumbnailUrl: String
    
    init(thumbnailUrl: String){
        self.thumbnailUrl = thumbnailUrl
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        addSubview(imageView)
        addSubview(indicatorView)
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            imageView.topAnchor.constraint(equalTo: self.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -Constants.bottomMargin),
            indicatorView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            indicatorView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
        indicatorView.isHidden = true
        
        let url = URL(string: thumbnailUrl)
        imageView.kf.setImage(with: url)
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapView))
        addGestureRecognizer(tapRecognizer)
    }
    
    @objc
    private func didTapView() {
        didTap?()
    }
}
