//
//  ProductUploadingViewController.swift
//  Novart
//
//  Created by Jinwook Huh on 2024/01/01.
//

import UIKit
import Combine
import Lottie
import Kingfisher

final class ProductUploadingViewController: BaseViewController {
    
    // MARK: - Constant
    
    private enum Constants {
        static let horizontalMargin: CGFloat = 24
        
        enum Preview {
            static let backgroundColor = UIColor.Common.grey01_light
            static let width: CGFloat = 165
            static let height: CGFloat = 221
            static let cornerRadius: CGFloat = 12
            static let topMargin: CGFloat = 40
            static let titleFont: UIFont = .systemFont(ofSize: 14, weight: .bold)
            static let titleColor: UIColor = UIColor.Common.black
            static let artistFont: UIFont = .systemFont(ofSize: 12)
            static let artistColor: UIColor = UIColor.Common.grey03
            static let bottomViewHeight: CGFloat = 56
            static let horizontalMargin: CGFloat = 12
        }
        
        enum Title {
            static let titleFont: UIFont = .systemFont(ofSize: 24, weight: .bold)
            static let titleColor: UIColor = UIColor.Common.black
            static let tintColor: UIColor = UIColor.Common.main
            static let descriptionFont: UIFont = .systemFont(ofSize: 14)
            static let descriptionColor: UIColor = UIColor.Common.grey03
            static let spacing: CGFloat = 4
        }
        
        enum Loading {
            static let size: CGFloat = 24
        }
    }
    
    // MARK: - UI
    
    private lazy var uploadingView: UIView = {
        let view = UIView()
        view.backgroundColor = Constants.Preview.backgroundColor
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.15
        view.layer.shadowRadius = 6
        view.layer.shadowOffset = CGSize(width: 0, height: 0)
        view.layer.cornerRadius = Constants.Preview.cornerRadius
        view.clipsToBounds = false
        NSLayoutConstraint.activate([
            view.widthAnchor.constraint(equalToConstant: Constants.Preview.width),
            view.heightAnchor.constraint(equalToConstant: Constants.Preview.height)
        ])
        return view
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = Constants.Title.descriptionFont
        label.textColor = Constants.Title.descriptionColor
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var productLabel: UILabel = {
        let label = UILabel()
        label.font = Constants.Title.titleFont
        label.textColor = Constants.Title.titleColor
        label.textAlignment = .center
        label.text = "작품 "
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var stateLabel: UILabel = {
        let label = UILabel()
        label.font = Constants.Title.titleFont
        label.textColor = Constants.Title.tintColor
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var titleStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [productLabel, stateLabel])
        stackView.spacing = 0
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var loadingAnimationView: LottieAnimationView = {
        let view = LottieAnimationView(name: "loading_indicator")
        view.translatesAutoresizingMaskIntoConstraints = false
        view.loopMode = .loop
        return view
    }()
    
    private lazy var previewImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var previewTitleLabel: UILabel = {
        let label = UILabel()
        label.font = Constants.Preview.titleFont
        label.textColor = Constants.Title.titleColor
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var previewArtistLabel: UILabel = {
        let label = UILabel()
        label.font = Constants.Preview.artistFont
        label.textColor = Constants.Preview.artistColor
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var previewView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.15
        view.layer.shadowRadius = 6
        view.layer.shadowOffset = CGSize(width: 0, height: 0)
        view.layer.cornerRadius = Constants.Preview.cornerRadius
        view.clipsToBounds = true
        NSLayoutConstraint.activate([
            view.widthAnchor.constraint(equalToConstant: Constants.Preview.width),
            view.heightAnchor.constraint(equalToConstant: Constants.Preview.height)
        ])
        
        let bottomView = UIView()
        bottomView.backgroundColor = Constants.Preview.backgroundColor
        bottomView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bottomView)
        
        NSLayoutConstraint.activate([
            bottomView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            bottomView.heightAnchor.constraint(equalToConstant: Constants.Preview.bottomViewHeight)
        ])
        
        let stackView = UIStackView(arrangedSubviews: [previewTitleLabel, previewArtistLabel])
        stackView.spacing = 0
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.translatesAutoresizingMaskIntoConstraints = false
       
        bottomView.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: bottomView.leadingAnchor, constant: Constants.Preview.horizontalMargin),
            stackView.centerYAnchor.constraint(equalTo: bottomView.centerYAnchor)
        ])
        
