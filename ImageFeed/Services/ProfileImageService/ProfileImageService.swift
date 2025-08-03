//
//  ProfileImageService.swift
//  ImageFeed
//
//  Created by   Дмитрий Кривенко on 24.05.2025.
//

import Foundation

enum ProfileImageServiceError: Error {
    case invalidRequest
}

final class ProfileImageService {
    // MARK: - static properties
    
    static let shared = ProfileImageService()
    
    static let didChangeNotification = Notification.Name(rawValue: "ProfileImageProviderDidChange")
    
    // MARK: - public properties
    
    private(set) var avatarURL: String?
    
    // MARK: - private properties
    
    private var task: URLSessionTask?
    
    // MARK: - init
    
    private init() {}
    
    // MARK: - public methods
    
    func fetchProfileImageURL(authToken: String, username: String, completion: @escaping (_ result: Result<UserResult, Error>) -> Void) {
        assert(Thread.isMainThread)
        if task != nil {
            task?.cancel()
        }
        
        guard let request = getProfileRequest(authToken: authToken, username: username) else {
            completion(.failure(ProfileServiceError.invalidRequest))
            return
        }

        let task = URLSession.shared.objectTask(for: request, completion: { [weak self] (result: Result<UserResult, Error>) in
            switch result {
            case .success(let data):
                self?.avatarURL = data.profileImage.small
                break
            case .failure(let error):
                print(error)
                break
            }
            
            completion(result)
            NotificationCenter.default.post(name: ProfileImageService.didChangeNotification,
                                            object: self,
                                            userInfo: ["URL": self?.avatarURL ?? ""])
            self?.task = nil
        })
        self.task = task
        task.resume()
    }
    
    // MARK: - private methods
    
    private func getProfileRequest(authToken: String, username: String) -> URLRequest? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.unsplash.com"
        components.path = "/users/\(username)"
        
        guard let url = components.url(relativeTo: Constants.defaultBaseURL) else {
            print("Failed URL Components")
            return nil
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(authToken)", forHTTPHeaderField: "Authorization")
        
        return request
    }
}
