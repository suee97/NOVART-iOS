//
//  PolicyContentView.swift
//  Novart
//
//  Created by Jinwook Huh on 2023/07/23.
//

import UIKit

final class PolicyContentView: UIView {
    // MARK: - Constants
    
    enum Constants {
        
        enum TitleLabel {
            static let font: UIFont = UIFont.systemFont(ofSize: 12, weight: .regular)
            static let textColor = UIColor.Common.grey03
            static let trailingMargin: CGFloat = 4
        }
        
        enum OptionalLabel {
            static let textColor: UIColor = UIColor.Common.grey03
            static let essentialColor: UIColor = UIColor.Common.main
            static let font: UIFont = UIFont.systemFont(ofSize: 12, weight: .regular)
        }
    }
    
    // MARK: - UI

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var optionalLabel: UILabel = {
        let label = UILabel()
        label.font = Constants.OptionalLabel.font
        label.textColor = Constants.OptionalLabel.textColor
        label.text = "(선택)"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var detailIcon: UIImageView = {
        let imageView  = UIImageView()
        imageView.image = UIImage(named: "icon_chevron_right")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    // MARK: - Properties
    
    var title: String? = nil {
        didSet {
            guard let title else { return }
            setTitle(as: title)
        }
    }
    
    var isOptional: Bool = true {
        didSet {
            setOptional(as: isOptional)
        }
    }
    
    // MARK: - Intialization

    init() {
        super.init(frame: .zero)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
        
        addSubview(optionalLabel)
        NSLayoutConstraint.activate([
            optionalLabel.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: Constants.TitleLabel.trailingMargin),
            optionalLabel.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor)
        ])
        
        addSubview(detailIcon)
        NSLayoutConstraint.activate([
            detailIcon.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            detailIcon.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }
}

private extension PolicyContentView {
    func setTitle(as title: String) {
        let titleString = NSMutableAttributedString(string: title)
        titleString.addAttributes(
            [.font: Constants.TitleLabel.font,
             .foregroundColor: Constants.TitleLabel.textColor,
             .underlineStyle: NSUnderlineStyle.single.rawValue
            ],
            range: NSRange(location: 0, length: titleString.length))
        
        titleLabel.attributedText = titleString
    }
    
    func setOptional(as optional: Bool) {
        if optional {
            optionalLabel.textColor = Constants.OptionalLabel.textColor
            optionalLabel.text = "(선택)"
        } else {
            optionalLabel.textColor = Constants.OptionalLabel.essentialColor
            optionalLabel.text = "(필수)"
        }
    }
}
