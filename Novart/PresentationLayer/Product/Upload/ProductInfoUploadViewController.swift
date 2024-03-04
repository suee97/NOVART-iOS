//
//  ProductInfoUploadViewController.swift
//  Novart
//
//  Created by Jinwook Huh on 2023/12/24.
//

import UIKit
import Combine

final class ProductInfoUploadViewController: BaseViewController {
    
    // MARK: - Constants
    
    private enum Constants {
        static let topMargin: CGFloat = 16
        static let horizontalMargin: CGFloat = 24
        static let screenWidth: CGFloat = UIScreen.main.bounds.width
        static let bottomMargin: CGFloat = 38

        enum PreviewButton {
            static let font: UIFont = .systemFont(ofSize: 16, weight: .medium)
            static let textColor: UIColor = UIColor.Common.main
            static let disabledColor: UIColor = UIColor.Common.grey02
        }
        
        enum Title {
            static let font: UIFont = .systemFont(ofSize: 16, weight: .semibold)
            static let textColor: UIColor = UIColor.Common.grey03
            static let topMargin: CGFloat = 32
        }
        
        enum CountLabel {
            static let font: UIFont = .systemFont(ofSize: 12)
            static let textColor: UIColor = UIColor.Common.grey03
            static let tintColor: UIColor = UIColor.Common.main
        }
        
        enum TextField {
            static let topMargin: CGFloat = 8
            static let height: CGFloat = 49
            static let titleTextFieldTitle: String = "제목*"
            static let titleTextFieldPlaceholder: String = "작품 이름"
            static let categoryTitleLabel: String = "분야*"
            static let descriptionTextFieldTitle: String = "작품 설명*"
            static let descriptionTextFieldPlaceholder: String = "작품 배경&의도"
            static let tagTextFieldTitle: String = "태그"
            static let tagTextFieldPlaceholder: String = "쉼표로 구분된 태그 입력 / ex) 모던, 클래식"
            static let priceTextFieldTitle: String = "작품 목적*"
            static let priceTextFieldPlaceholder: String = "₩ 거래할 가격 입력"
        }
        
        enum CategoryTagView {
            static let height: CGFloat = 36
        }
        
        enum TextView {
            static let height: CGFloat = 160
            static let font: UIFont = .systemFont(ofSize: 14)
            static let textColor: UIColor = UIColor.Common.warmBlack
            static let borderWidth: CGFloat = 1
            static let borderColor: UIColor = UIColor.Common.grey01
            static let cornerRadius: CGFloat = 12
            static let inset: CGFloat = 14
            static let placeholderColor: UIColor = UIColor.Common.grey02
        }
        
        enum Recommend {
            static let topMargin: CGFloat = 8
            static let font: UIFont = .systemFont(ofSize: 14, weight: .semibold)
            static let color: UIColor = UIColor.Common.grey04
            static let upImage = UIImage(named: "icon_chevron_up_v2")
            static let downImage = UIImage(named: "icon_chevron_down_v2")
        }
    }
    
    // MARK: - UI
    
    private lazy var previewButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = Constants.PreviewButton.font
        button.setTitle("미리보기", for: .normal)
        button.setTitleColor(Constants.PreviewButton.textColor, for: .normal)
        button.setTitleColor(Constants.PreviewButton.disabledColor, for: .disabled)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.addAction(UIAction(handler: { [weak self] _ in
            self?.viewModel.showPreview()
        }), for: .touchUpInside)
        
