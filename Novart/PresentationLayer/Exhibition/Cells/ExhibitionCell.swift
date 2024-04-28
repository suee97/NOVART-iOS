import UIKit
import SnapKit

final class ExhibitionCell: UICollectionViewCell {
    
    // MARK: - Constants
    private enum Constants {
        static let screenWidth: CGFloat = UIScreen.main.bounds.width
        
        static let opacity: Float = 0.8
        static let radius: CGFloat = 12
        
        static let shadowColor: UIColor = .black
        static let shadowOpacity: Float = 0.12
        static let shadowRadius: CGFloat = 4
        static let shadowOffset = CGSize(width: 0, height: 0.5)
        static let noExhibitionIconBottomMargin: CGFloat = 20
        
        enum ExhibitionImageView {
            static let radius: CGFloat = 12
            static let height: CGFloat = (Constants.screenWidth - 48) * (472 / 342)
        }
        
        enum DescLabel {
            static let font = UIFont.systemFont(ofSize: 14, weight: .regular)
            static let textColor = UIColor.Common.warmBlack
            static let leftMargin: CGFloat = 14
            static let rightMargin: CGFloat = 14
            static let topMargin: CGFloat = 11
            static let height: CGFloat = 66
            static let numberOfLines = 3
        }
        
        enum PreviewLabel {
            static let font = UIFont.systemFont(ofSize: 18, weight: .semibold)
            static let textColor = UIColor.Common.warmBlack
            static let text: String = "관람하기"
            static let bottomMargin: CGFloat = 16
        }
    }
    
    
    // MARK: - LifeCycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpView()
        setUpShadow()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - UI
    var exhibition: ProcessedExhibition? {
        didSet {
            if let exhibition {
                exhibitionImageView.image = exhibition.imageView.image
                descLabel.text = exhibition.description
            } else {
                previewLabel.isHidden = true
                exhibitionImageView.image = nil
                descLabel.text = ""
                noExhibitionIcon.isHidden = false
            }
        }
    }
    
    var container: UIView = {
        let view = UIView()
        let imageView = UIImageView(image: UIImage(named: "exhibition_cell_container"))
        imageView.layer.opacity = Constants.opacity
        view.addSubview(imageView)
        imageView.snp.makeConstraints({ m in
            m.edges.equalToSuperview()
        })
        return view
    }()
    
    private let exhibitionImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = Constants.ExhibitionImageView.radius
        imageView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        return imageView
    }()

    private let descLabel: UILabel = {
        let label = UILabel()
        label.font = Constants.DescLabel.font
        label.textColor = Constants.DescLabel.textColor
        label.numberOfLines = Constants.DescLabel.numberOfLines
        return label
    }()
    
    private let previewLabel: UILabel = {
        let label = UILabel()
        label.font = Constants.PreviewLabel.font
        label.textColor = Constants.PreviewLabel.textColor
        label.text = Constants.PreviewLabel.text
        return label
    }()
    
    private let noExhibitionIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "icon_no_exhibition")
        return imageView
    }()
    
    private func setUpView() {
        backgroundColor = .clear
        
        contentView.addSubview(container)
        container.addSubview(exhibitionImageView)
        container.addSubview(descLabel)
        container.addSubview(previewLabel)
        container.addSubview(noExhibitionIcon)
        
        container.snp.makeConstraints({ m in
            m.edges.equalToSuperview()
        })
        
        exhibitionImageView.snp.makeConstraints({ m in
            m.left.right.top.equalToSuperview()
            m.height.equalTo(Constants.ExhibitionImageView.height)
        })

        descLabel.snp.makeConstraints({ m in
            m.left.equalToSuperview().inset(Constants.DescLabel.leftMargin)
            m.right.equalToSuperview().inset(Constants.DescLabel.rightMargin)
            m.top.equalTo(exhibitionImageView.snp.bottom).offset(Constants.DescLabel.topMargin)
            m.height.equalTo(Constants.DescLabel.height)
        })

        previewLabel.snp.makeConstraints({ m in
            m.centerX.equalToSuperview()
            m.bottom.equalToSuperview().inset(Constants.PreviewLabel.bottomMargin)
        })
        
        noExhibitionIcon.snp.makeConstraints { m in
            m.centerX.equalToSuperview()
            m.centerY.equalToSuperview().offset(-Constants.noExhibitionIconBottomMargin)
        }
    }
    
    private func setUpShadow() {
        layer.shadowColor = Constants.shadowColor.cgColor
        layer.shadowOpacity = Constants.shadowOpacity
        layer.shadowRadius = Constants.shadowRadius
        layer.shadowOffset = Constants.shadowOffset
        contentView.layer.masksToBounds = true
        layer.cornerRadius = Constants.radius
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        exhibitionImageView.image = nil
        descLabel.text = ""
        previewLabel.isHidden = false
        noExhibitionIcon.isHidden = true
    }
}
