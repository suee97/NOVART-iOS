//
//  ProductSortView.swift
//  Novart
//
//  Created by Jinwook Huh on 2023/07/16.
//

import UIKit

final class ProductSortView: UICollectionReusableView {
    // MARK: - Constants
    
    enum Constants {
        enum CheckBox {
            static let promptText: String = "구매가능만 볼래요"
            static let font: UIFont = UIFont.systemFont(ofSize: 14, weight: .regular)
            static let textColor: UIColor = UIColor.Common.grey03
            static let spacing: CGFloat = 4
        }
        
        enum SortButton {
            static let font: UIFont = UIFont.systemFont(ofSize: 14, weight: .semibold)
            static let textColor: UIColor = UIColor.Common.grey03
        }
    }
    
    // MARK: - UI
    
    private lazy var checkBoxButton: NoHighlightButton = {
        let button = NoHighlightButton()
        
        button.setImage(UIImage(named: "icon_check_box"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.addAction(UIAction(handler: { _ in
            print("check")
        }), for: .touchUpInside)
        return button
    }()
    
    private lazy var checkBoxPromptLabel: UILabel = {
        let label = UILabel()
        label.text = Constants.CheckBox.promptText
        label.font = Constants.CheckBox.font
        label.textColor = Constants.CheckBox.textColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var sortLabel: UILabel = {
        var label = UILabel()
        label.text = "최신순"
        label.font = Constants.SortButton.font
        label.textColor = Constants.SortButton.textColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var sortButton: UIStackView = {
        let imageView = UIImageView(image: UIImage(named: "icon_chevron_down"))

        let view = UIStackView(arrangedSubviews: [sortLabel, imageView])
        view.spacing = 0
        view.axis = .horizontal
        view.translatesAutoresizingMaskIntoConstraints = false
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(sortButtonTapped))
        view.addGestureRecognizer(tapGesture)
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        backgroundColor = UIColor.white
        
        addSubview(checkBoxButton)
        NSLayoutConstraint.activate([
            checkBoxButton.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            checkBoxButton.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
        
        addSubview(checkBoxPromptLabel)
        NSLayoutConstraint.activate([
            checkBoxPromptLabel.leadingAnchor.constraint(equalTo: checkBoxButton.trailingAnchor, constant: Constants.CheckBox.spacing),
            checkBoxPromptLabel.centerYAnchor.constraint(equalTo: checkBoxButton.centerYAnchor)
        ])
        
        addSubview(sortButton)
        NSLayoutConstraint.activate([
            sortButton.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            sortButton.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
    }
    
    @objc
    private func sortButtonTapped() {
        print("tapped")
    }
}
