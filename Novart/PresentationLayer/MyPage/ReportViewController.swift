import UIKit
import SnapKit

final class ReportViewController: BaseViewController {

    // MARK: - Constants
    private enum Constants {
        static let screenWidth = UIScreen.main.bounds.size.width
        static let screenHeight = UIScreen.main.bounds.size.height
        static func getRelativeWidth(from width: CGFloat) -> CGFloat { screenWidth * (width/390) }
        static func getRelativeHeight(from height: CGFloat) -> CGFloat { screenHeight * (height/844) }
        
        enum ContentView {
            static let radius: CGFloat = 12
            static let width = screenWidth
            
            enum Shadow {
                static let color: CGColor = UIColor.black.withAlphaComponent(0.25).cgColor
                static let radius: CGFloat = 4
                static let offset: CGSize = CGSize(width: 0, height: 4)
                static let opacity: Float = 1
            }
        }
        
        enum TopBar {
            static let backgroundColor = UIColor.Common.grey01
            static let width: CGFloat = 40
            static let height: CGFloat = 4
            static let topMargin: CGFloat = getRelativeHeight(from: 12)
        }
        
        enum TitleLabel {
            static let text = "사용자 신고"
            static let textColor = UIColor.Common.black
            static let font = UIFont.systemFont(ofSize: 16, weight: .semibold)
            static let topMargin = getRelativeHeight(from: 8)
        }
        
        enum CancelButton {
            static let diameter = getRelativeWidth(from: 24)
            static let imagePath = "icon_cancel"
            static let rightMargin = getRelativeWidth(from: 24)
        }
        
        enum AbuseCheckRowView {
            static let text = "비방, 욕설 및 혐오표현을 사용해요"
            static let horizontalMargin: CGFloat = 24
            static let height = Constants.getRelativeHeight(from: 24)
            static let topMargin = Constants.getRelativeHeight(from: 34)
        }
        
        enum Divider1 {
            static let horizontalMargin: CGFloat = 24
            static let topMargin = Constants.getRelativeHeight(from: 24)
        }
        
        enum IssueCheckRowView {
            static let text = "이 사용자와 거래 중 문제가 발생했어요"
            static let horizontalMargin: CGFloat = 24
            static let height = Constants.getRelativeHeight(from: 24)
            static let topMargin = Constants.getRelativeHeight(from: 24)
        }
        
        enum Divider2 {
            static let horizontalMargin: CGFloat = 24
            static let topMargin = Constants.getRelativeHeight(from: 24)
        }
        
        enum FraudCheckRowView {
            static let text = "사기인 것 같아요"
            static let horizontalMargin: CGFloat = 24
            static let height = Constants.getRelativeHeight(from: 24)
            static let topMargin = Constants.getRelativeHeight(from: 24)
        }
        
        enum ReportButton {
            static let text = "해당 이유로 신고하기"
            static let font = UIFont.systemFont(ofSize: 16, weight: .bold)
            static let radius: CGFloat = 12
            static let disabledBackgroundColor = UIColor.init(hexString: "#F0F4F5")
            static let disabledTextColor = UIColor.init(hexString: "#D3DEE0")
            static let enabledBackgroundColor = UIColor.Common.black
            static let enabledTextColor = UIColor.Common.white
            static let topMargin = Constants.getRelativeHeight(from: 296)
            static let height = Constants.getRelativeHeight(from: 54)
            static let horizontalMargin: CGFloat = 24
        }
        
        enum ConfirmView {
            static let height = Constants.getRelativeHeight(from: 280)
            
