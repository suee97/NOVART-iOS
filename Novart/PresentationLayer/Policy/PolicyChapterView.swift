import UIKit
import SnapKit

final class PolicyChapterView: UIStackView {
    
    // MARK: - Constants
    private enum Constants {
        static let verticalSpacing: CGFloat = 16
        
        enum Title {
            static let font = UIFont.systemFont(ofSize: 16, weight: .semibold)
            static let textColor = UIColor.black
        }
        
        enum Description {
            static let font = UIFont.systemFont(ofSize: 12, weight: .regular)
            static let textColor = UIColor.black
        }
    }
    
    
    // MARK: - Properties
    private let chapter: PolicyChapterModel
    
    
    // MARK: - Init
    init(chapter: PolicyChapterModel) {
        self.chapter = chapter
        super.init(frame: .zero)
        setUpView()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - UI
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = Constants.Title.font
        label.textColor = Constants.Title.textColor
        return label
    }()
    
    private func setUpView() {
        titleLabel.text = chapter.title
        
        axis = .vertical
        distribution = .equalSpacing
        spacing = Constants.verticalSpacing
        addArrangedSubview(titleLabel)
        
        for desc in chapter.descriptions {
            let label = UILabel()
            label.font = Constants.Description.font
            label.textColor = Constants.Description.textColor
            label.text = desc
            label.numberOfLines = 0
            label.lineBreakMode = .byWordWrapping
            addArrangedSubview(label)
        }
    }
}
