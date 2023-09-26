import UIKit
import SnapKit

final class MyPageInterestCell: UICollectionViewCell {
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    private let artNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Apple SD Gothic Neo Bold", size: 14)
        label.textColor = .Common.black
        label.textAlignment = .center
        return label
    }()
    
    private let artistNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Apple SD Gothic Neo Regular", size: 12)
        label.textColor = .Common.grey03
        label.textAlignment = .center
        return label
    }()
    
    var interest: MyPageInterest? {
        didSet {
            artNameLabel.text = interest?.name ?? ""
            artistNameLabel.text = interest?.artistName ?? ""
            
            guard let urlString: String = interest?.thumbnailImgUrl else { return }
            guard let url = URL(string: urlString) else { return }
            DispatchQueue.global().async { [weak self] in
                if let data = try? Data(contentsOf: url) {
                    if let image = UIImage(data: data) {
                        DispatchQueue.main.async {
                            self?.imageView.image = image
                        }
                    }
                }
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpView()
        addShadow()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpView() {
        contentView.backgroundColor = .Common.grey00
        contentView.layer.cornerRadius = 12
        contentView.clipsToBounds = true
        
        contentView.addSubview(imageView)
        contentView.addSubview(artNameLabel)
        contentView.addSubview(artistNameLabel)
        
        imageView.snp.makeConstraints({ m in
            m.left.right.top.equalTo(contentView)
            m.height.equalTo(contentView.snp.width)
        })
        
        artNameLabel.snp.makeConstraints({ m in
            m.left.equalTo(contentView).inset(12)
            m.top.equalTo(imageView.snp.bottom).offset(10)
            m.height.equalTo(20)
        })
        
        artistNameLabel.snp.makeConstraints({ m in
            m.left.equalTo(contentView).inset(12)
            m.top.equalTo(artNameLabel.snp.bottom)
            m.height.equalTo(16)
        })
    }
    
    private func addShadow() {
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.1
        self.layer.shadowOffset = CGSize(width: 0, height: 2)
    }
}
