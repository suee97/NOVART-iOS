//
//  Dismissible.swift
//  Novart
//
//  Created by Jinwook Huh on 2023/06/25.
//

import Foundation

protocol Dismissible {
    var onDismissed: (() -> Void)? { get }
    func dismiss(animated: Bool)
}
