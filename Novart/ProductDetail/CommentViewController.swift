//
//  CommentViewController.swift
//  Novart
//
//  Created by Jinwook Huh on 2023/10/28.
//

import UIKit
import Combine

final class CommentViewController: BaseViewController {
    
    // MARK: - Constants
    
    enum Constants {
        static let screenWidth: CGFloat = UIScreen.main.bounds.width
        static let horizontalInsets: CGFloat = 24
        static let itemSpacing: CGFloat = 12
        
        enum Title {
            static let font: UIFont = .systemFont(ofSize: 16, weight: .semibold)
            static let textColor: UIColor = UIColor.Common.black
            static let text: String = "의견"
            static let topMargin: CGFloat = 24
            static let bottomMargin: CGFloat = 10
        }
    }
    
    // MARK: - UI
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = Constants.Title.text
        label.font = Constants.Title.font
        label.textColor = Constants.Title.textColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var closeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "icon_close"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addAction(UIAction(handler: { [weak self] _ in
            self?.dismiss(animated: true)
        }), for: .touchUpInside)
        return button
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(CommentCell.self, forCellReuseIdentifier: CommentCell.reuseIdentifier)
        tableView.separatorStyle = .none
        return tableView
    }()
    
    // MARK: - Properties
    
    private var viewModel: CommentViewModel
    private var subscriptions: Set<AnyCancellable> = .init()
    
    // MARK: - Initialization

    init(viewModel: CommentViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    
    override func setupView() {
        view.backgroundColor = .white
        
        view.addSubview(titleLabel)
        view.addSubview(closeButton)
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: Constants.Title.topMargin),
            closeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.horizontalInsets),
            closeButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor)
        ])
        
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: Constants.Title.bottomMargin),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.horizontalInsets),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.horizontalInsets),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        tableView.delegate = self
        tableView.dataSource = self
    }
}

extension CommentViewController: UITableViewDelegate {

}

extension CommentViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CommentCell.reuseIdentifier, for: indexPath) as? CommentCell else { return UITableViewCell() }
        cell.update(with: viewModel.comments[indexPath.row])
        return cell
    }
}
