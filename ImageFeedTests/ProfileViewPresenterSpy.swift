//
//  ProfilePresenterSpy.swift
//  ImageFeed
//
//  Created by   Дмитрий Кривенко on 03.09.2025.
//

import ImageFeed
import Foundation

final class ProfileViewPresenterSpy: ProfileViewPresenterProtocol {
    var view: ProfileViewControllerProtocol?
    
    var viewDidLoadCalled: Bool = false
    
    func viewDidLoad() {
        viewDidLoadCalled = true
    }
    
    func logout() {
        
    }
}

final class ProfileImageServiceStub: ProfileImageServiceProtocol {
    var avatarURL: String? = nil
    var calledFetchProfileImageURL = false
    
    func fetchProfileImageURL(authToken: String, username: String, completion: @escaping (Result<ImageFeed.UserResult, any Error>) -> Void) {
        calledFetchProfileImageURL = true
    }
    
    
}
