//
//  NotificationNavigationFactory.swift
//  Novart
//
//  Created by Jinwook Huh on 3/22/24.
//

import UIKit

struct NotificationNavigationFactory {
    static func create(notification: NotificationModel) -> NotificationNavigationExecutable? {
        switch notification.type {
        case .Follow:
            return NotificationProfileAction(notification: notification)
        case .Likes:
            return NotificationProductAction(notification: notification)
        case .Comment:
            return NotificationProductAction(notification: notification)
        case .Welcome:
            return nil
        case .Register:
            return NotificationProductAction(notification: notification)
        }
    }
}
