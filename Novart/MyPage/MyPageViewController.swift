import UIKit

final class MyPageViewController: BaseViewController {
    
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
