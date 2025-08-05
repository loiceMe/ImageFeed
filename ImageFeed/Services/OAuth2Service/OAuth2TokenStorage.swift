//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by   Дмитрий Кривенко on 24.04.2025.
//
import Foundation
import SwiftKeychainWrapper

final class OAuth2TokenStorage {
    private let key = "auth.token"
    
    var token: String? {
        get {
            return KeychainWrapper.standard.string(forKey: key)
        }
        set {
            guard let keyValue = newValue else { return }
            KeychainWrapper.standard.set(keyValue, forKey: key)
        }
    }
}
