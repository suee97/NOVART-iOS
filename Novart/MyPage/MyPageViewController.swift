import UIKit
import SnapKit

final class MyPageViewController: BaseViewController {
    
    // MARK: - Constants
    private enum Constants {
        static let screenWidth = UIScreen.main.bounds.width
        static let backgroundRat: CGFloat = 22/39
        static var appearance: UINavigationBarAppearance = {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = .clear
            appearance.shadowColor = .clear
            return appearance
        }()
    }
    
    // MARK: - Properties
    var backgroundImage: UIImage?
    
    
    // MARK: - UI
    override func setupNavigationBar() {
        let iconSize = CGRect(origin: CGPoint.zero, size: CGSize(width: 24, height: 24))

        let notificationButton = UIButton(frame: iconSize)
        notificationButton.setBackgroundImage(UIImage(named: "icon_notification2"), for: .normal) // 기존 icon_notification이 존재해서 숫자 2를 붙임. 기존 아이콘 사용 안하는거면 수정이 필요합니다
        notificationButton.addTarget(self, action: #selector(onTapNotification), for: .touchUpInside)
        let notificationItem = UIBarButtonItem(customView: notificationButton)
        
        let spacer = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        spacer.width = 16 // figma에서는 20인데, 기본으로 들어가는 space가 있어서 16으로 함
        
        let settingButton = UIButton(frame: iconSize)
        settingButton.setBackgroundImage(UIImage(named: "icon_setting"), for: .normal)
        settingButton.addTarget(self, action: #selector(onTapSetting), for: .touchUpInside)
        let settingItem = UIBarButtonItem(customView: settingButton)

        let meatballsButton = UIButton(frame: iconSize)
        meatballsButton.setBackgroundImage(UIImage(named: "icon_meatballs"), for: .normal)
        meatballsButton.addTarget(self, action: #selector(onTapMeatballs), for: .touchUpInside)
        let meatballsItem = UIBarButtonItem(customView: meatballsButton)
        
        self.navigationItem.rightBarButtonItems = [settingItem, spacer, notificationItem]
        self.navigationItem.leftBarButtonItem = meatballsItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Constants.appearance.backgroundColor = .clear
        navigationController?.navigationBar.compactAppearance = Constants.appearance
        navigationController?.navigationBar.standardAppearance = Constants.appearance
        navigationController?.navigationBar.scrollEdgeAppearance = Constants.appearance
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        Constants.appearance.backgroundColor = .white
        navigationController?.navigationBar.compactAppearance = Constants.appearance
        navigationController?.navigationBar.standardAppearance = Constants.appearance
        navigationController?.navigationBar.scrollEdgeAppearance = Constants.appearance
    }
    
    private let defaultBackgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "default_user_background_image")
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    override func setupView() {
        view.backgroundColor = .white
        
        view.addSubview(defaultBackgroundImageView)
        defaultBackgroundImageView.snp.makeConstraints({ m in
            m.left.right.top.equalTo(view)
            m.height.equalTo(Constants.screenWidth * Constants.backgroundRat)
        })
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = defaultBackgroundImageView.bounds
        let colors: [CGColor] = [UIColor.white.withAlphaComponent(0.0).cgColor, UIColor.white.cgColor]
        gradientLayer.colors = colors
        
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
        gradientLayer.locations = [0.5, 1.0]
        defaultBackgroundImageView.layer.addSublayer(gradientLayer)
    }
    
    // MARK: - Selectors
    @objc private func onTapNotification() {
        print("Notification Button Tapped")
    }
    
    @objc private func onTapSetting() {
        print("Setting Button Tapped")
    }
    
    @objc private func onTapMeatballs() {
        print("Meatballs Button Tapped")
    }
}
