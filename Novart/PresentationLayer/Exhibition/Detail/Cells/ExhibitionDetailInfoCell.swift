//
//  ExhibitionDetailInfoCell.swift
//  Novart
//
//  Created by Jinwook Huh on 2023/11/05.
//

import UIKit
import Combine
import Kingfisher
import ColorThiefSwift

final class ExhibitionDetailInfoCell: UICollectionViewCell {
    
    // MARK: - Constants
    
    private enum Constants {
        
        static let topMargin: CGFloat = 24
        static let horizontalMargin: CGFloat = 24
        
        enum Poster {
            static let width: CGFloat = 138
            static let height: CGFloat = 188
            static let cornerRadius: CGFloat = 6
            static let bottomMargin: CGFloat = 8
        }
        
        enum Title {
            static let font: UIFont = .systemFont(ofSize: 16, weight: .semibold)
            static let textColor: UIColor = UIColor.Common.warmBlack
            static let subtitleFont: UIFont = .systemFont(ofSize: 14, weight: .light)
            static let subtitleColor: UIColor = UIColor.Common.warmGrey03
            static let spacing: CGFloat = 2
            static let bottomMargin: CGFloat = 8
        }
        
        enum Description {
            static let font: UIFont = .systemFont(ofSize: 14, weight: .regular)
            static let textColor: UIColor = UIColor.Common.warmBlack
            static let bottomMargin: CGFloat = 32
        }
        
        enum Info {
            static let titleFont: UIFont = .systemFont(ofSize: 16, weight: .semibold)
            static let font: UIFont = .systemFont(ofSize: 16, weight: .regular)
            static let textColor: UIColor = UIColor.Common.warmBlack
            static let lineSpacing: CGFloat = 4
            static let collectionViewSpacing: CGFloat = 12
            static let spacing: CGFloat = 32
        }
        
        enum Participant {
            static let height: CGFloat = 70
            static let spacing: CGFloat = 32
            static let bottomMargin: CGFloat = 24
        }
    }
    
    // MARK: - UI
    
