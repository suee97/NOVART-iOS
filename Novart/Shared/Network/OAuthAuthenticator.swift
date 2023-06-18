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
    
    var requiresRefresh: Bool { Date(timeIntervalSinceNow: 60 * 5) > expiration }
}


class OAuthAuthenticator: Authenticator {
    
    
    func didRequest(_ urlRequest: URLRequest, with response: HTTPURLResponse, failDueToAuthenticationError error: Error) -> Bool {
        return response.statusCode == 403
    }
    
    func isRequest(_ urlRequest: URLRequest, authenticatedWith credential: OAuthCredential) -> Bool {
        return urlRequest.headers[HTTPHeaderField.authentication.rawValue] == HTTPHeader.authorization(bearerToken: credential.accessToken ?? "").value
    }
    
    func apply(_ credential: OAuthCredential, to urlRequest: inout URLRequest) {
        if let accessToken = credential.accessToken {
            urlRequest.headers.add(name: HTTPHeaderField.authentication.rawValue, value: "Bearer \(accessToken)")
        }
    }
    
    func refresh(_ credential: OAuthCredential, for session: Session, completion: @escaping (Result<OAuthCredential, Error>) -> Void) {
        
        guard let refreshToken = KeychainService.shared.refreshToken else {
            completion(.failure(APIError(message: "refresh token decoding fail", code: .TokenRefreshFail)))
            return
        }
        let url = URL(string: API.baseURL + "auth/refresh")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let authHeaderValue = "Bearer \(refreshToken)"
        request.addValue(authHeaderValue, forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                if let error = error {
                    completion(.failure(error))
                }
                return
            }

            let decoder = JSONDecoder()
            let decodedData = try? decoder.decode(NetworkResponse<TokenRefreshResponse>.self, from: data)
            guard let token = decodedData?.data else {
                completion(.failure(APIError(message: "refresh token decoding fail", code: .TokenRefreshFail)))
                return
            }
            KeychainService.shared.saveAccessToken(token.accessToken)
            KeychainService.shared.saveRefreshToken(token.refreshToken)
            
            let newCredential = OAuthCredential(accessToken: token.accessToken, expiration: Date(timeIntervalSinceNow: 60 * 28))
            completion(.success(newCredential))
        }
        
        task.resume()
    }
    
}
