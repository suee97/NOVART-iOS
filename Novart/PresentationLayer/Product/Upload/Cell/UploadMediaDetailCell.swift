//
//  UploadMediaDetailCell.swift
//  Novart
//
//  Created by Jinwook Huh on 2023/12/23.
//

import UIKit

final class UploadMediaDetailCell: UICollectionViewCell {
    
    private enum Constants {
        static let screenWidth: CGFloat = UIScreen.main.bounds.width
        static let buttonMargin: CGFloat = 24
    }
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
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
    private var heightConstraint: NSLayoutConstraint?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        self.clipsToBounds = true
        
        contentView.widthAnchor.constraint(equalToConstant: Constants.screenWidth).isActive = true
        heightConstraint = contentView.heightAnchor.constraint(equalToConstant: 100)
        heightConstraint?.priority = UILayoutPriority(999)
        heightConstraint?.isActive = true
        
        contentView.addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
        contentView.addSubview(deleteButton)
        NSLayoutConstraint.activate([
            deleteButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constants.buttonMargin),
            deleteButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.buttonMargin),
        ])        
    }
    
    func update(with item: UploadMediaItem) {
        self.identifier = item.identifier
        imageView.image = item.image
        let height: CGFloat = item.height * Constants.screenWidth / item.width
        heightConstraint?.constant = height
        layoutIfNeeded()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        delegate = nil
        imageView.image = nil
        identifier = nil
    }
}
