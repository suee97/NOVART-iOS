import UIKit
import SnapKit
import Kingfisher

final class ExhibitionGuideArtistCell: UICollectionViewCell {
    
    // MARK: - Constants
    private enum Constants {
        enum ProfileImageView {
            static let diameter: CGFloat = 32
        }
        
        enum nameLabel {
            static let font = UIFont.systemFont(ofSize: 12, weight: .bold)
            static let textColor = UIColor.Common.warmBlack
            static let topMargin: CGFloat = 4
        }
        
        enum jobLabel {
            static let font = UIFont.systemFont(ofSize: 12, weight: .regular)
            static let textColor = UIColor.Common.warmBlack
            static let width: CGFloat = 70
        }
    }
    
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setUpView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Lifecycle
    override func prepareForReuse() {
        super.prepareForReuse()
        profileImageView.image = nil
    }
    
    
    // MARK: - UI
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = Constants.ProfileImageView.diameter / 2
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = Constants.nameLabel.font
        label.textColor = Constants.nameLabel.textColor
        label.textAlignment = .center
        return label
    }()
    
    private let jobLabel: UILabel = {
        let label = UILabel()
        label.font = Constants.jobLabel.font
        label.textColor = Constants.jobLabel.textColor
        label.textAlignment = .center
        return label
    }()
    
    private func setUpView() {
        contentView.addSubview(profileImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(jobLabel)
        
        profileImageView.snp.makeConstraints({ m in
            m.top.centerX.equalToSuperview()
            m.width.height.equalTo(Constants.ProfileImageView.diameter)
        })
        
        nameLabel.snp.makeConstraints({ m in
            m.top.equalTo(profileImageView.snp.bottom).offset(Constants.nameLabel.topMargin)
            m.centerX.equalToSuperview()
            m.width.equalToSuperview()
        })
        
        jobLabel.snp.makeConstraints({ m in
            m.top.equalTo(nameLabel.snp.bottom)
            m.centerX.equalToSuperview()
            m.width.equalToSuperview()
        })
    }
    
    func update(backgroundColor: UIColor, artist: ExhibitionParticipantModelTmp?) {
        contentView.backgroundColor = backgroundColor
        guard let artist else { return }
        if let imageUrlString = artist.profileImageUrl, let url = URL(string: imageUrlString) {
            profileImageView.kf.setImage(with: url)
        } else {
            profileImageView.image = UIImage(named: "default_user_profile_image")
        }
        
        let nickname = artist.nickname ?? ""
        let job = artist.job ?? ""
        nameLabel.text = nickname
        jobLabel.text = job
    }
}
