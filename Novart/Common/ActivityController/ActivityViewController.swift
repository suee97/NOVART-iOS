//
//  ActivityViewController.swift
//  Novart
//
//  Created by Jinwook Huh on 2/18/24.
//

import UIKit

final class ActivityViewController: UIActivityViewController {
    private var presenterWindow: UIWindow?
    
    private var statusBarStyle: UIStatusBarStyle = .default
    
    weak var presenter: UIViewController?
    
    func show(animated: Bool, presenter: UIViewController? = nil) {
        var presenter: UIViewController? = presenter
        
        if presenter == nil {
            presenterWindow = makePresenterWindow()
            presenterWindow?.makeKeyAndVisible()
            presenter = presenterWindow?.rootViewController
        }
        
        self.presenter = presenter
        presenter?.present(self, animated: animated)
    }
    
    private func makePresenterWindow() -> UIWindow {
        let activityWindow: UIWindow
        if let scene = UIApplication.shared.windowScene {
            activityWindow = UIWindow(windowScene: scene)
        } else {
            activityWindow = ActivityWindow(frame: UIScreen.main.bounds)
        }
        
        activityWindow.rootViewController = StatusBarStylableViewController(statusBarStyle: statusBarStyle)
        activityWindow.windowLevel = .alert + 1
        activityWindow.backgroundColor = UIColor.clear
        activityWindow.accessibilityViewIsModal = true
        return activityWindow
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.accessibilityViewIsModal = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let presenterWindow, presenterWindow.isKeyWindow {
            presenterWindow.isHidden = false
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        presenterWindow?.isHidden = true
    }
    
    convenience init(activityItems: [Any], applicationActivities: [UIActivity]?, statusBarStyle: UIStatusBarStyle) {
        self.init(activityItems: activityItems, applicationActivities: applicationActivities)
        self.statusBarStyle = statusBarStyle
    }
}

class StatusBarStylableViewController: UIViewController {
    
    private var statusBarStyle: UIStatusBarStyle
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        statusBarStyle
    }
    
    init(statusBarStyle: UIStatusBarStyle) {
        self.statusBarStyle = statusBarStyle
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

