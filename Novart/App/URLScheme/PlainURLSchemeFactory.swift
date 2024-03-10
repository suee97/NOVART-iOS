//
//  PlainURLSchemeFactory.swift
//  Novart
//
//  Created by Jinwook Huh on 3/10/24.
//

import UIKit


final class PlainURLSchemeFactory {
    
    private enum PlainDomain: String {
        case home
        case exhibition
        case profile
        case art
        
        init?(stringValue: String?) {
            guard let lowercaseValue = stringValue?.lowercased(),
                  let matchingCase = PlainDomain(rawValue: lowercaseValue) else {
                return nil
            }
            self = matchingCase
        }
    }
    
    static func create(url: URL) -> URLSchemeExecutable? {
        guard let domain = parseDomainFromURL(url.absoluteString),
              let host = PlainDomain(stringValue: domain)
        else {
            return nil
        }
        
        switch host {
        case .home:
            return URLSchemeHomeAction(url: url)
        case .art:
            return URLSchemeProductAction(url: url)
        case .profile:
            return URLSchemeProfileAction(url: url)
        default:
            return nil
        }
    }
    
    static func parseDomainFromURL(_ urlString: String) -> String? {
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return nil
        }
        
        let pathComponents = url.pathComponents
        guard pathComponents.count > 1 else {
            print("Path components missing")
            return nil
        }
        
        let domain = pathComponents[1]
        return domain
    }
}
