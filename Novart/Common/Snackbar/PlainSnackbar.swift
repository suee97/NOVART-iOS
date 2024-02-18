//
//  PlainSnackbar.swift
//  Novart
//
//  Created by Jinwook Huh on 2/17/24.
//

import UIKit

final class SnackbarWindow: UIWindow {
    
    private var isPad: Bool {
        return UIDevice.current.userInterfaceIdiom == .pad
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let resultView = super.hitTest(point, with: event)
        let padWorkaround = isPad && !(resultView?.superview is PassthroughView) && !(resultView?.superview?.superview is PlainSnackbarView)
        if resultView == self || padWorkaround {
            return nil
        }
        return resultView
    }
}

public class PlainSnackbar {
    
    static let shared = PlainSnackbar()
    
    private var snackbarWindow: SnackbarWindow?
    private var contextViewController: SnackbarContextViewController?
    
    // MARK: - Remove
    
    func show(window: SnackbarWindow?, viewController: SnackbarContextViewController) {
        self.snackbarWindow = window
        self.snackbarWindow?.rootViewController = viewController
        self.snackbarWindow?.makeKeyAndVisible()
        
        self.contextViewController = viewController
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) { [weak self] in
            self?.snackbarWindow?.rootViewController?.setNeedsStatusBarAppearanceUpdate()
        }
    }
    
    func remove() {
        self.contextViewController?.removeAll()
        self.snackbarWindow?.rootViewController = nil
        
        if self.snackbarWindow?.isKeyWindow == true {
            self.snackbarWindow?.resignKey()
        }
        
        self.snackbarWindow?.removeFromSuperview()
        
        self.snackbarWindow = nil
        self.contextViewController = nil
    }
    
    // MARK: - Make
    
    private func makeSnackbarWindow() -> SnackbarWindow? {
        let windowScene = UIApplication.shared
            .connectedScenes
            .first(where: { $0.activationState == .foregroundActive })
        
        var window: SnackbarWindow?
        
        if let windowScene = windowScene as? UIWindowScene {
            window = SnackbarWindow(windowScene: windowScene)
        } else {
            window = SnackbarWindow(frame: UIScreen.main.bounds)
        }
        
        window?.frame = UIScreen.main.bounds
        window?.isOpaque = false
        window?.backgroundColor = .clear
        window?.windowLevel = UIWindow.Level.statusBar + 1
        return window
    }
    
    private func makeContextViewController(message: String,
                                           configuration: PlainSnackbarView.Configuration? = nil,
                                           delay: Double? = nil,
                                           duration: Double? = nil,
                                           completion: (() -> Void)? = nil) -> SnackbarContextViewController {
        let viewController = SnackbarContextViewController(message: message,
                                                           configuration: configuration,
                                                           delay: delay,
                                                           duration: duration,
                                                           completion: completion)
        return viewController
    }
}

// MARK: - Static Function

public extension PlainSnackbar {
    
    static func show(viewController: UIViewController,
                     message: String,
                     configuration: PlainSnackbarView.Configuration? = nil,
                     delay: Double? = nil,
                     duration: Double? = nil,
                     completion: (() -> Void)? = nil) {
        let snackBar = PlainSnackbarView(message: message, configuration: configuration)
        snackBar.show(in: viewController.view, delay: delay, duration: duration, completion: completion)
    }
    
    static func show(message: String,
                     configuration: PlainSnackbarView.Configuration? = nil,
                     delay: Double? = nil,
                     duration: Double? = nil,
                     completion: (() -> Void)? = nil) {
        if PlainSnackbar.shared.snackbarWindow != nil {
            PlainSnackbar.shared.remove()
        }
        
        let window = PlainSnackbar.shared.makeSnackbarWindow()
        let contextViewController = PlainSnackbar.shared.makeContextViewController(message: message,
                                                                                configuration: configuration,
                                                                                delay: delay,
                                                                                duration: duration) {
            PlainSnackbar.shared.remove()
            completion?()
        }
        
        PlainSnackbar.shared.show(window: window, viewController: contextViewController)
    }
    
}