        return button
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.contentInsetAdjustmentBehavior = .never
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = Constants.Title.font
        label.textColor = Constants.Title.textColor
        label.text = Constants.TextField.titleTextFieldTitle
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var titleTextField: PlainEditTextField = {
        let textField = PlainEditTextField(placeholder: Constants.TextField.titleTextFieldPlaceholder)
        textField.delegate = self
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private lazy var titleCountLabel: UILabel = {
        let label = UILabel()
        label.font = Constants.CountLabel.font
        label.textColor = Constants.CountLabel.tintColor
        label.text = "\(titleTextField.text?.count ?? 0)"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var titleMaxCountLabel: UILabel = {
        let label = UILabel()
        label.font = Constants.CountLabel.font
        label.textColor = Constants.CountLabel.textColor
        label.text = "/\(viewModel.maxTitleCount)자"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let categoryLabel: UILabel = {
        let label = UILabel()
        label.font = Constants.Title.font
        label.textColor = Constants.Title.textColor
        label.text = Constants.TextField.categoryTitleLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var categoryTagView: TagView = {
        let tagView = TagView()
        tagView.delegate = self
        tagView.isSelectable = true
        tagView.translatesAutoresizingMaskIntoConstraints = false
        return tagView
    }()
    
    private lazy var categoryCountLabel: UILabel = {
        let label = UILabel()
        label.font = Constants.CountLabel.font
        label.textColor = Constants.CountLabel.tintColor
        label.text = "0"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var categoryMaxCountLabel: UILabel = {
        let label = UILabel()
        label.font = Constants.CountLabel.font
        label.textColor = Constants.CountLabel.textColor
        label.text = "/\(viewModel.maxCategoryCount)"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = Constants.Title.font
        label.textColor = Constants.Title.textColor
        label.text = Constants.TextField.descriptionTextFieldTitle
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var descriptionCountLabel: UILabel = {
        let label = UILabel()
        label.font = Constants.CountLabel.font
        label.textColor = Constants.CountLabel.tintColor
        label.text = "0"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var descriptionMaxCountLabel: UILabel = {
        let label = UILabel()
        label.font = Constants.CountLabel.font
        label.textColor = Constants.CountLabel.textColor
        label.text = "/\(viewModel.maxDescriptionCount)자"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var textViewPlaceHolder: UILabel = {
        let label = UILabel()
        label.font = Constants.TextView.font
        label.textColor = Constants.TextView.placeholderColor
        label.text = Constants.TextField.descriptionTextFieldPlaceholder
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var descriptionTextView: UITextView = {
        let textView = UITextView()
        textView.textContainerInset = UIEdgeInsets(top: Constants.TextView.inset, left: Constants.TextView.inset, bottom: Constants.TextView.inset, right: Constants.TextView.inset)
        textView.font = Constants.TextView.font
        textView.textColor = Constants.TextView.textColor
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.layer.cornerRadius = Constants.TextView.cornerRadius
        textView.layer.borderColor = Constants.TextView.borderColor.cgColor
        textView.layer.borderWidth = Constants.TextView.borderWidth
        textView.clipsToBounds = true
        textView.delegate = self
        return textView
    }()
    
    
    private let tagLabel: UILabel = {
        let label = UILabel()
        label.font = Constants.Title.font
        label.textColor = Constants.Title.textColor
        label.text = Constants.TextField.tagTextFieldTitle
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var recommendTagCountLabel: UILabel = {
        let label = UILabel()
        label.font = Constants.CountLabel.font
        label.textColor = Constants.CountLabel.tintColor
        label.text = "0"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var tagMaxCountLabel: UILabel = {
        let label = UILabel()
        label.font = Constants.CountLabel.font
        label.textColor = Constants.CountLabel.textColor
        label.text = "/\(viewModel.maxTagCount)"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var tagTextField: PlainEditTextField = {
        let textField = PlainEditTextField(placeholder: Constants.TextField.tagTextFieldPlaceholder)
        textField.addTarget(self, action: #selector(tagFieldDidChanged(_:)), for: .editingChanged)
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private lazy var tagRecommendImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = Constants.Recommend.upImage
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var tagRecommendButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = Constants.Recommend.font
        button.setTitleColor(Constants.Recommend.color, for: .normal)
        button.setTitle("추천태그", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addAction(UIAction(handler: { [weak self] _ in
            guard let self else { return }
            self.viewModel.recommendationExpanded.toggle()
            if self.viewModel.recommendationExpanded {
                self.recommendTagViewHeightConstraint?.constant = recommendTagCalculatedHeight
            } else {
                self.recommendTagViewHeightConstraint?.constant = 0
            }
            self.view.layoutIfNeeded()
        }), for: .touchUpInside)
        return button
    }()
    
    private lazy var tagRecommendStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [tagRecommendButton, tagRecommendImageView])
        stackView.spacing = 0
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var recommendTagView: TagView = {
        let tagView = TagView()
        tagView.delegate = self
        tagView.isSelectable = true
        tagView.translatesAutoresizingMaskIntoConstraints = false
        return tagView
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.font = Constants.Title.font
        label.textColor = Constants.Title.textColor
        label.text = Constants.TextField.priceTextFieldTitle
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var priceTagView: TagView = {
        let tagView = TagView()
        tagView.delegate = self
        tagView.isSelectable = true
        tagView.translatesAutoresizingMaskIntoConstraints = false
        return tagView
    }()

    private let priceTextField: PlainEditTextField = {
       let textField = PlainEditTextField(placeholder: Constants.TextField.priceTextFieldPlaceholder)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.keyboardType = .numberPad
        return textField
    }()
    
    
    // MARK: - Properties

    private var viewModel: ProductInfoUploadViewModel
    private var cancellables: Set<AnyCancellable> = .init()
    private var recommendTagViewHeightConstraint: NSLayoutConstraint?
    private var recommendTagCalculatedHeight: CGFloat = 0
    
    // MARK: - Init
    
    init(viewModel: ProductInfoUploadViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupData()
    }
    
    override func setupNavigationBar() {
        
        let closeButton = UIButton()
        closeButton.setBackgroundImage(UIImage(named: "icon_nav_chevron_left"), for: .normal)
        closeButton.addAction(UIAction(handler: { [weak self] _ in
            guard let self else { return }
            self.navigationController?.popViewController(animated: true)
        }), for: .touchUpInside)
        let closeItem = UIBarButtonItem(customView: closeButton)
        navigationItem.leftBarButtonItem = closeItem
        
        let nextItem = UIBarButtonItem(customView: previewButton)
        navigationItem.rightBarButtonItem = nextItem
        
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        
        title = viewModel.isEditScene ? "작품 편집" : "작품 등록"
        previewButton.isEnabled = true
    }
    
    override func setupView() {
        view.backgroundColor = UIColor.Common.white
        
        let safeArea = view.safeAreaLayoutGuide
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
        scrollView.delegate = self
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(titleCountLabel)
        contentView.addSubview(titleMaxCountLabel)
        contentView.addSubview(titleTextField)
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.horizontalMargin),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constants.topMargin),
            titleMaxCountLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.horizontalMargin),
            titleMaxCountLabel.bottomAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            titleCountLabel.bottomAnchor.constraint(equalTo: titleMaxCountLabel.bottomAnchor),
            titleCountLabel.trailingAnchor.constraint(equalTo: titleMaxCountLabel.leadingAnchor),
            titleTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: Constants.TextField.topMargin),
            titleTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.horizontalMargin),
            titleTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.horizontalMargin),
            titleTextField.heightAnchor.constraint(equalToConstant: Constants.TextField.height),
        ])
        titleTextField.delegate = self
        
        contentView.addSubview(categoryLabel)
        contentView.addSubview(categoryCountLabel)
        contentView.addSubview(categoryMaxCountLabel)
        
        contentView.addSubview(categoryTagView)
        NSLayoutConstraint.activate([
            categoryLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.horizontalMargin),
            categoryLabel.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: Constants.Title.topMargin),
            categoryMaxCountLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.horizontalMargin),
            categoryMaxCountLabel.bottomAnchor.constraint(equalTo: categoryLabel.bottomAnchor),
            categoryCountLabel.bottomAnchor.constraint(equalTo: categoryMaxCountLabel.bottomAnchor),
            categoryCountLabel.trailingAnchor.constraint(equalTo: categoryMaxCountLabel.leadingAnchor),
            categoryTagView.topAnchor.constraint(equalTo: categoryLabel.bottomAnchor, constant: Constants.TextField.topMargin),
            categoryTagView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.horizontalMargin),
            categoryTagView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.horizontalMargin),
            categoryTagView.heightAnchor.constraint(equalToConstant: Constants.CategoryTagView.height),
        ])
        
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(descriptionCountLabel)
        contentView.addSubview(descriptionMaxCountLabel)
        contentView.addSubview(descriptionTextView)
        contentView.addSubview(textViewPlaceHolder)
        
        NSLayoutConstraint.activate([
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.horizontalMargin),
            descriptionLabel.topAnchor.constraint(equalTo: categoryTagView.bottomAnchor, constant: Constants.Title.topMargin),
            descriptionMaxCountLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.horizontalMargin),
            descriptionMaxCountLabel.bottomAnchor.constraint(equalTo: descriptionLabel.bottomAnchor),
            descriptionCountLabel.bottomAnchor.constraint(equalTo: descriptionMaxCountLabel.bottomAnchor),
            descriptionCountLabel.trailingAnchor.constraint(equalTo: descriptionMaxCountLabel.leadingAnchor),
            descriptionTextView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: Constants.TextField.topMargin),
            descriptionTextView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.horizontalMargin),
            descriptionTextView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.horizontalMargin),
            descriptionTextView.heightAnchor.constraint(equalToConstant: Constants.TextView.height),
            textViewPlaceHolder.leadingAnchor.constraint(equalTo: descriptionTextView.leadingAnchor, constant: 17),
            textViewPlaceHolder.topAnchor.constraint(equalTo: descriptionTextView.topAnchor, constant: Constants.TextView.inset)
        ])
        
        contentView.addSubview(tagLabel)
        contentView.addSubview(recommendTagCountLabel)
        contentView.addSubview(tagMaxCountLabel)
        contentView.addSubview(tagTextField)
        contentView.addSubview(tagRecommendStackView)
        contentView.addSubview(recommendTagView)
        
        NSLayoutConstraint.activate([
            tagLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.horizontalMargin),
            tagLabel.topAnchor.constraint(equalTo: descriptionTextView.bottomAnchor, constant: Constants.Title.topMargin),
            tagMaxCountLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.horizontalMargin),
            tagMaxCountLabel.bottomAnchor.constraint(equalTo: tagLabel.bottomAnchor),
            recommendTagCountLabel.bottomAnchor.constraint(equalTo: tagMaxCountLabel.bottomAnchor),
            recommendTagCountLabel.trailingAnchor.constraint(equalTo: tagMaxCountLabel.leadingAnchor),
            tagTextField.topAnchor.constraint(equalTo: tagLabel.bottomAnchor, constant: Constants.TextField.topMargin),
            tagTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.horizontalMargin),
            tagTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.horizontalMargin),
            tagTextField.heightAnchor.constraint(equalToConstant: Constants.TextField.height),
            tagRecommendStackView.topAnchor.constraint(equalTo: tagTextField.bottomAnchor, constant: Constants.Recommend.topMargin),
            tagRecommendStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.horizontalMargin),
            recommendTagView.topAnchor.constraint(equalTo: tagRecommendButton.bottomAnchor, constant: Constants.Recommend.topMargin),
            recommendTagView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.horizontalMargin),
            recommendTagView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.horizontalMargin)
        ])
        tagTextField.delegate = self
        recommendTagViewHeightConstraint = recommendTagView.heightAnchor.constraint(equalToConstant: 1000)
        recommendTagViewHeightConstraint?.priority = UILayoutPriority(999)
        recommendTagViewHeightConstraint?.isActive = true
        
        contentView.addSubview(priceLabel)
        contentView.addSubview(priceTagView)
        contentView.addSubview(priceTextField)
        NSLayoutConstraint.activate([
            priceLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.horizontalMargin),
            priceLabel.topAnchor.constraint(equalTo: recommendTagView.bottomAnchor, constant: Constants.Title.topMargin),
            
            priceTagView.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: Constants.TextField.topMargin),
            priceTagView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.horizontalMargin),
            priceTagView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.horizontalMargin),
            priceTagView.heightAnchor.constraint(equalToConstant: Constants.CategoryTagView.height),
            
            priceTextField.topAnchor.constraint(equalTo: priceTagView.bottomAnchor, constant: Constants.TextField.topMargin),
            priceTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.horizontalMargin),
            priceTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.horizontalMargin),
            priceTextField.heightAnchor.constraint(equalToConstant: Constants.TextField.height),
            priceTextField.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Constants.bottomMargin)
        ])
        priceTextField.delegate = self
    }
    
    override func setupBindings() {
        viewModel.$recommendTagFieldString
            .receive(on: DispatchQueue.main)
            .sink { [weak self] text in
                self?.tagTextField.text = text
            }
            .store(in: &cancellables)
        
        viewModel.uploadModel.objectWillChange
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self else { return }
                let productModel = self.viewModel.uploadModel

                self.titleTextField.text = productModel.name
                self.titleCountLabel.text = "\(productModel.name?.count ?? 0)"
                self.descriptionTextView.text = productModel.description
                self.descriptionCountLabel.text = "\(productModel.description?.count ?? 0)"
                self.recommendTagCountLabel.text = "\(productModel.artTagList.count)"
                updateDescriptionPlaceholder()

            }
            .store(in: &cancellables)
        
        if viewModel.isEditScene {
            Publishers.CombineLatest3(viewModel.$initialCategoryViewApplyFinished, viewModel.$initialRecommendViewApplyFinished, viewModel.$initialPriceViewApplyFinished)
                .receive(on: DispatchQueue.main)
                .sink { [weak self] categoryFinished, recommendFinished, priceFinished in
                    
                    guard let self else { return }
                    let editModel = viewModel.uploadModel
                    if categoryFinished,
                       recommendFinished,
                       priceFinished {
                        self.titleTextField.text = editModel.name
                        self.descriptionTextView.text = editModel.description
                        if editModel.forSale {
                            self.priceTextField.text = Int(editModel.price ?? 0).toDecimalString()
                        }
                        self.viewModel.price = Int(editModel.price ?? 0)
                        self.syncRecomendTagData(editModel: editModel)
                        self.syncCategoryTagData(editModel: editModel)
                        self.syncPriceTagData(editModel: editModel)
                    }
                }
                .store(in: &cancellables)
        }
    }
    
    private func setupData() {
        categoryTagView.applyItems(viewModel.categories) { [weak self] in
            guard let self else { return }
            self.viewModel.initialCategoryViewApplyFinished = true
        }
        priceTagView.applyItems(viewModel.priceTags) { [weak self] in
            guard let self else { return }
            self.viewModel.initialPriceViewApplyFinished = true
        }
        recommendTagView.applyItems(viewModel.recommendTags) { [weak self] in
            guard let self else { return }
            self.viewModel.initialRecommendViewApplyFinished = true
        }
    }
    
    private func syncRecomendTagData(editModel: ProductUploadModel) {
        var selectedRecomendaryTagIndexes: [Int] = []
        for (idx, category) in self.viewModel.recommendTags.enumerated() {
            let tagName = category.tag ?? ""
            if editModel.artTagList.contains(where: { $0 == tagName }) {
                selectedRecomendaryTagIndexes.append(idx)
                self.viewModel.selectRecommendTag(index: idx, isSelected: true)
            }
        }
        
        self.recommendTagView.selectItems(indexes: selectedRecomendaryTagIndexes)
        self.viewModel.recommendTagFieldString = editModel.artTagList.joined(separator: ", ")
    }
    
    private func syncCategoryTagData(editModel: ProductUploadModel) {
        guard let selectedIdx = viewModel.categories.firstIndex(where: { $0.tag == editModel.category.rawValue }) else { return }
        self.viewModel.selectCategory(index: selectedIdx)
        self.categoryTagView.selectItems(indexes: [selectedIdx])
        self.categoryCountLabel.text = "1"
    }
    
    private func syncPriceTagData(editModel: ProductUploadModel) {
        let idx = editModel.forSale ? 1 : 0
        self.viewModel.selectPriceTag(index: idx)
        self.priceTagView.selectItems(indexes: [idx])
    }
}

