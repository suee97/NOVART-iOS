import UIKit
import SnapKit
import Kingfisher

final class MyPageWorkCell: UICollectionViewCell {
    
    // MARK: - Constants
    private enum Constants {
        static let screenWidth = UIScreen.main.bounds.width
        
        enum ContentView {
            static let radius: CGFloat = 12
            static let backgroundColor = UIColor.Common.grey01_light
            static let shadowColor = UIColor.black.cgColor
            static let shadowOpacity: Float = 0.1
            static let shadowOffset = CGSize(width: 0, height: 2)
        }
        
        enum WorkImageView {
            static let radius: CGFloat = 12
            static let height: CGFloat = (Constants.screenWidth - 60) / 2
        }
        
        enum WorkNameLabel {
            static let font = UIFont.systemFont(ofSize: 14, weight: .bold)
            static let color = UIColor.Common.black
            static let leftMargin: CGFloat = 12
            static let rightMargin: CGFloat = 12
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
    private let workImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = Constants.WorkImageView.radius
        imageView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let workNameLabel: UILabel = {
        let label = UILabel()
        label.font = Constants.WorkNameLabel.font
        label.textColor = Constants.WorkNameLabel.color
        return label
    }()
    
    private func setUpView() {
        contentView.backgroundColor = Constants.ContentView.backgroundColor
        contentView.layer.cornerRadius = Constants.ContentView.radius
        contentView.clipsToBounds = true
        
        contentView.layer.shadowColor = Constants.ContentView.shadowColor
        contentView.layer.shadowOpacity = Constants.ContentView.shadowOpacity
        contentView.layer.shadowOffset = Constants.ContentView.shadowOffset
        contentView.layer.masksToBounds = false
        
        contentView.addSubview(workImageView)
        contentView.addSubview(workNameLabel)
        
        workImageView.snp.makeConstraints({ m in
            m.left.right.top.equalToSuperview()
            m.height.equalTo(Constants.WorkImageView.height)
        })
        
        workNameLabel.snp.makeConstraints({ m in
            m.top.equalTo(workImageView.snp.bottom)
            m.left.equalToSuperview().inset(Constants.WorkNameLabel.leftMargin)
            m.right.equalToSuperview().inset(Constants.WorkNameLabel.rightMargin)
            m.bottom.equalToSuperview()
        })
    }
}

extension MyPageWorkCell {
    func update(with item: MyPageWork) {
        if let urlString = item.thumbnailImageUrl, let url = URL(string: urlString), let workName = item.name {
            workImageView.kf.setImage(with: url)
            workNameLabel.text = workName
        }
    }
}
