//
//  FilterButton.swift
//  Novart
//
//  Created by Jinwook Huh on 2023/08/20.
//

import UIKit

final class FilterButton: UIView {
    
    // MARK: - Constants
    
    enum Constants {
        static let size: CGFloat = 50
        
        enum Shadow {
            static let color: CGColor = UIColor.black.withAlphaComponent(0.25).cgColor
            static let radius: CGFloat = 4
            static let offset: CGSize = CGSize(width: 0, height: 4)
            static let opacity: Float = 1
        }
    }
    
    // MARK: - UI
    
    private lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "icon_filter")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    // MARK: Initialization
    
    init() {
        super.init(frame: .zero)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - SetupView
    
    private func setupView() {
        
        layer.cornerRadius = Constants.size / 2
        
        layer.shadowColor = Constants.Shadow.color
        layer.shadowOffset = Constants.Shadow.offset
        layer.shadowRadius = Constants.Shadow.radius
        layer.shadowOpacity = Constants.Shadow.opacity
        
        backgroundColor = UIColor.Common.white.withAlphaComponent(0.9)
        
        NSLayoutConstraint.activate([
            self.widthAnchor.constraint(equalToConstant: Constants.size),
            self.heightAnchor.constraint(equalToConstant: Constants.size)
        ])
        
        addSubview(iconImageView)
        NSLayoutConstraint.activate([
            iconImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            iconImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        ])
    }
}
