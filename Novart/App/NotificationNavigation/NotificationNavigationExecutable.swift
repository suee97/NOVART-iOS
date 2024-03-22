//
//  NotificationNavigationExecutable.swift
//  Novart
//
//  Created by Jinwook Huh on 3/22/24.
//

import UIKit

protocol NotificationNavigationExecutable {
    var notification: NotificationModel { get set }
    func execute(to coordinator: (any Coordinator)?, asPush: Bool) -> Bool
}
