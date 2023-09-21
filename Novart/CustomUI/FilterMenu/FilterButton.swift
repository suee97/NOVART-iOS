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
        static let menuMargin: CGFloat = 8
        static let color = UIColor.Common.white.withAlphaComponent(0.9)
        
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
    
    // MARK: - Properties
    var filterTypes: [CategoryType]
    
    // MARK: - Initialization
    
    init(filterTypes: [CategoryType]) {
        self.filterTypes = filterTypes
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - SetupView
    
    private func setupView() {
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapButton))
        self.addGestureRecognizer(tapGesture)

        layer.cornerRadius = Constants.size / 2
        
        layer.shadowColor = Constants.Shadow.color
        layer.shadowOffset = Constants.Shadow.offset
        layer.shadowRadius = Constants.Shadow.radius
        layer.shadowOpacity = Constants.Shadow.opacity
        
        backgroundColor = Constants.color
        
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
    
    private func showFilterMenu() {
        guard let window = UIApplication.shared.keyWindowScene, let buttonOrigin = superview?.convert(frame.origin, to: nil) else { return }
        
        let xPos = buttonOrigin.x
        let yPos = buttonOrigin.y - Constants.menuMargin
        let anchorPosition = CGPoint(x: xPos, y: yPos)
        
        let menuView = FilterMenuView(filterTypes: filterTypes, anchorPosition: anchorPosition)
        menuView.frame = CGRect(x: 0, y: 0, width: window.frame.width, height: window.frame.height)
        window.addSubview(menuView)
    }
    
    @objc
    private func didTapButton() {
        showFilterMenu()
    }
}