        view.addSubview(previewImageView)
        NSLayoutConstraint.activate([
            previewImageView.topAnchor.constraint(equalTo: view.topAnchor),
            previewImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            previewImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            previewImageView.bottomAnchor.constraint(equalTo: bottomView.topAnchor),
        ])
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapPreview))
        view.addGestureRecognizer(tapGesture)
        return view
    }()
    
    private lazy var closeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "icon_close"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addAction(UIAction(handler: { [weak self] _ in
            guard let self else { return }
            self.viewModel.close()
        }), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Properties
    
    private var viewModel: ProductUploadingViewModel
    private var cancellables: Set<AnyCancellable> = .init()
    
    init(viewModel: ProductUploadingViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupData()
        viewModel.uploadProduct()
    }
    
    override func setupNavigationBar() {
        navigationController?.navigationBar.isHidden = false
        let closeItem = UIBarButtonItem(customView: closeButton)
        navigationItem.leftBarButtonItem = closeItem
        closeButton.isHidden = true
        title = ""
    }
    
    override func setupView() {
        view.backgroundColor = UIColor.Common.white
        
        view.addSubview(uploadingView)
        NSLayoutConstraint.activate([
            uploadingView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            uploadingView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        view.addSubview(descriptionLabel)
        view.addSubview(titleStackView)
        NSLayoutConstraint.activate([
            descriptionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            descriptionLabel.bottomAnchor.constraint(equalTo: uploadingView.topAnchor, constant: -Constants.Preview.topMargin),
            titleStackView.bottomAnchor.constraint(equalTo: descriptionLabel.topAnchor, constant: -Constants.Title.spacing),
            titleStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        view.addSubview(loadingAnimationView)
        NSLayoutConstraint.activate([
            loadingAnimationView.centerXAnchor.constraint(equalTo: uploadingView.centerXAnchor),
            loadingAnimationView.centerYAnchor.constraint(equalTo: uploadingView.centerYAnchor),
            loadingAnimationView.widthAnchor.constraint(equalToConstant: Constants.Loading.size),
            loadingAnimationView.heightAnchor.constraint(equalToConstant: Constants.Loading.size)
        ])
        
        view.addSubview(previewView)
        NSLayoutConstraint.activate([
            previewView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            previewView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        previewView.isHidden = true
    }
    
    override func setupBindings() {
        viewModel.$state
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                guard let self, state == .complete else { return }
                self.descriptionLabel.text = viewModel.completeDesription
                self.stateLabel.text = viewModel.stateText
                self.loadingAnimationView.stop()
                self.loadingAnimationView.isHidden = true
                self.closeButton.isHidden = false
            }
            .store(in: &cancellables)
        
        viewModel.uploadedProductSubject
            .receive(on: DispatchQueue.main)
            .sink { [weak self] product in
                guard let self else { return }
                self.previewTitleLabel.text = product.name
                self.previewArtistLabel.text = product.nickname
                self.previewImageView.kf.setImage(with: URL(string: product.thumbnailImageUrl ?? ""))
                self.previewView.isHidden = false
            }
            .store(in: &cancellables)
    }
    
    private func setupData() {
        descriptionLabel.text = viewModel.uploadingDesription
        stateLabel.text = viewModel.stateText
        loadingAnimationView.play()
    }
    
    @objc
    private func didTapPreview() {
        viewModel.didTapPreview()
    }
}
