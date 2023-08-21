//
//  NavigationActionable.swift
//  Novart
//
//  Created by Jinwook Huh on 2023/06/25.
//

import UIKit

protocol NavigationActionable {
    func start(_ viewController: UIViewController)
    func push(_ viewController: UIViewController, animated: Bool)
    func pop(animated: Bool)
    func first(is type: UIViewController.Type) -> UIViewController?
    func last(is type: UIViewController.Type) -> UIViewController?
    func pop(to type: UIViewController.Type, animated: Bool)
    func popToRoot(animated: Bool)
}
