//
//  APIEventMonitor.swift
//  Novart
//
//  Created by Jinwook Huh on 2023/07/22.
//

import Alamofire
import Foundation

class APIEventMonitor: EventMonitor {
    let queue = DispatchQueue(label: "Novart-Alamofire-Monitor")

    func requestDidFinish(_ request: Request) {
        print("🤖 \(queue.label) - NETWORK Reqeust LOG")
        print(request.description)
        print("Headers: " + "\(request.request?.allHTTPHeaderFields ?? [:])")
        print("Authorization: " + (request.request?.headers["Authorization"] ?? ""))
        print("Body: " + (request.request?.httpBody?.prettyPrintedString ?? ""))
    }

    func request<Value>(_ request: DataRequest, didParseResponse response: DataResponse<Value, AFError>) {
        print("🤖 \(queue.label) - NETWORK Response LOG")
        print("URL: " + (request.request?.url?.absoluteString ?? "") + " (\(response.response?.statusCode ?? 0))")
        print("Data: \(response.data?.prettyPrintedString ?? "")")
    }
}

extension Data {
    var prettyPrintedString: String? {
        guard let object = try? JSONSerialization.jsonObject(with: self, options: []),
              let data = try? JSONSerialization.data(withJSONObject: object, options: [.prettyPrinted]),
              let prettyPrintedString = NSString(data: data, encoding: String.Encoding.utf8.rawValue) else { return nil }
        return prettyPrintedString as String
    }
}


