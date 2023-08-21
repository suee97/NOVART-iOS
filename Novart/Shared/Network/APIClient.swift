//
//  APIClient.swift
//  Novart
//
//  Created by Jinwook Huh on 2023/07/22.
//

import Alamofire
import Foundation

class APIClient {
    static let shared = APIClient()
    private let reachabilityManager = NetworkReachabilityManager()
    
    let session: Session = {
        let configuration = URLSessionConfiguration.af.default
        configuration.timeoutIntervalForRequest = 30
        
        let adapters = [HeadersAdapter()]
        
        let interceptor = Interceptor(adapters: adapters)
        
        return Session(
            configuration: configuration,
            interceptor: interceptor,
            eventMonitors: [APIEventMonitor()]
        )
    }()
    
    init() {
        startNetworkReachabilityObserver()
    }
    
    deinit {
        reachabilityManager?.stopListening()
    }
    
    private func startNetworkReachabilityObserver() {
        reachabilityManager?.startListening(
            onUpdatePerforming: { status in
            switch status {
            case .notReachable:
                print("The network is not reachable")
                
            case .unknown:
                print("It is unknown whether the network is reachable")
                
            case .reachable(.ethernetOrWiFi):
                print("The network is reachable over Ethernet or WiFi connection")
                
            case .reachable(.cellular):
                print("The network is reachable over Cellular connection")
                
            }
        })
    }
    
    static func request<D: Decodable>(target: URLRequestConvertible, type: D.Type) async throws -> D {
        let accessToken = KeychainService.shared.accessToken
        
        let credential = OAuthCredential(accessToken: accessToken, expiration: Date(timeIntervalSinceNow: 60 * 60))
        
        let authenticator = OAuthAuthenticator()
        let interceptor = AuthenticationInterceptor(
            authenticator: authenticator,
            credential: credential
        )
        
        let response = await APIClient.shared.session
            .request(target, interceptor: interceptor)
            .validate(statusCode: 200..<300)
            .serializingDecodable(D.self, emptyResponseCodes: [200])
            .response
        
        switch response.result {
        case .success(let data):
            return data
            
        case .failure(let error):
            throw APIError(message: error.localizedDescription, code: .UNKNOWN)
        }
        
    }
}