// MARK: - ScrollViewDelegate
extension ProductInfoUploadViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
    }
}

// MARK: - TagView
extension ProductInfoUploadViewController: TagViewDelegate {
    func tagView(_ tagView: TagView, didSelectItemAt indexPath: IndexPath) {
        
        switch tagView {
        case categoryTagView:
            viewModel.selectCategory(index: indexPath.row)
            tagView.applyItems(viewModel.categories)
            categoryCountLabel.text = "1"
        case recommendTagView:
            viewModel.selectRecommendTag(index: indexPath.row, isSelected: true)
            tagView.applyItems(viewModel.recommendTags)
        case priceTagView:
            viewModel.selectPriceTag(index: indexPath.row)
            tagView.applyItems(viewModel.priceTags)
            viewModel.uploadModel.forSale = indexPath.row == 0 ? false : true
        default:
            break
        }
    }
    
    func tagView(_ tagView: TagView, didDeselectItemAt indexPath: IndexPath) {
        if tagView == recommendTagView {
            viewModel.selectRecommendTag(index: indexPath.row, isSelected: false)
            tagView.applyItems(viewModel.recommendTags)
        }
    }
    
    func tagView(_ tagView: TagView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        if tagView == recommendTagView {
            return viewModel.uploadModel.artTagList.count < 5
        }
        return true
    }
    
