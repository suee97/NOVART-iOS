//
//  KeyValueStorable.swift
//  Novart
//
//  Created by Jinwook Huh on 2023/07/22.
//

import Foundation

protocol KeyValueStorable {
    func save(key: String, value: String)
    func load(key: String) -> String?
    func delete(key: String)
    func removeAll()
}

extension KeyValueStorable {
    var accessToken: String? {
        load(key: KeyChainKey.accessToken)
    }
    
    var refreshToken: String? {
        load(key: KeyChainKey.refreshToken)
    }
    
    func saveAccessToken(_ token: String) {
        save(key: KeyChainKey.accessToken, value: token)
    }
    
    func saveRefreshToken(_ token: String) {
        save(key: KeyChainKey.refreshToken, value: token)
    }
    
    func removeToken() {
        delete(key: KeyChainKey.accessToken)
        delete(key: KeyChainKey.refreshToken)
    }
}

