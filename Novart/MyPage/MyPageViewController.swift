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
    
    private let backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "default_user_background_image")
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "default_user_profile_image")
        return imageView
    }()
    
    private let userNameLabel: UILabel = {
        let label = UILabel()
        label.text = "게스트"
        label.font = UIFont(name: "Apple SD Gothic Neo Bold", size: 28)
        return label
    }()
    
    private let categoryView: UIView = {
        let view = UIView()
        view.backgroundColor = .Common.grey00
        view.layer.cornerRadius = 12
        
        let barView1 = UIView()
        let barView2 = UIView()
        let barView3 = UIView()
        barView1.backgroundColor = .Common.grey01
        barView2.backgroundColor = .Common.grey01
        barView3.backgroundColor = .Common.grey01
        
        let interestButton = MyPageCategoryButton(title: "관심")
        let followingButton = MyPageCategoryButton(title: "팔로잉")
        let workButton = MyPageCategoryButton(title: "작업")
        let exhibitionButton = MyPageCategoryButton(title: "전시")
        
        view.addSubview(interestButton)
        view.addSubview(followingButton)
        view.addSubview(workButton)
        view.addSubview(exhibitionButton)
        view.addSubview(barView1)
        view.addSubview(barView2)
        view.addSubview(barView3)
        
        interestButton.snp.makeConstraints({ m in
            m.width.equalTo(84)
            m.height.equalTo(44)
            m.left.top.equalTo(view)
        })
        barView1.snp.makeConstraints({ m in
            m.width.equalTo(1)
            m.height.equalTo(16)
            m.left.equalTo(interestButton.snp.right)
            m.centerY.equalTo(view)
        })
        followingButton.snp.makeConstraints({ m in
            m.width.equalTo(84)
            m.height.equalTo(44)
            m.left.equalTo(barView1.snp.right)
            m.top.equalTo(view)
        })
        barView2.snp.makeConstraints({ m in
            m.width.equalTo(1)
            m.height.equalTo(16)
            m.left.equalTo(followingButton.snp.right)
            m.centerY.equalTo(view)
        })
        workButton.snp.makeConstraints({ m in
            m.width.equalTo(84)
            m.height.equalTo(44)
            m.top.equalTo(view)
            m.left.equalTo(barView2.snp.right)
        })
        barView3.snp.makeConstraints({ m in
            m.width.equalTo(1)
            m.height.equalTo(16)
            m.left.equalTo(workButton.snp.right)
            m.centerY.equalTo(view)
        })
        exhibitionButton.snp.makeConstraints({ m in
            m.width.equalTo(84)
            m.height.equalTo(44)
            m.left.equalTo(barView3.snp.right)
            m.top.equalTo(view)
        })
        
        return view
    }()
    
    override func setupView() {
        view.backgroundColor = .white
        
        view.addSubview(backgroundImageView)
        view.addSubview(profileImageView)
        view.addSubview(userNameLabel)
        view.addSubview(categoryView)
        
        backgroundImageView.snp.makeConstraints({ m in
            m.left.right.top.equalTo(view)
            m.height.equalTo(Constants.screenWidth * Constants.backgroundRat)
        })
        
        profileImageView.snp.makeConstraints({ m in
            m.width.height.equalTo(108)
            m.centerX.equalTo(view)
            m.centerY.equalTo(backgroundImageView.snp.bottom)
        })
        
        userNameLabel.snp.makeConstraints({ m in
            m.centerX.equalTo(view)
            m.top.equalTo(profileImageView.snp.bottom).offset(12)
        })
        
        categoryView.snp.makeConstraints({ m in
            m.top.equalTo(userNameLabel.snp.bottom).offset(18)
            m.width.equalTo(342)
            m.height.equalTo(44)
            m.centerX.equalTo(view)
        })
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = backgroundImageView.bounds
        let colors: [CGColor] = [UIColor.white.withAlphaComponent(0.0).cgColor, UIColor.white.cgColor]
        gradientLayer.colors = colors
        
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
        gradientLayer.locations = [0.5, 1.0]
        backgroundImageView.layer.addSublayer(gradientLayer)
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
