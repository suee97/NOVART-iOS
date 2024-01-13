//
//  UploadMediaCoverCell.swift
//  Novart
//
//  Created by Jinwook Huh on 2023/12/23.
//

import UIKit

final class UploadMediaCoverCell: UICollectionViewCell {
    
    private enum Constants {
        
        static let cornerRadius: CGFloat = 12
        
        enum Crop {
            static let color: UIColor = UIColor.Common.black
            static let margin: CGFloat = 4
        }
    }
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var cropButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "icon_crop"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addAction(UIAction(handler: {[weak self] _ in
            guard let self,
                  let identifier else { return }
            self.delegate?.didTapCropButton(identifier: identifier)
        }), for: .touchUpInside)
        return button
    }()
    
    private lazy var deleteButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "icon_upload_close"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addAction(UIAction(handler: {[weak self] _ in
            guard let self,
                  let identifier else { return }
            self.delegate?.didTapDeleteButton(identifier: identifier)
        }), for: .touchUpInside)
        return button
    }()
    
    private var identifier: String?
    weak var delegate: UploadCellActionDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        self.clipsToBounds = true
        contentView.addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
        addSubview(cropButton)
        NSLayoutConstraint.activate([
            cropButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: Constants.Crop.margin),
            cropButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: Constants.Crop.margin)
        ])
        
        contentView.addSubview(deleteButton)
        NSLayoutConstraint.activate([
            deleteButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constants.Crop.margin),
            deleteButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.Crop.margin),
        ])
        
        self.clipsToBounds = false
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = Constants.cornerRadius
        cropButton.clipsToBounds = false
    }
    
    func update(with item: UploadMediaItem) {
        self.identifier = item.identifier
        imageView.image = item.image
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        delegate = nil
        imageView.image = nil
        identifier = nil
    }
}
