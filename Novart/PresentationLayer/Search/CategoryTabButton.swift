//
//  CategoryTabButton.swift
//  Novart
//
//  Created by Jinwook Huh on 2023/09/21.
//

import UIKit

final class CategoryTabButton: UIView {
    
    // MARK: - Constants
    
    enum Constants {
        static let font: UIFont = UIFont.systemFont(ofSize: 16, weight: .regular)
        static let selectedFont: UIFont = UIFont.systemFont(ofSize: 16, weight: .bold)
        static let textColor: UIColor = UIColor.Common.grey04
        static let selectedTextColor: UIColor = UIColor.Common.white
        static let backgroundColor: UIColor = UIColor.Common.grey00
        static let selectedBackgroundColor: UIColor = UIColor.Common.main
        
        static let horizontalMargin: CGFloat = 12
        static let corderRadius: CGFloat = 19
        static let height: CGFloat = 38
    }
    
    // MARK: - UI
    
    private var label: UILabel = {
        let label = UILabel()
        label.font = Constants.font
        label.textColor = Constants.textColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Properties
    
    var text: String = "" {
        didSet {
            label.text = text
        }
    }
    
    var isSelected: Bool = false {
        didSet {
            label.font = isSelected ? Constants.selectedFont : Constants.font
            label.textColor = isSelected ? Constants.selectedTextColor : Constants.textColor
            self.backgroundColor = isSelected ? Constants.selectedBackgroundColor : Constants.backgroundColor
        }
    }
    
    var action: ((Bool) -> Void)?
    
    // MARK: - Initialization

    init() {
        super.init(frame: .zero)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    
    private func setupView() {
        backgroundColor = Constants.backgroundColor
        addSubview(label)
        NSLayoutConstraint.activate([
            self.heightAnchor.constraint(equalToConstant: Constants.height),
            label.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            label.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: Constants.horizontalMargin),
            label.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -Constants.horizontalMargin)
        ])
        
        layer.cornerRadius = Constants.corderRadius
        clipsToBounds = true
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture))
        self.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc
    private func handleTapGesture() {
        isSelected.toggle()
        action?(isSelected)
    }
}
