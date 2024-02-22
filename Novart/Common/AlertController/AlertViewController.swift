//
//  AlertViewController.swift
//  Novart
//
//  Created by Jinwook Huh on 2/18/24.
//

import UIKit

protocol AlertViewControllerDelegate: AnyObject {
    func didPresentAlertViewController(_ alertViewController: AlertViewController)
}

final class AlertViewController: UIAlertController {
    
    private var standAloneWindow: AlertWindow?
    
    weak var delegate: AlertViewControllerDelegate?
    weak var presenter: UIViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.accessibilityViewIsModal = true
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func makeAlertWindow() -> AlertWindow {
        let alertWindow: AlertWindow
        if let scene = UIApplication.shared.windowScene {
            alertWindow = AlertWindow(windowScene: scene)
        } else {
            alertWindow = AlertWindow(frame: UIScreen.main.bounds)
        }
        alertWindow.rootViewController = AlertWindowRootViewController()
        alertWindow.windowLevel = .alert + 1
        alertWindow.backgroundColor = UIColor.clear
        alertWindow.accessibilityViewIsModal = true
        return alertWindow
    }
    
    func show(_ animated: Bool = true, endEditing: Bool = true, presenter: UIViewController? = nil) {
        if endEditing {
            UIApplication.shared.windowScene?.windows.forEach {
                $0.endEditing(true)
            }
        }
        var presenter: UIViewController? = presenter
        if presenter == nil {
            standAloneWindow = makeAlertWindow()
            standAloneWindow?.makeKeyAndVisible()
            presenter = standAloneWindow?.rootViewController
        }
        
        self.presenter = presenter
        
        presenter?.present(self, animated: animated) { [weak self] in
            guard let self else { return }
            
            let check1 = self.view.window?.isKeyWindow ?? false
            let check2 = self.view.window?.windowScene?.activationState == .foregroundActive
            let check3 = self.view.window?.windowScene === UIApplication.shared.windowScene
            
            self.delegate?.didPresentAlertViewController(self)
            self.view?.accessibilityViewIsModal = true
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let standAloneWindow, standAloneWindow.isKeyWindow {
            standAloneWindow.isHidden = false
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        standAloneWindow?.isHidden = true
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
    }
    
    func hideAlertWindow(_ hidden: Bool) {
        if let standAloneWindow, standAloneWindow.isKeyWindow {
            standAloneWindow.isHidden = hidden
        }
    }
}
