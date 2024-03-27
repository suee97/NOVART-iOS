//
//  APIClient+User.swift
//  Novart
//
//  Created by Jinwook Huh on 2023/07/22.
//

import Alamofire
import Foundation

extension APIClient {
    static func getUser() async throws -> PlainUser {
        try await APIClient.request(target: UserTarget.getUser, type: PlainUser.self)
    }
    
    static func setNickname(as nickname: String) async throws -> NetworkResponse<SetNameResponse> {
        try await APIClient.request(target: UserTarget.setNickname(nickname: nickname), type: NetworkResponse<SetNameResponse>.self)
    }
    
    static func checkValidNickname(nickname: String) async throws -> Bool {
        try await APIClient.request(target: UserTarget.checkValidNickname(nickname: nickname), type: Bool.self)
    }
    
    static func putDeviceToken(deviceToken: String) async throws -> EmptyResponseModel {
        try await APIClient.request(target: UserTarget.putDeviceToken(deviceToken: deviceToken), type: EmptyResponseModel.self)
    }
    
    static func testNotification() async throws -> EmptyResponseModel {
        try await APIClient.request(target: UserTarget.deviceTokenTest(deviceToken: "cMckIXTlVkePlX54pfzADd:APA91bFnqk0--7OoyBVEMqqFVYNhQmn9XS9bMBkpY4jDFBSaei2N9eGdBded-e6OXEdQ961_iIokM8cbtUD3LCx2wtr_7VdR0bTylIrUp2Telf3RrcbTSQbNiaR6_hGtou4H4HM8yjJV"), type: EmptyResponseModel.self)
    }
}