            enum ConfirmImageView {
                static let imageName = "icon_check_report"
                static let diameter = Constants.getRelativeWidth(from: 64)
                static let topMargin = Constants.getRelativeHeight(from: 80)
            }
            enum AppreciateLabel {
                static let text = "알려주셔서 감사합니다"
                static let font = UIFont.systemFont(ofSize: 20, weight: .bold)
                static let textColor = UIColor.Common.black
                static let topMargin = Constants.getRelativeHeight(from: 24)
            }
            enum ImprovementLabel {
                static let text = "회원님의 소중한 의견을 반영하여 더 나은 PLAIN을 만들기 위해 노력하겠습니다."
                static let font = UIFont.systemFont(ofSize: 14, weight: .regular)
                static let textColor = UIColor.init(hexString: "#5E6566")
                static let topMargin = Constants.getRelativeHeight(from: 8)
                static let width: CGFloat = 305
            }
        }
    }
    
    
    // MARK: - UI
    private let contentView: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        view.backgroundColor = .white
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.layer.cornerRadius = Constants.ContentView.radius
        view.layer.shadowColor = Constants.ContentView.Shadow.color
        view.layer.shadowOffset = Constants.ContentView.Shadow.offset
        view.layer.shadowRadius = Constants.ContentView.Shadow.radius
        view.layer.shadowOpacity = Constants.ContentView.Shadow.opacity
        return view
    }()
    
    private let topBar: UIView = {
        let view = UIView()
        view.backgroundColor = Constants.TopBar.backgroundColor
        view.layer.cornerRadius = Constants.TopBar.height / 2
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = Constants.TitleLabel.text
        label.textColor = Constants.TitleLabel.textColor
        label.font = Constants.TitleLabel.font
        return label
    }()
    
    private lazy var cancelButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: Constants.CancelButton.imagePath), for: .normal)
        button.addAction(UIAction(handler: { [weak self] _ in
            guard let self else { return }
            self.onTapCancelButton()
        }), for: .touchUpInside)
        return button
    }()
    
    private lazy var abuseCheckRowView: CheckRowView = {
        let view = CheckRowView(text: Constants.AbuseCheckRowView.text)
        view.onTapCheckBoxButton = { self.validateReportButton() }
        return view
    }()
    
    private lazy var issueCheckRowView: CheckRowView = {
        let view = CheckRowView(text: Constants.IssueCheckRowView.text)
        view.onTapCheckBoxButton = { self.validateReportButton() }
        return view
    }()
    
    private lazy var fraudCheckRowView: CheckRowView = {
        let view = CheckRowView(text: Constants.FraudCheckRowView.text)
        view.onTapCheckBoxButton = { self.validateReportButton() }
        return view
    }()
    
    private let (divider1, divider2) = (Divider(), Divider())
    
    private lazy var reportButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = Constants.ReportButton.radius
        button.setTitle(Constants.ReportButton.text, for: .normal)
        button.titleLabel?.font = Constants.ReportButton.font
        button.backgroundColor = Constants.ReportButton.disabledBackgroundColor
        button.titleLabel?.textColor = Constants.ReportButton.disabledTextColor
        button.isEnabled = false
        button.addAction(UIAction(handler: { [weak self] _ in
            guard let self else { return }
            self.onTapReportButton()
        }), for: .touchUpInside)
        return button
    }()
    
    private let confirmView: UIView = {
        let view = UIView()
        
        let confirmImageView = UIImageView(image: UIImage(named: Constants.ConfirmView.ConfirmImageView.imageName))
        let appreciateLabel = UILabel()
        appreciateLabel.text = Constants.ConfirmView.AppreciateLabel.text
        appreciateLabel.textColor = Constants.ConfirmView.AppreciateLabel.textColor
        appreciateLabel.font = Constants.ConfirmView.AppreciateLabel.font
        
        let improvementLabel = UILabel()
        improvementLabel.text = Constants.ConfirmView.ImprovementLabel.text
        improvementLabel.textColor = Constants.ConfirmView.ImprovementLabel.textColor
        improvementLabel.font = Constants.ConfirmView.ImprovementLabel.font
        improvementLabel.numberOfLines = 0
        improvementLabel.textAlignment = .center
        
        view.addSubview(confirmImageView)
        view.addSubview(appreciateLabel)
        view.addSubview(improvementLabel)
        
        confirmImageView.snp.makeConstraints({ m in
            m.width.height.equalTo(Constants.ConfirmView.ConfirmImageView.diameter)
            m.top.equalToSuperview().inset(Constants.ConfirmView.ConfirmImageView.topMargin)
            m.centerX.equalToSuperview()
        })
        appreciateLabel.snp.makeConstraints({ m in
            m.top.equalTo(confirmImageView.snp.bottom).offset(Constants.ConfirmView.AppreciateLabel.topMargin)
            m.centerX.equalToSuperview()
        })
        improvementLabel.snp.makeConstraints({ m in
            m.top.equalTo(appreciateLabel.snp.bottom).offset(Constants.ConfirmView.ImprovementLabel.topMargin)
            m.width.equalTo(Constants.ConfirmView.ImprovementLabel.width)
            m.centerX.equalToSuperview()
        })
        
        return view
    }()
    
    override func setupView() {
        view.backgroundColor = UIColor.Common.white
        
        view.addSubview(topBar)
        view.addSubview(titleLabel)
        view.addSubview(cancelButton)
        view.addSubview(abuseCheckRowView)
        view.addSubview(divider1)
        view.addSubview(issueCheckRowView)
        view.addSubview(divider2)
        view.addSubview(fraudCheckRowView)
        view.addSubview(reportButton)
        
        topBar.snp.makeConstraints({ m in
            m.centerX.equalToSuperview()
            m.top.equalToSuperview().inset(Constants.TopBar.topMargin)
            m.width.equalTo(Constants.TopBar.width)
            m.height.equalTo(Constants.TopBar.height)
        })
        
        titleLabel.snp.makeConstraints({ m in
            m.centerX.equalToSuperview()
            m.top.equalTo(topBar.snp.bottom).offset(Constants.TitleLabel.topMargin)
        })
        
        cancelButton.snp.makeConstraints({ m in
            m.width.height.equalTo(Constants.CancelButton.diameter)
            m.centerY.equalTo(titleLabel)
            m.right.equalToSuperview().inset(Constants.CancelButton.rightMargin)
        })
        
        abuseCheckRowView.snp.makeConstraints({ m in
            m.left.right.equalToSuperview().inset(Constants.AbuseCheckRowView.horizontalMargin)
            m.height.equalTo(Constants.AbuseCheckRowView.height)
            m.top.equalTo(titleLabel.snp.bottom).offset(Constants.AbuseCheckRowView.topMargin)
        })
        
        divider1.snp.makeConstraints({ m in
            m.left.right.equalToSuperview().inset(Constants.Divider1.horizontalMargin)
            m.top.equalTo(abuseCheckRowView.snp.bottom).offset(Constants.Divider1.topMargin)
        })
        
        issueCheckRowView.snp.makeConstraints({ m in
            m.top.equalTo(divider1.snp.bottom).offset(Constants.IssueCheckRowView.topMargin)
            m.height.equalTo(Constants.IssueCheckRowView.height)
            m.left.right.equalToSuperview().inset(Constants.IssueCheckRowView.horizontalMargin)
        })
        
        divider2.snp.makeConstraints({ m in
            m.left.right.equalToSuperview().inset(Constants.Divider2.horizontalMargin)
            m.top.equalTo(issueCheckRowView.snp.bottom).offset(Constants.Divider2.topMargin)
        })
        
        fraudCheckRowView.snp.makeConstraints({ m in
            m.top.equalTo(divider2.snp.bottom).offset(Constants.FraudCheckRowView.topMargin)
            m.height.equalTo(Constants.FraudCheckRowView.height)
            m.left.right.equalToSuperview().inset(Constants.FraudCheckRowView.horizontalMargin)
        })
        
        reportButton.snp.makeConstraints({ m in
            m.left.right.equalToSuperview().inset(Constants.ReportButton.horizontalMargin)
            m.top.equalToSuperview().inset(Constants.ReportButton.topMargin)
            m.height.equalTo(Constants.ReportButton.height)
        })
    }
    
    
    // MARK: - Functions
    private func onTapCancelButton() {
        self.dismiss(animated: true)
    }
    
    private func validateReportButton() {
        if abuseCheckRowView.isChecked || issueCheckRowView.isChecked || fraudCheckRowView.isChecked {
            reportButton.titleLabel?.textColor = Constants.ReportButton.enabledTextColor
            reportButton.backgroundColor = Constants.ReportButton.enabledBackgroundColor
            reportButton.isEnabled = true
        } else {
            reportButton.titleLabel?.textColor = Constants.ReportButton.disabledTextColor
            reportButton.backgroundColor = Constants.ReportButton.disabledBackgroundColor
            reportButton.isEnabled = false
        }
    }
    
    private func onTapReportButton() {
        // MARK: - TODO: API 요청
        let removeViews = [titleLabel, cancelButton, abuseCheckRowView, divider1, issueCheckRowView, divider2, fraudCheckRowView]
        removeViews.forEach { $0.removeFromSuperview() }
        contentView.addSubview(confirmView)
        confirmView.snp.makeConstraints({ m in
            m.left.right.top.equalToSuperview()
            m.height.equalTo(Constants.ConfirmView.height)
        })
        reportButton.setTitle("확인", for: .normal)
        reportButton.enumerateEventHandlers { action, _, event, _ in
            if let action = action {
                reportButton.removeAction(action, for: event)
            }
        }
        reportButton.addAction(UIAction(handler: { [weak self] _ in
            guard let self else { return }
            self.dismiss(animated: true)
        }), for: .touchUpInside)
    }
}

