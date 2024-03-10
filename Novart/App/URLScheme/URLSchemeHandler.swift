//
//  URLSchemeHandler.swift
//  Novart
//
//  Created by Jinwook Huh on 3/9/24.
//

import Foundation

@MainActor
final class URLSchemeHandler {
    
    private weak var coordinator: (any Coordinator)?
    
    init(coordinator: any Coordinator) {
        self.coordinator = coordinator
    }
    
    @discardableResult
    func execute(url: URL) -> Bool {
        return execute(request: URLRequest(url: url))
    }
    
    func execute(request: URLRequest) -> Bool {
        return execute(request: request, isMainFrame: true)
    }
    
    func execute(request: URLRequest, isMainFrame: Bool) -> Bool {
        return URLSchemeFactory.create(request: request, isMainFrame: isMainFrame)?.execute(to: coordinator) ?? false
    }
}
