//
//  ProfileLogoutService.swift
//  ImageFeed
//
//  Created by   Дмитрий Кривенко on 21.08.2025.
//

import Foundation
import WebKit

final class ProfileLogoutService {
    static let shared = ProfileLogoutService()
    
    private let storage = OAuth2TokenStorage()
  
    private init() { }

    func logout() {
        cleanCookies()
        resetServicesData()
        storage.removeToken()
    }

    private func cleanCookies() {
        HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
        WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
            records.forEach { record in
                WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record], completionHandler: {})
            }
        }
    }
    
    private func resetServicesData() {
        let services: [DataResettable] = [ProfileService.shared, ImagesListService.shared, ProfileImageService.shared]
        for service in services {
            service.resetData()
        }
    }
}

protocol DataResettable {
    func resetData()
}
