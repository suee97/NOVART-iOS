import UIKit
import SnapKit

final class ExhibitionCell: UICollectionViewCell {
    
    // MARK: - Constants
    private enum Constants {
        static let opacity: Float = 0.8
        static let radius: CGFloat = 12
        
        static let shadowColor: UIColor = .black
        static let shadowOpacity: Float = 0.12
        static let shadowRadius: CGFloat = 4
        static let shadowOffset = CGSize(width: 0, height: 0.5)
        
        enum ExhibitionImageView {
            static let radius: CGFloat = 12
            static let height: CGFloat = 472
        }
        
        enum DescLabel {
            static let font = UIFont.systemFont(ofSize: 14, weight: .regular)
            static let textColor = UIColor.Common.warmBlack
            static let margins = (left: 14, right: 14, top: 11, bottom: 10.5)
            static let height = 66
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
            guard let exhibition = exhibition else { return }
            exhibitionImageView.image = exhibition.imageView.image
            descLabel.text = exhibition.desc
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
    
    private func setUpView() {
        backgroundColor = .clear
        container.layer.opacity = 0.12
        
        contentView.addSubview(container)
        container.addSubview(exhibitionImageView)
        container.addSubview(descLabel)
        container.addSubview(previewLabel)
        
        container.snp.makeConstraints({ m in
            m.edges.equalToSuperview()
        })
        
        exhibitionImageView.snp.makeConstraints({ m in
            m.left.right.top.equalToSuperview()
            m.height.equalTo(Constants.ExhibitionImageView.height)
        })

        descLabel.snp.makeConstraints({ m in
            m.left.equalToSuperview().inset(Constants.DescLabel.margins.left)
            m.right.equalToSuperview().inset(Constants.DescLabel.margins.right)
            m.top.equalTo(exhibitionImageView.snp.bottom).offset(Constants.DescLabel.margins.top)
            m.height.equalTo(Constants.DescLabel.height)
        })

        previewLabel.snp.makeConstraints({ m in
            m.centerX.equalToSuperview()
            m.bottom.equalToSuperview().inset(Constants.PreviewLabel.bottomMargin)
        })
    }
    
    private func setUpShadow() {
        layer.shadowColor = Constants.shadowColor.cgColor
        layer.shadowOpacity = Constants.shadowOpacity
        layer.shadowRadius = Constants.shadowRadius
        layer.shadowOffset = Constants.shadowOffset
        contentView.layer.masksToBounds = true
        layer.cornerRadius = Constants.radius
    }
}
