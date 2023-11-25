//
//  KeychainService.swift
//  Novart
//
//  Created by Jinwook Huh on 2023/07/22.
//

import Foundation
import KeychainAccess

class KeychainService: KeyValueStorable {
    static let shared = KeychainService()
    private let lockCredentials = Keychain()
    
    private init() { }
    
    func save(key: String, value: String) {
        do {
            try lockCredentials.set(value, key: key)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func load(key: String) -> String? {
        do {
            guard let value = try lockCredentials.get(key) else { return nil }
            return value
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
    func delete(key: String) {
        do {
            try lockCredentials.remove(key)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func removeAll() {
        do {
            try lockCredentials.removeAll()
        } catch {
            print(error.localizedDescription)
        }
    }
}

