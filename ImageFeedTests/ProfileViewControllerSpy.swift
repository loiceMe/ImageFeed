//
//  ProfileViewControllerSpy.swift
//  ImageFeed
//
//  Created by   Дмитрий Кривенко on 03.09.2025.
//

import ImageFeed
import Foundation

final class ProfileViewControllerSpy: ProfileViewControllerProtocol {
    var presenter: (any ImageFeed.ProfileViewPresenterProtocol)?
    var avatarUpdatedCount = 0
    
    func updateAvatar(avatarURL: String) {
        avatarUpdatedCount += 1
    }
    
    func updateProfileDetails(profile: ImageFeed.Profile?) {
        
    }
}
