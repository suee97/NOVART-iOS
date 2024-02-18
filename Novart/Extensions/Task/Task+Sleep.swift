//
//  Task+Sleep.swift
//  Novart
//
//  Created by Jinwook Huh on 2/17/24.
//

import Foundation

public extension Task where Success == Never, Failure == Never {
    
    static func sleep(seconds: Double) async throws {
        try await Task.sleep(nanoseconds: UInt64(seconds * 1_000_000_000))
    }
}

