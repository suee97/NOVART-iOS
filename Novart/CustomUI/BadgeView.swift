//
//  BadgeView.swift
//  Novart
//
//  Created by Jinwook Huh on 2023/07/16.
//

import UIKit

final class BadgeView: UIView {
    // MARK: - Constants
    
    enum Constants {
        static let font: UIFont = UIFont.systemFont(ofSize: 14, weight: .semibold)
        static let textColor: UIColor = UIColor.Common.grey03
        static let backgroundColor: UIColor = UIColor.Common.white
        static let horizontalMargin: CGFloat = 8
        static let verticalMargin: CGFloat = 4
        static let corderRadius: CGFloat = 14
        static let height: CGFloat = 28
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
    
    var textColor: UIColor = Constants.textColor {
        didSet {
            label.textColor = textColor
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
    }
}
