//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by   Дмитрий Кривенко on 24.04.2025.
//
import Foundation

class OAuth2TokenStorage {
    private let key = "auth.token"
    
    var token: String? {
        get {
            UserDefaults.standard.string(forKey: key)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: key)
        }
    }
}
