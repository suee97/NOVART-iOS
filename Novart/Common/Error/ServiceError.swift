//
//  ServiceError.swift
//  Novart
//
//  Created by Jinwook Huh on 2023/07/22.
//

import Foundation

enum ServiceError: Error {
    case rootViewControllerNotFound
    case kakaoTalkLoginUnavailable
}
