import UIKit
import Kingfisher

final class MyPageNotificationCell: UICollectionViewCell {
    
    // MARK: - Constants
    private enum Constants {
        
        enum ContentView {
            static let radius: CGFloat = 12
            static let hightlightedColor: UIColor = .Common.grey00
            static let unHightlightedColor: UIColor = .Common.white
        }
        
        enum ProfileImageView {
            static let topMargin: CGFloat = 16
            static let leftMargin: CGFloat = 16
            static let diameter: CGFloat = 48
            static let radius: CGFloat = 24
        }
        
        enum NotificationLabel {
            static let topMargin: CGFloat = 16
            static let leftMargin: CGFloat = 12
            static let rightMargin: CGFloat = 16
            static let color: UIColor = .Common.black
            static let font = UIFont.systemFont(ofSize: 16, weight: .medium)
        }
        
        enum TimeLabel {
            static let topMargin: CGFloat = 8
            static let color: UIColor = .Common.grey02
            static let font = UIFont.systemFont(ofSize: 14, weight: .regular)
        }
    }
    
    
    // MARK: - Properties
    override var isHighlighted: Bool {
        didSet {
            contentView.backgroundColor = isHighlighted ? Constants.ContentView.hightlightedColor : Constants.ContentView.unHightlightedColor
        }
    }
    
    // MARK: - LifeCycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - UI
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = Constants.ProfileImageView.radius
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let notificationLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = Constants.NotificationLabel.color
        label.font = Constants.NotificationLabel.font
        return label
    }()
    
    let timeLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = Constants.TimeLabel.color
        label.font = Constants.TimeLabel.font
        return label
    }()
    
    private func setUpView() {
        contentView.layer.cornerRadius = Constants.ContentView.radius
        
        contentView.addSubview(profileImageView)
        contentView.addSubview(notificationLabel)
        contentView.addSubview(timeLabel)
        
        profileImageView.snp.makeConstraints({ m in
            m.left.equalToSuperview().inset(Constants.ProfileImageView.leftMargin)
            m.top.equalToSuperview().inset(Constants.ProfileImageView.topMargin)
            m.width.height.equalTo(Constants.ProfileImageView.diameter)
        })
        
        notificationLabel.snp.makeConstraints({ m in
            m.top.equalToSuperview().inset(Constants.NotificationLabel.topMargin)
            m.left.equalTo(profileImageView.snp.right).offset(Constants.NotificationLabel.leftMargin)
            m.right.equalToSuperview().inset(Constants.NotificationLabel.rightMargin)
        })
        
        timeLabel.snp.makeConstraints({ m in
            m.left.equalTo(notificationLabel.snp.left)
            m.top.equalTo(notificationLabel.snp.bottom).offset(Constants.TimeLabel.topMargin)
        })
    }
    
    
    // MARK: - Functions
    func update(notification: MyPageNotificationModel) {
        guard let imgUrl = notification.imgUrl, let url = URL(string: imgUrl) else { return }
        profileImageView.kf.setImage(with: url)
        notificationLabel.text = notification.message
        timeLabel.text = getTimeText(from: notification.createdAt)
    }
    
    private func getTimeText(from createdAt: String) -> String {
        let current = Date()
        let dateFormmatter = DateFormatter()
        
        dateFormmatter.locale = Locale(identifier: "ko_KR")
        dateFormmatter.timeZone = TimeZone(abbreviation: "KST")
        dateFormmatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let currentDateString = dateFormmatter.string(from: current)
        guard let currentInterval = dateFormmatter.date(from: currentDateString)?.timeIntervalSince1970 else { return "" }
        
        let createdDateString = createdAt.replacingOccurrences(of: "T", with: " ")
        let startIndex = createdDateString.startIndex
        let endIndex = createdAt.index(createdDateString.endIndex, offsetBy: -6)
        
        guard let createdInterval = dateFormmatter.date(from: String(createdDateString[startIndex...endIndex]))?.timeIntervalSince1970 else { return "" }
        
        let diff = Int(currentInterval - createdInterval)

        if diff < 3600 {
            return "\(diff/60)분 전"
        } else if diff < 86400 {
            return "\(diff/3600)시간 전"
        } else if diff < 604800 {
            return "\(diff/86400)일 전"
        } else if diff < 31449600 {
            return "\(diff/604800)주 전"
        } else {
            return "\(diff/31449600)년 전"
        }
    }
}
