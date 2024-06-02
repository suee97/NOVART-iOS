import UIKit
import SnapKit
import Combine

final class ExhibitionGuideViewController: BaseViewController {
    
    // MARK: - Constants
    private enum Constants {
        static let screenWidth = UIScreen.main.bounds.width
        
        enum GrabberView {
            static let width: CGFloat = 40
            static let height: CGFloat = 4
            static let color = UIColor.Common.warmGrey02
            static let radius: CGFloat = 2
            static let topMargin: CGFloat = 12
        }
        
        enum InfoLabel {
            static let text = "전시 안내"
            static let topMargin: CGFloat = 8
        }
        
        enum PosterImageView {
            static let width: CGFloat = 86
            static let height: CGFloat = 118
            static let radius: CGFloat = 4
            static let topMargin: CGFloat = 18
        }
        
        enum NameLabel {
            static let topMargin: CGFloat = 8
        }
        
        enum EngNameLabel {
            static let font = UIFont(name: "SFProDisplay-Regular", size: 14)
            static let textColor = UIColor.Common.warmGrey03
            static let topMargin: CGFloat = 2
        }
        
        enum DescriptionLabel {
            static let font = UIFont.systemFont(ofSize: 14, weight: .regular)
            static let textColor = UIColor.Common.warmBlack
            static let topMargin: CGFloat = 8
            static let numberOfLines = 5
            static let horizontalMargin: CGFloat = 24
        }
        
        enum OpenExhibitionButton {
            static let text = "관람하기"
            static let textColor = UIColor.Common.white
            static let font = UIFont.systemFont(ofSize: 16, weight: .bold)
            static let backgroundColor = UIColor.Common.warmBlack
            static let radius: CGFloat = 12
            static let height: CGFloat = 54
            static let bottomMargin: CGFloat = 32
            static let horizontalMargin: CGFloat = 24
        }
        
        enum ArtistCollectionView {
            static let height: CGFloat = 70
            static let bottomMargin: CGFloat = 12
            static let cellSize = CGSize(width: 70, height: 70)
            static let cellSpace: CGFloat = 28
            static let inset = UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 24)
        }
        
        enum ParticipantArtistLabel {
            static let text = "참여작가"
            static let bottomMargin: CGFloat = 12
        }
        
        enum EstimatedDurationSubLabel {
            static let bottomMargin: CGFloat = 32
        }
        
        enum EstimatedDurationLabel {
            static let text = "관람 예상소요"
            static let bottomMargin: CGFloat = 4
        }
        
        enum ArtCountSubLabel {
            static let bottomMargin: CGFloat = 32
        }
        
        enum ArtCountLabel {
            static let text = "작품수"
            static let bottomMargin: CGFloat = 4
        }
        
        enum CategorySubLabel {
            static let bottomMargin: CGFloat = 32
        }
        
