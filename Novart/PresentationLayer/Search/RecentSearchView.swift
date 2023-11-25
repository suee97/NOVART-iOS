//
//  RecentSearchView.swift
//  Novart
//
//  Created by Jinwook Huh on 2023/10/15.
//

import UIKit

final class RecentSearchView: UIView {
    
    
    // MARK: - Constants
    
    enum Constants {
        
        static let horizontalInsets: CGFloat = 24
        
        enum Recent {
            static let titleFont: UIFont = .systemFont(ofSize: 16, weight: .bold)
            static let titleColor: UIColor = UIColor.Common.black
        }
        
        enum Delete {
            static let buttonFont: UIFont = .systemFont(ofSize: 14, weight: .regular)
            static let buttonColor: UIColor = UIColor.Common.grey03
        }
    }
    
    // MARK: - UI
    
    private lazy var recentTitleLabel: UILabel = {
        let label = UILabel()
        label.font = Constants.Recent.titleFont
        label.textColor = Constants.Recent.titleColor
        label.text = "최근 검색"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var deleteButton: UIButton = {
        let button = UIButton()
        button.setTitle("모두 삭제", for: .normal)
        button.setTitleColor(Constants.Delete.buttonColor, for: .normal)
        button.titleLabel?.font = Constants.Delete.buttonFont
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    init() {
        super.init(frame: .zero)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setupView() {
        backgroundColor = UIColor.white
        addSubview(recentTitleLabel)
        NSLayoutConstraint.activate([
            recentTitleLabel.topAnchor.constraint(equalTo: self.topAnchor),
            recentTitleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: Constants.horizontalInsets)
        ])
        
        addSubview(deleteButton)
        NSLayoutConstraint.activate([
            deleteButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -Constants.horizontalInsets),
            deleteButton.centerYAnchor.constraint(equalTo: recentTitleLabel.centerYAnchor)
        ])
    }
}
