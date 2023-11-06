import UIKit

final class ToggleSwitchView: UIView {
    
    // MARK: - Constants
    private enum Constants {
        enum LargeText {
            static let font = UIFont.systemFont(ofSize: 16, weight: .semibold)
            static let color = UIColor.Common.black
        }
        
        enum SmallText {
            static let font = UIFont.systemFont(ofSize: 12, weight: .regular)
            static let color = UIColor.Common.grey02
        }
        
        enum Toggle {
            static let onTintColor = UIColor.Common.main
            static let thumbTintColor = UIColor.white
        }
    }
    
    
    // MARK: - Properties
    var isOn: Bool
    
    
    // MARK: - Initialize
    init(title: String, desc: String, isOn: Bool, onSwitch: @escaping (Bool) -> Void) {
        self.isOn = isOn
        super.init(frame: .zero)
        titleLabel.text = title
        descLabel.text = desc
        setUpView()
        
        toggle.addAction(UIAction(handler: { _ in
            self.isOn = !self.isOn
            onSwitch(self.isOn)
        }), for: .valueChanged)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - UI
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = Constants.LargeText.color
        label.font = Constants.LargeText.font
        return label
    }()
    
    private let descLabel: UILabel = {
        let label = UILabel()
        label.textColor = Constants.SmallText.color
        label.font = Constants.SmallText.font
        return label
    }()
    
    lazy var toggle: UISwitch = {
        let toggle = UISwitch()
        toggle.thumbTintColor = Constants.Toggle.thumbTintColor
        toggle.onTintColor = Constants.Toggle.onTintColor
        toggle.isOn = self.isOn
        return toggle
    }()
    
    private func setUpView() {
        addSubview(titleLabel)
        addSubview(descLabel)
        addSubview(toggle)
        
        titleLabel.snp.makeConstraints({ m in
            m.left.top.equalToSuperview()
        })
        
        descLabel.snp.makeConstraints({ m in
            m.left.bottom.equalToSuperview()
        })
        
        toggle.snp.makeConstraints({ m in
            m.centerY.right.equalToSuperview()
        })
    }
}
