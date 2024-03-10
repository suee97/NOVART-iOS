//
//  URLSchemeFactory.swift
//  Novart
//
//  Created by Jinwook Huh on 3/9/24.
//

import UIKit

struct URLSchemeFactory {
    static let plainURLScheme: String = "plain-app-dev"
    
    static func create(request: URLRequest, isMainFrame: Bool) -> URLSchemeExecutable? {
        return URLSchemeFactoryType(request: request, isMainFrame: isMainFrame)?.create()
    }
}

enum URLSchemeFactoryType {
    
    case common(_ url: URL)
    case plain(_ url: URL)
    
    init?(request: URLRequest, isMainFrame: Bool) {
        guard let url = request.url, let host = url.host(), isMainFrame else { return nil }
        
        if host.hasPrefix("plain-app-dev") {
            self = .plain(url)
        } else {
            self = .common(url)
        }
    }
    
    func create() -> URLSchemeExecutable? {
        switch self {
        case .plain(let url):
            return PlainURLSchemeFactory.create(url: url)
        case .common:
            return nil
        }
    }
}

