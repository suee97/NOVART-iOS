import UIKit
import SnapKit

final class MyPageUserBlockViewController: BaseViewController {

    // MARK: - Constants
    private enum Constants {
        static let screenWidth = UIScreen.main.bounds.size.width
        static let screenHeight = UIScreen.main.bounds.size.height
        static func getRelativeWidth(from width: CGFloat) -> CGFloat { screenWidth * (width/390) }
        static func getRelativeHeight(from height: CGFloat) -> CGFloat { screenHeight * (height/844) }
        
        enum ContentView {
            static let radius: CGFloat = 12
            static let width = screenWidth
            static let height = width * (398/390)
            
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
        
        enum CancelButton {
            static let diameter = getRelativeWidth(from: 24)
            static let imagePath = "icon_cancel"
            static let rightMargin = getRelativeWidth(from: 24)
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
    
    private lazy var cancelButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: Constants.CancelButton.imagePath), for: .normal)
        button.addAction(UIAction(handler: { [weak self] _ in
            guard let self else { return }
            self.onTapCancelButton()
        }), for: .touchUpInside)
        return button
    }()
    
    override func setupView() {
        view.backgroundColor = .blue
    }
    
    // MARK: - Functions
    private func onTapCancelButton() {
        self.dismiss(animated: true)
    }
}
