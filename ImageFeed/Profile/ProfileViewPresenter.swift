//
//  ProfileViewPresenter.swift
//  ImageFeed
//
//  Created by   Дмитрий Кривенко on 02.09.2025.
//
import Foundation

final class ProfileViewPresenter: ProfileViewPresenterProtocol {
    
    weak var view: ProfileViewControllerProtocol?
    
    private var profileImageServiceObserver: NSObjectProtocol?
    private let profileService = ProfileService.shared
    private let profileImageService: ProfileImageServiceProtocol
    private let profileLogoutService = ProfileLogoutService.shared
    
    init(profileImageService: ProfileImageServiceProtocol = ProfileImageService.shared) {
        self.profileImageService = profileImageService
    }
    
    func viewDidLoad() {
        view?.updateProfileDetails(profile: profileService.profile)
        view?.updateAvatar(avatarURL: profileImageService.avatarURL ?? "")
        profileImageServiceObserver = NotificationCenter.default
            .addObserver(
                forName: ProfileImageService.didChangeNotification,
                object: nil,
                queue: .main
            ) { [weak self] _ in
                guard let self = self else { return }
                self.view?.updateAvatar(avatarURL: self.profileImageService.avatarURL ?? "")
            }
    }
    
    func logout() {
        profileLogoutService.logout()
    }
}

public protocol ProfileViewPresenterProtocol {
    var view: ProfileViewControllerProtocol? { get set }
    
    func viewDidLoad()
    func logout()
}
