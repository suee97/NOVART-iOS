//
//  CategoryButton.swift
//  Novart
//
//  Created by Jinwook Huh on 2023/07/15.
//

import UIKit

class CategoryButton: UIView {

    // MARK: - Constants
    
    enum Constants {
        static let selectetFont: UIFont = UIFont.systemFont(ofSize: 14, weight: .bold)
        static let deselectetFont: UIFont = UIFont.systemFont(ofSize: 14, weight: .regular)
        static let selectedTextColor: UIColor = UIColor.Common.white
        static let deselectedTextColor: UIColor = UIColor.Common.grey03
        static let selectedBackgroundColor: UIColor = UIColor.Common.main
        static let deselectedBackgroundColor: UIColor = UIColor.Common.white
        static let borderColor: UIColor = UIColor.Common.grey01
        static let horizontalMargin: CGFloat = 14
        static let verticalMargin: CGFloat = 4
        static let corderRadius: CGFloat = 4
        static let width: CGFloat = 53
        static let height: CGFloat = 34
    }
    
    // MARK: - UI
    
    private lazy var label: UILabel = {
        let label = UILabel()
        label.font = Constants.deselectetFont
        label.textColor = Constants.deselectedTextColor
        label.textAlignment = .center
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
    
    var isSelected: Bool = false {
        didSet {
            changeState(to: isSelected)
        }
    }
    
    var action: (() -> Void)?
    
    init() {
        super.init(frame: .zero)
        
        setupView()
        setupGesture()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        backgroundColor = Constants.deselectedBackgroundColor
        layer.borderColor = Constants.borderColor.cgColor
        layer.borderWidth = 1
        
        NSLayoutConstraint.activate([
            self.widthAnchor.constraint(equalToConstant: Constants.width),
            self.heightAnchor.constraint(equalToConstant: Constants.height)
        ])
        
        addSubview(label)
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
        
        layer.cornerRadius = Constants.corderRadius
        clipsToBounds = true
    }
    
    private func setupGesture() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapped))
        addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc
    private func tapped() {
        isSelected.toggle()
        if isSelected {
            action?()
        }
    }
    
    private func changeState(to isSelected: Bool) {
        if isSelected {
            backgroundColor = Constants.selectedBackgroundColor
            label.font = Constants.selectetFont
            label.textColor = Constants.selectedTextColor
            layer.borderWidth = 0
            setNeedsLayout()
        } else {
            backgroundColor = Constants.deselectedBackgroundColor
            label.font = Constants.deselectetFont
            label.textColor = Constants.deselectedTextColor
            layer.borderWidth = 1
            setNeedsLayout()
        }
    }
}