    func invalidateLayout(_ tagView: TagView, contentHeight: CGFloat) {
        if tagView == recommendTagView,
           contentHeight > 1 {
            recommendTagViewHeightConstraint?.constant = contentHeight
            recommendTagCalculatedHeight = contentHeight
            view.layoutIfNeeded()
        }
    }
    
}

// MARK: - TextView
extension ProductInfoUploadViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        updateDescriptionPlaceholder()
    }
    
    private func updateDescriptionPlaceholder() {
        textViewPlaceHolder.isHidden = !descriptionTextView.text.isEmpty
        viewModel.uploadModel.description = descriptionTextView.text
    }
}

// MARK: - TextField
extension ProductInfoUploadViewController: UITextFieldDelegate {

    func textFieldDidChangeSelection(_ textField: UITextField) {
        
        if textField == titleTextField {
            viewModel.uploadModel.name = textField.text
        } else if textField == priceTextField {
            guard let price = textField.text?.replacingOccurrences(of: ",", with: "") else { return }
            viewModel.uploadModel.price = Int64(price) ?? 0
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        guard textField == priceTextField else { return true }
        guard string.containsOnlyDigits else { return false }
        
        // Combine the new text with the existing text
        let currentText = textField.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)

        // Use NumberFormatter to format the text with commas
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 0  // Adjust if you want decimal places

        if let number = formatter.number(from: updatedText.replacingOccurrences(of: formatter.groupingSeparator, with: "")),
           let formattedText = formatter.string(from: number) {
            textField.text = formattedText
            return false
        }

        // Return true for non-numeric inputs to allow backspace to work
        return string.isEmpty
    }
    
    @objc private func tagFieldDidChanged(_ textField: UITextField) {
    }
}
