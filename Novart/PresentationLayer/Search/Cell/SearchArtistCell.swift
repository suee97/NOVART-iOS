//
//  SearchArtistCell.swift
//  Novart
//
//  Created by Jinwook Huh on 2023/10/15.
//

import UIKit

final class SearchArtistCell: UICollectionViewCell {
    
    // MARK: - Constants
    
    private enum Constants {

        static let cornerRadius: CGFloat = 12

        enum BottomInfo {
            static let textColor: UIColor = UIColor.Common.black
            static let font: UIFont = UIFont.systemFont(ofSize: 14, weight: .bold)
            static let backgroundColor: UIColor = UIColor.Common.grey01_light
            static let height: CGFloat = 40
        }
    }
    
    // MARK: - UI

    private lazy var backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var bottomInfoView: UIView = {
        let view = UIView()
        view.backgroundColor = Constants.BottomInfo.backgroundColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var artistLabel: UILabel = {
        let label = UILabel()
        label.font = Constants.BottomInfo.font
        label.textColor = Constants.BottomInfo.textColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    // MARK: - Initialization

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup

    private func setupView() {
        
        contentView.addSubview(bottomInfoView)
        NSLayoutConstraint.activate([
            bottomInfoView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            bottomInfoView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            bottomInfoView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            bottomInfoView.heightAnchor.constraint(equalToConstant: Constants.BottomInfo.height)
        ])
        
        contentView.addSubview(backgroundImageView)
        NSLayoutConstraint.activate([
            backgroundImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            backgroundImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: bottomInfoView.topAnchor)
        ])
        
        bottomInfoView.addSubview(artistLabel)
        NSLayoutConstraint.activate([
            artistLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            artistLabel.centerYAnchor.constraint(equalTo: bottomInfoView.centerYAnchor)
        ])
        
        
        contentView.layer.cornerRadius = Constants.cornerRadius
        contentView.clipsToBounds = true
        
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.1
        layer.shadowOffset = CGSize(width: 0, height: 2)
    }
}

extension SearchArtistCell {
    func update(with data: ArtistModel) {
        artistLabel.text = data.nickname
        backgroundImageView.image = UIImage(named: "mock_table")
    }
}