        enum CategoryLabel {
            static let text = "카테고리"
            static let bottomMargin: CGFloat = 4
        }
    }
    
    
    // MARK: - Properties
    private let viewModel: ExhibitionGuideViewModel
    private var cancellables = Set<AnyCancellable>()
    
    init(viewModel: ExhibitionGuideViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        artistCollectionView.delegate = self
        artistCollectionView.dataSource = self
        artistCollectionView.register(ExhibitionGuideArtistCell.self, forCellWithReuseIdentifier: ExhibitionGuideArtistCell.reuseIdentifier)
    }
    
    
    // MARK: - Binding
    override func setupBindings() {
        viewModel.$exhibitionInfo.receive(on: DispatchQueue.main).sink(receiveValue: { [weak self] exhibitionInfo in
            guard let self else { return }
            self.artistCollectionView.reloadData()
            self.categorySubLabel.text = exhibitionInfo?.category ?? "-"
            self.artCountSubLabel.text = exhibitionInfo?.artCount ?? "-"
            self.estimatedDurationSubLabel.text = exhibitionInfo?.estimationDuration ?? "-"
            self.nameLabel.text = exhibitionInfo?.name ?? "-"
            self.engNameLabel.text = exhibitionInfo?.englishName ?? "-"
            self.descriptionLabel.text = exhibitionInfo?.description ?? "-"
            if let posterUrlString = exhibitionInfo?.posterImageUrl, let posterUrl = URL(string: posterUrlString) {
                self.posterImageView.kf.setImage(with: posterUrl)
            }
        }).store(in: &cancellables)
    }
    
    
    // MARK: - UI
    private let grabberView: UIView = {
        let view = UIView()
        view.backgroundColor = Constants.GrabberView.color
        view.layer.cornerRadius = Constants.GrabberView.radius
        return view
    }()
    
    
    private let infoLabel = UILabel.makeExhibitionGuideLabel(text: Constants.InfoLabel.text, type: .title)
    
    private let posterImageView: UIImageView = {
        let imageView = UIImageView(image: nil)
        imageView.layer.cornerRadius = Constants.PosterImageView.radius
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .white
        return imageView
    }()
    
    private let nameLabel = UILabel.makeExhibitionGuideLabel(text: "", type: .title)
    
    private let engNameLabel: UILabel = {
        let label = UILabel()
        label.font = Constants.EngNameLabel.font
        label.textColor = Constants.EngNameLabel.textColor
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = Constants.DescriptionLabel.font
        label.textColor = Constants.DescriptionLabel.textColor
        label.adjustsFontSizeToFitWidth = false
        label.lineBreakMode = .byTruncatingTail
        label.textAlignment = .center
        label.numberOfLines = Constants.DescriptionLabel.numberOfLines
        return label
    }()
    
    private lazy var openExhibitionButton: UIButton = {
        let button = UIButton()
        button.setTitle(Constants.OpenExhibitionButton.text, for: .normal)
        button.titleLabel?.font = Constants.OpenExhibitionButton.font
        button.setTitleColor(Constants.OpenExhibitionButton.textColor, for: .normal)
        button.backgroundColor = Constants.OpenExhibitionButton.backgroundColor
        button.layer.cornerRadius = Constants.OpenExhibitionButton.radius
        button.addAction(UIAction(handler: { [weak self] _ in
            guard let self else { return }
            self.viewModel.showExhibitionDetail()
        }), for: .touchUpInside)
        return button
    }()
    
    private lazy var artistCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = Constants.ArtistCollectionView.cellSize
        layout.minimumInteritemSpacing = Constants.ArtistCollectionView.cellSpace
        layout.sectionInset = Constants.ArtistCollectionView.inset
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = viewModel.getBackgroundColor()
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    private let participantArtistLabel = UILabel.makeExhibitionGuideLabel(text: Constants.ParticipantArtistLabel.text, type: .title)
    
    private let estimatedDurationSubLabel = UILabel.makeExhibitionGuideLabel(text: "", type: .subTitle)
    
    private let estimatedDurationLabel = UILabel.makeExhibitionGuideLabel(text: Constants.EstimatedDurationLabel.text, type: .title)
    
    private let artCountSubLabel = UILabel.makeExhibitionGuideLabel(text: "", type: .subTitle)
    
    private let artCountLabel = UILabel.makeExhibitionGuideLabel(text: Constants.ArtCountLabel.text, type: .title)
    
    private let categorySubLabel = UILabel.makeExhibitionGuideLabel(text: "", type: .subTitle)
    
    private let categoryLabel = UILabel.makeExhibitionGuideLabel(text: Constants.CategoryLabel.text, type: .title)
    
    override func setupView() {
        view.backgroundColor = viewModel.getBackgroundColor()
        
        view.addSubview(grabberView)
        view.addSubview(infoLabel)
        view.addSubview(posterImageView)
        view.addSubview(nameLabel)
        view.addSubview(engNameLabel)
        view.addSubview(descriptionLabel)
        view.addSubview(openExhibitionButton)
        view.addSubview(artistCollectionView)
        view.addSubview(participantArtistLabel)
        view.addSubview(estimatedDurationSubLabel)
        view.addSubview(estimatedDurationLabel)
        view.addSubview(artCountSubLabel)
        view.addSubview(artCountLabel)
        view.addSubview(categorySubLabel)
        view.addSubview(categoryLabel)
        
        grabberView.snp.makeConstraints({ m in
            m.width.equalTo(Constants.GrabberView.width)
            m.height.equalTo(Constants.GrabberView.height)
            m.top.equalToSuperview().inset(Constants.GrabberView.topMargin)
            m.centerX.equalToSuperview()
        })
        
        infoLabel.snp.makeConstraints({ m in
            m.top.equalTo(grabberView.snp.bottom).offset(Constants.InfoLabel.topMargin)
            m.centerX.equalToSuperview()
        })
        
        posterImageView.snp.makeConstraints({ m in
            m.width.equalTo(Constants.PosterImageView.width)
            m.height.equalTo(Constants.PosterImageView.height)
            m.top.equalTo(infoLabel.snp.bottom).offset(Constants.PosterImageView.topMargin)
            m.centerX.equalToSuperview()
        })
        
        nameLabel.snp.makeConstraints({ m in
            m.top.equalTo(posterImageView.snp.bottom).offset(Constants.NameLabel.topMargin)
            m.centerX.equalToSuperview()
        })
        
        engNameLabel.snp.makeConstraints({ m in
            m.top.equalTo(nameLabel.snp.bottom).offset(Constants.EngNameLabel.topMargin)
            m.centerX.equalToSuperview()
        })
        
        descriptionLabel.snp.makeConstraints({ m in
            m.top.equalTo(engNameLabel.snp.bottom).offset(Constants.DescriptionLabel.topMargin)
            m.left.right.equalToSuperview().inset(Constants.DescriptionLabel.horizontalMargin)
        })
        
        openExhibitionButton.snp.makeConstraints({ m in
            m.height.equalTo(Constants.OpenExhibitionButton.height)
            m.left.right.equalToSuperview().inset(Constants.OpenExhibitionButton.horizontalMargin)
            m.bottom.equalToSuperview().inset(Constants.OpenExhibitionButton.bottomMargin)
        })
        
        artistCollectionView.snp.makeConstraints({ m in
            m.left.right.equalToSuperview()
            m.height.equalTo(Constants.ArtistCollectionView.height)
            m.bottom.equalTo(openExhibitionButton.snp.top).offset(-Constants.ArtistCollectionView.bottomMargin)
        })
        
        participantArtistLabel.snp.makeConstraints({ m in
            m.bottom.equalTo(artistCollectionView.snp.top).offset(-Constants.ParticipantArtistLabel.bottomMargin)
            m.centerX.equalToSuperview()
        })
        
        estimatedDurationSubLabel.snp.makeConstraints({ m in
            m.bottom.equalTo(participantArtistLabel.snp.top).offset(-Constants.EstimatedDurationSubLabel.bottomMargin)
            m.centerX.equalToSuperview()
        })
        
        estimatedDurationLabel.snp.makeConstraints({ m in
            m.bottom.equalTo(estimatedDurationSubLabel.snp.top).offset(-Constants.EstimatedDurationLabel.bottomMargin)
            m.centerX.equalToSuperview()
        })
        
        artCountSubLabel.snp.makeConstraints({ m in
            m.bottom.equalTo(estimatedDurationLabel.snp.top).offset(-Constants.ArtCountSubLabel.bottomMargin)
            m.centerX.equalToSuperview()
        })
        
        artCountLabel.snp.makeConstraints({ m in
            m.bottom.equalTo(artCountSubLabel.snp.top).offset(-Constants.ArtCountLabel.bottomMargin)
            m.centerX.equalToSuperview()
        })
        
        categorySubLabel.snp.makeConstraints({ m in
            m.bottom.equalTo(artCountLabel.snp.top).offset(-Constants.CategorySubLabel.bottomMargin)
            m.centerX.equalToSuperview()
        })
        
        categoryLabel.snp.makeConstraints({ m in
            m.bottom.equalTo(categorySubLabel.snp.top).offset(-Constants.CategoryLabel.bottomMargin)
            m.centerX.equalToSuperview()
        })
    }
    
}


// MARK: - CollectionView
extension ExhibitionGuideViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.getArtistCount()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ExhibitionGuideArtistCell.reuseIdentifier, for: indexPath) as? ExhibitionGuideArtistCell else { return UICollectionViewCell() }
        let artist = viewModel.getArtist(index: indexPath.row)
        cell.update(backgroundColor: viewModel.getBackgroundColor(), artist: artist)
        return cell
    }
    
}


// MARK: - ExhibitionGuideLabel
fileprivate enum LabelType {
    case title
    case subTitle
}

private extension UILabel {
    static func makeExhibitionGuideLabel(text: String, type: LabelType) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = UIFont.systemFont(ofSize: 16, weight: type == .subTitle ? .regular : .semibold)
        label.textColor = UIColor.Common.warmBlack
        return label
    }
}
