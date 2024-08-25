import UIKit
import SnapKit
import Kingfisher

final class MyPageExhibitionCell: UICollectionViewCell {
    
    // MARK: - Constants
    private enum Constants {
        static let screenWidth = UIScreen.main.bounds.width
        
        enum ContentView {
            static let radius: CGFloat = 12
            static let backgroundColor = UIColor.Common.white
            static let shadowColor = UIColor.black.cgColor
            static let shadowOpacity: Float = 0.1
            static let shadowOffset = CGSize(width: 0, height: 2)
        }
        
        enum ExhibitionImageView {
            static let radius: CGFloat = 12
            static let height: CGFloat = (Constants.screenWidth - 48) * (472/342)
        }
        
        enum WatchLabel {
            static let text = "관람하기"
            static let font = UIFont.systemFont(ofSize: 18, weight: .semibold)
            static let color = UIColor.Common.warmBlack
            static let topMargin: CGFloat = Constants.ExhibitionImageView.height * (15/472)
        }
    }
    
    
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - UI
    private let exhibitionImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = Constants.ExhibitionImageView.radius
        imageView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let watchLabel: UILabel = {
        let label = UILabel()
        label.text = Constants.WatchLabel.text
        label.font = Constants.WatchLabel.font
        label.textColor = Constants.WatchLabel.color
        return label
    }()
    
    private func setUpView() {
        contentView.backgroundColor = Constants.ContentView.backgroundColor
        contentView.clipsToBounds = true

        contentView.layer.cornerRadius = Constants.ContentView.radius
        contentView.layer.shadowColor = Constants.ContentView.shadowColor
        contentView.layer.shadowOpacity = Constants.ContentView.shadowOpacity
        contentView.layer.shadowOffset = Constants.ContentView.shadowOffset
        contentView.layer.masksToBounds = false
    
        contentView.addSubview(exhibitionImageView)
        contentView.addSubview(watchLabel)
        
        exhibitionImageView.snp.makeConstraints({ m in
            m.top.left.right.equalToSuperview()
            m.height.equalTo(Constants.ExhibitionImageView.height)
        })
        
        watchLabel.snp.makeConstraints({ m in
            m.centerX.equalToSuperview()
            m.top.equalTo(exhibitionImageView.snp.bottom).offset(Constants.WatchLabel.topMargin)
        })
    }
}

extension MyPageExhibitionCell {
    func update(with item: ExhibitionModel) {
        if let urlString = item.posterImageUrl, let url = URL(string: urlString) {
            exhibitionImageView.kf.setImage(with: url)
        }
    }
}
