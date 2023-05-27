//
//  OAuthAuthenticator.swift
//  Novart
//
//  Created by Jinwook Huh on 2023/04/29.
//

import Alamofire
import Foundation

struct OAuthCredential: AuthenticationCredential {
    let accessToken: String?
    let expiration: Date
    
    // Require refresh if within 5 minutes of expiration
    var requiresRefresh: Bool { Date(timeIntervalSinceNow: 60 * 5) > expiration }
}


class OAuthAuthenticator: Authenticator {
    
    
    func didRequest(_ urlRequest: URLRequest, with response: HTTPURLResponse, failDueToAuthenticationError error: Error) -> Bool {
        return response.statusCode == 401
    }
    
    func isRequest(_ urlRequest: URLRequest, authenticatedWith credential: OAuthCredential) -> Bool {
        return urlRequest.headers[HTTPHeaderField.authentication.rawValue] == credential.accessToken
    }
    
    func apply(_ credential: OAuthCredential, to urlRequest: inout URLRequest) {
        if let accessToken = credential.accessToken {
            urlRequest.headers.add(name: HTTPHeaderField.authentication.rawValue, value: "Bearer \(accessToken)")
        }
    }
    
    func refresh(_ credential: OAuthCredential, for session: Session, completion: @escaping (Result<OAuthCredential, Error>) -> Void) {
        // refresh token으로 새로운 access token 가져오기
    }
    
}
