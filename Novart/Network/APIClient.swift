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
        
        // 푸시 알림 테스트 계정 토큰입니다.
//        let accessToken = "eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiIxIiwicm9sZSI6IlJPTEVfVVNFUiIsImV4cCI6MTcwMzk3NzE5MX0.yIjh7D5twww7P71lwZZIvAmgkhb3Brj9RzaJj4raCaJORXfXTaVYyIzyO33MqIWFARmaGAcUtKDURfLMvrws9A"
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
            print(error)
            throw APIError(message: error.localizedDescription, code: .UNKNOWN)
        }
        
    }
    
    @discardableResult
    static func uploadJpegData(uploadUrl: String, data: Data) async throws -> Data? {
                
        return try await withCheckedThrowingContinuation({ continuation in
            guard let url = URL(string: uploadUrl) else {
                continuation.resume(throwing: APIError.init(message: "invalidURL!", code: .invalidUrl))
                return
            }
            var request: URLRequest = URLRequest(url: url)
            request.httpMethod = "PUT"
            request.setValue("image/jpeg", forHTTPHeaderField: "Content-Type")
            
            request.httpBody = data

            AF.request(request).response { response in
                // Handle response
                switch response.result {
                case .success(let data):
                    continuation.resume(returning: data)
                    return
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
            
        })
    }
}