    private lazy var posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = Constants.Poster.cornerRadius
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = Constants.Title.font
        label.textColor = Constants.Title.textColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = Constants.Title.subtitleFont
        label.textColor = Constants.Title.subtitleColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = Constants.Description.font
        label.textColor = Constants.Description.textColor
        label.numberOfLines = 0
        label.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var categoryTitleLabel: UILabel = {
        let label = UILabel()
        label.font = Constants.Info.titleFont
        label.textColor = Constants.Info.textColor
        label.text = "카테고리"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var categoryLabel: UILabel = {
        let label = UILabel()
        label.font = Constants.Info.font
        label.textColor = Constants.Info.textColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var countTitleLabel: UILabel = {
        let label = UILabel()
        label.font = Constants.Info.titleFont
        label.textColor = Constants.Info.textColor
        label.text = "작품수"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var countLabel: UILabel = {
        let label = UILabel()
        label.font = Constants.Info.font
        label.textColor = Constants.Info.textColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var durationTitleLabel: UILabel = {
        let label = UILabel()
        label.font = Constants.Info.titleFont
        label.textColor = Constants.Info.textColor
        label.text = "관람 예상소요"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var durationLabel: UILabel = {
        let label = UILabel()
        label.font = Constants.Info.font
        label.textColor = Constants.Info.textColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var participantTitleLabel: UILabel = {
        let label = UILabel()
        label.font = Constants.Info.titleFont
        label.textColor = Constants.Info.textColor
        label.text = "참여작가"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(ParticipantCell.self, forCellWithReuseIdentifier: ParticipantCell.reuseIdentifier)
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
    private lazy var shortcutView: ExhibitionShortcutView = {
        let view = ExhibitionShortcutView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.delegate = self
        return view
    }()
    
    // MARK: - Properties
    
    private var viewModel: ExhibitionDetailInfoModel? {
        didSet {
            if let viewModel {
                setData(viewModel: viewModel)
            }
        }
    }
    
    var shortcutViewXOffset: CGFloat {
        get {
            return shortcutView.contentXOffset
        } set {
            shortcutView.contentXOffset = newValue
        }
    }
    
    func setSelected(at index: Int) {
        shortcutView.setSelected(at: index)
    }
    
    weak var input: PassthroughSubject<(ExhibitionDetailViewController.ArtCellInput, Int64), Never>?
    var exhibitionShortcutViewXOffsetSubject: PassthroughSubject<CGFloat, Never> = .init()
    var selectedShorcutIndexSubject: PassthroughSubject<Int, Never> = .init()
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
        contentView.addSubview(posterImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(subtitleLabel)
        NSLayoutConstraint.activate([
            posterImageView.widthAnchor.constraint(equalToConstant: Constants.Poster.width),
            posterImageView.heightAnchor.constraint(equalToConstant: Constants.Poster.height),
            posterImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            posterImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constants.topMargin),
            titleLabel.topAnchor.constraint(equalTo: posterImageView.bottomAnchor, constant: Constants.Poster.bottomMargin),
            titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: Constants.Title.spacing),
            subtitleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
        ])
        
        contentView.addSubview(descriptionLabel)
        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: Constants.Title.bottomMargin),
            descriptionLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            descriptionLabel.leadingAnchor.constraint(greaterThanOrEqualTo: contentView.leadingAnchor, constant: Constants.horizontalMargin),
            descriptionLabel.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -Constants.horizontalMargin)
        ])
        
        contentView.addSubview(categoryTitleLabel)
        contentView.addSubview(categoryLabel)
        contentView.addSubview(countTitleLabel)
        contentView.addSubview(countLabel)
        contentView.addSubview(durationTitleLabel)
        contentView.addSubview(durationLabel)
        contentView.addSubview(participantTitleLabel)
        
        NSLayoutConstraint.activate([
            categoryTitleLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: Constants.Description.bottomMargin),
            categoryTitleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            categoryLabel.topAnchor.constraint(equalTo: categoryTitleLabel.bottomAnchor, constant: Constants.Info.lineSpacing),
            categoryLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            countTitleLabel.topAnchor.constraint(equalTo: categoryLabel.bottomAnchor, constant: Constants.Info.spacing),
            countTitleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            countLabel.topAnchor.constraint(equalTo: countTitleLabel.bottomAnchor, constant: Constants.Info.lineSpacing),
            countLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            durationTitleLabel.topAnchor.constraint(equalTo: countLabel.bottomAnchor, constant: Constants.Info.spacing),
            durationTitleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            durationLabel.topAnchor.constraint(equalTo: durationTitleLabel.bottomAnchor, constant: Constants.Info.lineSpacing),
            durationLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            participantTitleLabel.topAnchor.constraint(equalTo: durationLabel.bottomAnchor, constant: Constants.Info.spacing),
            participantTitleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
        ])
        
        collectionView.setCollectionViewLayout(collectionViewLayout, animated: false)
        contentView.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.heightAnchor.constraint(equalToConstant: Constants.Participant.height),
            collectionView.topAnchor.constraint(equalTo: participantTitleLabel.bottomAnchor, constant: Constants.Info.collectionViewSpacing),
            collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
        
        contentView.addSubview(shortcutView)
        NSLayoutConstraint.activate([
            shortcutView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            shortcutView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            shortcutView.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: Constants.Participant.bottomMargin),
            shortcutView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}

extension ExhibitionDetailInfoCell {
    func update(with data: ExhibitionDetailInfoModel) {
        viewModel = data
    }
    
    func setData(viewModel: ExhibitionDetailInfoModel) {
        if let posterImageUrl = viewModel.posterImageUrl {
            let url = URL(string: posterImageUrl)
            posterImageView.kf.setImage(with: url) { [weak self] _ in
                guard let self else { return }
                if let dominant = ColorThief.getColor(from: self.posterImageView.image ?? UIImage())?.makeUIColor() {
                    let hueValue = dominant.getHsb().0
                    let hsbColor = UIColor(hue: hueValue / 360, saturation: 0.08, brightness: 0.95, alpha: 1.0)
                    self.contentView.backgroundColor = hsbColor
                    self.input?.send((.didProcessDominantColor(color: hsbColor), 0))
                }
            }
        }
        titleLabel.text = viewModel.title
        subtitleLabel.text = viewModel.subtitle
        countLabel.text = viewModel.count
        categoryLabel.text = viewModel.category ?? "없음"
        durationLabel.text = viewModel.duration
        descriptionLabel.text = viewModel.description
        shortcutView.setThumbnails(urls: viewModel.shortcutThumbnailUrls)
        collectionView.reloadData()
    }
}

extension ExhibitionDetailInfoCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        didTapArtist(index: indexPath.row)
    }
}

extension ExhibitionDetailInfoCell: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.participants.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let viewModel, let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ParticipantCell.reuseIdentifier, for: indexPath) as? ParticipantCell else { return UICollectionViewCell() }
        let participant = viewModel.participants[indexPath.row]
        cell.update(with: participant)
        return cell
    }
}

extension ExhibitionDetailInfoCell {
    var sectionLayout: NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .estimated(1.0), heightDimension: .absolute(Constants.Participant.height))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .estimated(1.0), heightDimension: .absolute(Constants.Participant.height))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.interGroupSpacing = Constants.Participant.spacing
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: Constants.horizontalMargin, bottom: 0, trailing: Constants.horizontalMargin)
        return section
    }
    
    var collectionViewLayout: UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { [weak self] (sectionIndex: Int, layoutEnv: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            
            guard let self else { return nil }
            return self.sectionLayout
        }
        return layout
    }
}

extension ExhibitionDetailInfoCell: ExhibitionShortcutViewDelegate {
    func exhibitionShortcutViewDidScroll(scrollView: UIScrollView) {
        exhibitionShortcutViewXOffsetSubject.send(scrollView.contentOffset.x)
    }
    
    func exhibitionShortcutViewDidSelectIndexAt(index: Int) {
        selectedShorcutIndexSubject.send(index)
    }
}

// MARK: - Tap
private extension ExhibitionDetailInfoCell {
    private func didTapArtist(index: Int) {
        guard let artist = viewModel?.participants[index] else { return }
        self.input?.send((.shouldShowProfile, artist.id))
    }
}
