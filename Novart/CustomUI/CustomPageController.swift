//
//  CustomPageController.swift
//  Novart
//
//  Created by Jinwook Huh on 2023/10/07.
//

import UIKit

class CustomPageController: UIView {
    
    private lazy var indicatorStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    var totalCount: Int = 0 {
        didSet {
            resetView()
        }
    }
    
    var defaultColor: UIColor = .Common.warmGrey02 {
        didSet {
            updateCurrentPage()
        }
    }
    
    var selectedColor: UIColor = .Common.warmBlack {
        didSet {
            updateCurrentPage()
        }
    }
    
    var index: Int = 0 {
        didSet {
            updateCurrentPage()
        }
    }
    
    var spacing: CGFloat = 0 {
        didSet {
            resetView()
        }
    }
    
    var size: CGFloat = 4 {
        didSet {
            resetView()
        }
    }
    
    init() {
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        addSubview(indicatorStackView)
        NSLayoutConstraint.activate([
            indicatorStackView.topAnchor.constraint(equalTo: self.topAnchor),
            indicatorStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            indicatorStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            indicatorStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
        
        resetView()
    }
    
    private func resetView() {
        
        indicatorStackView.spacing = spacing
        
        for view in indicatorStackView.arrangedSubviews {
            indicatorStackView.removeArrangedSubview(view)
            view.removeFromSuperview()
        }
        
        for _ in 0..<totalCount {
            let view = UIView()
            view.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                view.widthAnchor.constraint(equalToConstant: size),
                view.heightAnchor.constraint(equalToConstant: size)
            ])
            view.backgroundColor = defaultColor
            view.clipsToBounds = true
            view.layer.cornerRadius = size / 2
            indicatorStackView.addArrangedSubview(view)
        }
        
        updateCurrentPage()
    }
    
    private func updateCurrentPage() {
        for (idx, view) in indicatorStackView.arrangedSubviews.enumerated() {
            if idx == index {
                view.backgroundColor = selectedColor
            } else {
                view.backgroundColor = defaultColor
            }
        }
    }
}