// MARK: - CheckRowView & Divider
fileprivate final class CheckRowView: UIView {
    var isChecked = false
    var onTapCheckBoxButton: () -> Void = {}
    
    private let label: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.Common.black
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        return label
    }()
    
    private lazy var checkBoxButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "icon_check_box"), for: .normal)
        button.addAction(UIAction(handler: { [weak self] _ in
            guard let self else { return }
            self.isChecked = !self.isChecked
            let image = self.isChecked ? UIImage(named: "icon_check_fill") : UIImage(named: "icon_check_box")
            button.setImage(image, for: .normal)
            self.onTapCheckBoxButton()
        }), for: .touchUpInside)
        return button
    }()
    
    init(text: String) {
        super.init(frame: .zero)
        label.text = text
        setUpView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpView() {
        addSubview(label)
        addSubview(checkBoxButton)
        
        label.snp.makeConstraints({ m in
            m.left.equalToSuperview()
            m.centerY.equalToSuperview()
        })
        
        checkBoxButton.snp.makeConstraints({ m in
            m.right.equalToSuperview()
            m.centerY.equalToSuperview()
            m.width.height.equalTo(24)
        })
    }
}

fileprivate final class Divider: UIView {
    init() {
        super.init(frame: .zero)
        backgroundColor = .Common.grey01
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.heightAnchor.constraint(equalToConstant: 0.5)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
