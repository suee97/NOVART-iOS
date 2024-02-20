//
//  PlainSnackbarView.swift
//  Novart
//
//  Created by Jinwook Huh on 2/17/24.
//

import UIKit

public final class PlainSnackbarView: UIView {
    enum Constants {
        static let cornerRadius: CGFloat = 12
        
        static let leadingMargin: CGFloat = 16
        static let trailingMargin: CGFloat = 16
        static let topMargin: CGFloat = 18
        static let bottomMargin: CGFloat = 18
        
        static let messageLabelSpacing: CGFloat = 8
        
        static let imageWidth: CGFloat = 24
        static let actionButtonLeadingMargin: CGFloat = 8
        static let actionIconWidth: CGFloat = 16
        
        static let duration: Double = 2
        static let delay: Double = 0
        static let animationDuration: TimeInterval = 0.5
    }
    
    public struct Configuration {
        // 좌측 이미지 / 아이콘
        public enum ImageType {
            public enum ImageIconType {
                case check
                case block
                
                var image: UIImage? {
                    var image: UIImage?
                    switch self {
                    case .check:
                        image = UIImage(named: "icon_snackbar_check")
                    case .block:
                        image = UIImage(named: "icon_snackbar_block")
                    }
                    return image?.preparingThumbnail(of: CGSize(width: Constants.imageWidth, height: Constants.imageWidth))
                }
            }
            case icon(_ type: ImageIconType)
            case none
        }
        
        // 우측 버튼 타입
        public enum ButtonType {
            case text(_ text: String)
            case none
        }
        
        public var imageType: ImageType
        public var buttonType: ButtonType
        public var buttonAction: (() -> Void)?
        
        public init(imageType: ImageType = .none,
                    buttonType: ButtonType = .none,
                    buttonAction: (() -> Void)? = nil) {
            self.imageType = imageType
            self.buttonType = buttonType
            self.buttonAction = buttonAction
        }
    }
    
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: Constants.imageWidth),
            imageView.heightAnchor.constraint(equalToConstant: Constants.imageWidth)
        ])
        return imageView
    }()

    
    private let messageLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.numberOfLines = 0
        label.textColor = UIColor.Common.grey04
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private let actionButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = .systemFont(ofSize: 14, weight: .semibold)
        button.setTitleColor(UIColor.Common.black, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
   
    private var completion: (() -> Void)?
   
    @objc
    func didTouchButton() {
        configuration?.buttonAction?()
        dismiss(animation: false)
    }
    
    public var message: String? {
        didSet {
            messageLabel.text = message
        }
    }
    public var configuration: Configuration? {
        didSet {
            applyConfiguration()
        }
    }
    
    public init(message: String, configuration: Configuration? = nil) {
        super.init(frame: .zero)
        
        ({ self.message = message })()
        if let configuration {
            ({ self.configuration = configuration })()
        } else {
            ({ self.configuration = Configuration() })()
        }
        initSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        applyShadow()
    }
    
    private func initSubviews() {
        backgroundColor = UIColor.Common.white
        layer.cornerRadius = Constants.cornerRadius
        
        addSubview(iconImageView)
        NSLayoutConstraint.activate([
            iconImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            iconImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: Constants.leadingMargin)
        ])
        
        addSubview(messageLabel)
        NSLayoutConstraint.activate([
            messageLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: Constants.messageLabelSpacing),
            messageLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: Constants.topMargin),
            messageLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -Constants.bottomMargin)
        ])
        
        addSubview(actionButton)
        NSLayoutConstraint.activate([
            actionButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -Constants.trailingMargin),
            actionButton.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            messageLabel.trailingAnchor.constraint(lessThanOrEqualTo: actionButton.leadingAnchor, constant: -Constants.actionButtonLeadingMargin)
        ])

        actionButton.addTarget(self, action: #selector(didTouchButton), for: .touchUpInside)
        actionButton.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        messageLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
    }
    
}

extension PlainSnackbarView {
    
    public func show(in view: UIView,
                     delay: Double? = nil,
                     duration: Double? = nil,
                     completion: (() -> Void)? = nil) {
        self.completion = completion
                
        Task {
            try await Task.sleep(seconds: delay ?? Constants.delay)
            await MainActor.run { present(in: view) }
            try await Task.sleep(seconds: duration ?? Constants.duration)
            await MainActor.run { dismiss() }
        }
    }
    
    private func present(in view: UIView) {
        self.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(self)
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            centerXAnchor.constraint(equalTo: view.centerXAnchor),
            leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.leadingMargin),
            view.trailingAnchor.constraint(equalTo: trailingAnchor, constant: Constants.trailingMargin),
            view.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: bottomAnchor, constant: Constants.bottomMargin)
        ])

        superview?.layoutIfNeeded()
        superview?.bringSubviewToFront(self)

        alpha = 0
        UIView.animate(withDuration: Constants.animationDuration) { [weak self] in
            self?.alpha = 1
        }
    }

    private func dismiss(animation: Bool = true) {
        guard superview != nil else { return }
        
        if !animation {
            removeFromSuperview()
            completion?()
            completion = nil
            return
        }
        
        UIView.animate(withDuration: Constants.animationDuration) { [weak self] in
            self?.alpha = 0
        } completion: { [weak self] _ in
            self?.removeFromSuperview()
            self?.completion?()
            self?.completion = nil
        }
    }

    private func applyConfiguration() {
        guard let configuration else { return }
        
        applyImageType(configuration.imageType)
        applyButtonType(configuration.buttonType)
    }
    
    private func applyImageType(_ imageType: Configuration.ImageType) {
        switch imageType {
        case let .icon(type):
            iconImageView.isHidden = false
            iconImageView.image = type.image
        case .none:
            iconImageView.isHidden = true
        }
    }
    
    private func applyButtonType(_ type: Configuration.ButtonType) {
        switch type {
        case let .text(title):
            actionButton.isHidden = false
            actionButton.setImage(nil, for: .normal)
            actionButton.setTitle(title, for: .normal)
        case .none:
            actionButton.isHidden = true
        }
    }
    
    private func applyShadow() {
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.2
        layer.shadowRadius = 6
        layer.shadowOffset = CGSize(width: 0, height: 0)
    }
}

// MARK: - Static Func

public extension PlainSnackbarView {
    
    static func show(viewController: UIViewController,
                     message: String,
                     configuration: Configuration? = nil,
                     delay: Double? = nil,
                     duration: Double? = nil,
                     completion: (() -> Void)? = nil) {
        let snackBar = PlainSnackbarView(message: message, configuration: configuration)
        snackBar.show(in: viewController.view, delay: delay, duration: duration, completion: completion)
    }
    
}


