import UIKit
import Kingfisher

final class MyPageNotificationCell: UICollectionViewCell {
    
    // MARK: - Constants
    private enum Constants {
        
        enum ContentView {
            static let unreadColor: UIColor = .Common.grey00
            static let readColor: UIColor = .Common.white
        }
        
        enum SelectionView {
            static let leftMargin: CGFloat = 8
            static let rightMargin: CGFloat = 8
            static let topMargin: CGFloat = 4
            static let bottomMargin: CGFloat = 4
            static let selectedColor: UIColor = .Common.grey00
            static let unSelectedColor: UIColor = .Common.white
            static let radius: CGFloat = 12
        }
        
        enum ProfileImageView {
            static let topMargin: CGFloat = 20
            static let leftMargin: CGFloat = 24
            static let diameter: CGFloat = 40
            static let radius: CGFloat = 20
        }
        
        enum NotificationLabel {
            static let topMargin: CGFloat = 20
            static let leftMargin: CGFloat = 12
            static let rightMargin: CGFloat = 24
            static let color: UIColor = .Common.black
            static let font = UIFont.systemFont(ofSize: 16, weight: .medium)
        }
        
        enum TimeLabel {
            static let topMargin: CGFloat = 4
            static let bottomMargin: CGFloat = 20
            static let color: UIColor = .Common.grey02
            static let font = UIFont.systemFont(ofSize: 14, weight: .regular)
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
    
    
    // MARK: - Properties
    var notificationId: Int64?
    
    
    // MARK: - UI
    let anchorView: UIView = {
        let view = UIView()
        return view
    }()
    
    private let selectionView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = Constants.SelectionView.radius
        return view
    }()
    
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
        contentView.addSubview(selectionView)
        contentView.addSubview(profileImageView)
        contentView.addSubview(notificationLabel)
        contentView.addSubview(timeLabel)
        contentView.addSubview(anchorView)
        
        anchorView.snp.makeConstraints({ m in
            m.left.right.equalToSuperview()
            m.width.equalTo(UIScreen.main.bounds.width)
        })
        
        selectionView.snp.makeConstraints({ m in
            m.left.equalToSuperview().inset(Constants.SelectionView.leftMargin)
            m.right.equalToSuperview().inset(Constants.SelectionView.rightMargin)
            m.top.equalToSuperview().inset(Constants.SelectionView.topMargin)
            m.bottom.equalToSuperview().inset(Constants.SelectionView.bottomMargin)
        })
        
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
            m.bottom.equalToSuperview().inset(Constants.TimeLabel.bottomMargin)
        })
    }
    
    
    // MARK: - Functions
    func update(notification: NotificationModel) {
        guard let imgUrl = notification.imgUrl, let url = URL(string: imgUrl) else { return }
        profileImageView.kf.setImage(with: url)
        notificationLabel.text = notification.message
        timeLabel.text = getTimeText(from: notification.createdAt)
        notificationId = notification.id
        
        if notification.status == .Read {
            contentView.backgroundColor = Constants.ContentView.readColor
            selectionView.backgroundColor = Constants.SelectionView.unSelectedColor
        } else {
            contentView.backgroundColor = Constants.ContentView.unreadColor
            selectionView.backgroundColor = Constants.SelectionView.selectedColor
        }
    }
    
    func didHighlight(notification: NotificationModel) {
        selectionView.backgroundColor = Constants.SelectionView.selectedColor
    }
    
    func didUnHighlight(notification: NotificationModel) {
        if notification.status == .Read {
            contentView.backgroundColor = Constants.ContentView.readColor
            selectionView.backgroundColor = Constants.SelectionView.unSelectedColor
        } else {
            contentView.backgroundColor = Constants.ContentView.unreadColor
        }
    }
    
    func didSelect(notification: NotificationModel) {
        if notification.status == .UnRead {
            contentView.backgroundColor = Constants.ContentView.readColor
        }
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
        guard let dotIndex = createdAt.firstIndex(of: ".") else { return "" }
        let endIndex = createdAt.index(before: dotIndex)
        
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
