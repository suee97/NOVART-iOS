//
//  TagView.swift
//  Novart
//
//  Created by Jinwook Huh on 2023/07/14.
//

import UIKit

final class TagView: UIView {
    
    // MARK: - Constants
    
    enum Constants {
        static let font: UIFont = UIFont.systemFont(ofSize: 12, weight: .regular)
        static let textColor: UIColor = UIColor.Common.white
        static let horizontalMargin: CGFloat = 8
        static let verticalMargin: CGFloat = 4
        static let corderRadius: CGFloat = 4
    }
    
    // MARK: - UI
    
    private var label: UILabel = {
        let label = UILabel()
        label.font = Constants.font
        label.textColor = Constants.textColor
        label.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Properties
    
    var text: String = "" {
        didSet {
            label.text = text
        }
    }
    
    var borderColor: UIColor = .clear {
        didSet {
            self.layer.borderColor = borderColor.cgColor
            setNeedsLayout()
        }
    }
    
    var borderWidth: CGFloat = 0 {
        didSet {
            self.layer.borderWidth = borderWidth
            setNeedsLayout()
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

        addSubview(label)
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: self.topAnchor, constant: Constants.verticalMargin),
            label.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -Constants.verticalMargin),
            label.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: Constants.horizontalMargin),
            label.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -Constants.horizontalMargin)
        ])
        
        layer.cornerRadius = Constants.corderRadius
        clipsToBounds = true
    }
}

