//
//  ExhibitionShortcutView.swift
//  Novart
//
//  Created by Jinwook Huh on 2024/01/14.
//

import UIKit

protocol ExhibitionShortcutViewDelegate: AnyObject {
    func exhibitionShortcutViewDidScroll(scrollView: UIScrollView)
    func exhibitionShortcutViewDidSelectIndexAt(index: Int)
}

final class ExhibitionShortcutView: UIView {
    
    private enum Constants {
        static let topMargin: CGFloat = 12
        static let bottomMargin: CGFloat = 10
        static let horizontalInset: CGFloat = 24
        static let spacing: CGFloat = 16
    }
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.addSubview(stackView)
        scrollView.isScrollEnabled = true
        scrollView.isUserInteractionEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.contentInset = UIEdgeInsets(top: 0, left: Constants.horizontalInset, bottom: 0, right: Constants.horizontalInset)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.delegate = self
        return scrollView
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        stackView.spacing = Constants.spacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    weak var delegate: ExhibitionShortcutViewDelegate?
    var contentXOffset: CGFloat {
        get {
            return scrollView.contentOffset.x
        } set {
            let newOffset = CGPoint(x: newValue, y: scrollView.contentOffset.y)
            scrollView.contentOffset = newOffset
        }
    }
    
    init() {
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        backgroundColor = UIColor.Common.white
        addSubview(scrollView)
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: self.topAnchor, constant: Constants.topMargin),
            scrollView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -Constants.bottomMargin),
            
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            stackView.heightAnchor.constraint(equalTo: scrollView.heightAnchor)
        ])
    }
    
    func setThumbnails(urls: [String]) {
        if !stackView.arrangedSubviews.isEmpty {
            for view in stackView.arrangedSubviews {
                stackView.removeArrangedSubview(view)
                view.removeFromSuperview()
            }
        }
        
        for (idx, url) in urls.enumerated() {
            let view = ExhibitionShortcutItemView(thumbnailUrl: url)
            if idx == 0 {
                view.isSelected = true
            }
            view.didTap = { [weak self] in
                guard let self else { return }
                
                for itemView in self.stackView.arrangedSubviews {
                    guard let itemView = itemView as? ExhibitionShortcutItemView else { return }
                    if itemView == view {
                        itemView.isSelected = true
                    } else {
                        itemView.isSelected = false
                    }
                }
                self.delegate?.exhibitionShortcutViewDidSelectIndexAt(index: idx)
            }
            stackView.addArrangedSubview(view)
        }
    }
}

extension ExhibitionShortcutView: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        delegate?.exhibitionShortcutViewDidScroll(scrollView: scrollView)
    }
}
