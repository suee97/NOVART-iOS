//
//  LikeTarget.swift
//  Novart
//
//  Created by Jinwook Huh on 2023/06/11.
//

import Alamofire
import Foundation

enum LikeTarget: TargetType {
    case postLike(id: String)
    
    var baseURL: String {
        API.baseURL
    }
    
    var path: String {
        return "likes"
    }
    
    var method: HTTPMethod {
        return .post
    }
    
    var parameters: RequestParams {
        
        switch self {
        case .postLike(let id):
            return .body(["id": id])
        }
    }
}
