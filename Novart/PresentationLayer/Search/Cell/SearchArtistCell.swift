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
        
        enum BackgroundImageView {
            static let defaultColor = UIColor.init(hexString: "#CACDCF")
        }
        
        enum ProfileOuterFrameView {
            static let diameter: CGFloat = 56
            static let color: UIColor = .white
        }
        
        enum ProfileImageView {
            static let diameter: CGFloat = 54
        }
        
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
    
    private let profileOuterFrameView: UIView = {
        let view = UIView()
        view.backgroundColor = Constants.ProfileOuterFrameView.color
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = Constants.ProfileOuterFrameView.diameter / 2
        return view
    }()
    
    private lazy var profileImageView: PlainProfileImageView = {
        let imageView = PlainProfileImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = Constants.ProfileImageView.diameter / 2
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
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
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
        
        contentView.addSubview(profileOuterFrameView)
        NSLayoutConstraint.activate([
            profileOuterFrameView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            profileOuterFrameView.centerYAnchor.constraint(equalTo: backgroundImageView.centerYAnchor),
            profileOuterFrameView.widthAnchor.constraint(equalToConstant: Constants.ProfileOuterFrameView.diameter),
            profileOuterFrameView.heightAnchor.constraint(equalToConstant: Constants.ProfileOuterFrameView.diameter)
        ])
        
        profileOuterFrameView.addSubview(profileImageView)
        NSLayoutConstraint.activate([
            profileImageView.centerXAnchor.constraint(equalTo: profileOuterFrameView.centerXAnchor),
            profileImageView.centerYAnchor.constraint(equalTo: profileOuterFrameView.centerYAnchor),
            profileImageView.widthAnchor.constraint(equalToConstant: Constants.ProfileImageView.diameter),
            profileImageView.heightAnchor.constraint(equalToConstant: Constants.ProfileImageView.diameter)
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
    
    override func prepareForReuse() {
        super.prepareForReuse()
        backgroundImageView.image = nil
        profileImageView.removeImage()
        artistLabel.text = ""
    }
}

extension SearchArtistCell {
    func update(with data: ArtistModel) {
        artistLabel.text = data.nickname
        if let backgroundUrlString = data.backgroundImageUrl, let backgroundUrl = URL(string: backgroundUrlString) {
            backgroundImageView.kf.setImage(with: backgroundUrl)
            backgroundImageView.alpha = 0.8
        } else {
            backgroundImageView.image = nil
            backgroundImageView.backgroundColor = Constants.BackgroundImageView.defaultColor
        }
        
        if let profileUrlString = data.profileImageUrl, let profileUrl = URL(string: profileUrlString) {
            profileImageView.setImage(with: profileUrl)
        }
    }
}
