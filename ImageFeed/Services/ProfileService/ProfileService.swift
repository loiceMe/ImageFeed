//
//  ProfileService.swift
//  ImageFeed
//
//  Created by   Дмитрий Кривенко on 23.05.2025.
//
import Foundation

enum ProfileServiceError: Error {
    case invalidRequest
}

final class ProfileService {
    // MARK: - static properties
    
    static let shared = ProfileService()
    
    // MARK: - public properties
    
    private(set) var profile: Profile?
    
    // MARK: - private properties
    
    private var task: URLSessionTask?
    
    // MARK: - public methods
    
    func fetchProfile(authToken: String, completion: @escaping (_ result: Result<ProfileResponseBody, Error>) -> Void) {
        assert(Thread.isMainThread)
        if task != nil {
            task?.cancel()
        }
        
        guard let request = getProfileRequest(authToken: authToken) else {
            completion(.failure(ProfileServiceError.invalidRequest))
            return
        }

        let task = URLSession.shared.objectTask(for: request,
                                                completion: { [weak self] (result: Result<ProfileResponseBody, Error>) in
            completion(result)
            self?.task = nil
        })
        self.task = task
        task.resume()
    }
    
    func responseToProfile(response: ProfileResponseBody) {
        self.profile = Profile(username: response.username,
                       name: "\(response.firstName ?? "") \(response.lastName ?? "")",
                       loginName: "@\(response.username)",
                       bio: response.bio ?? "<не заполнено>")
    }
    
    // MARK: - private methods
    
    private init() {}
    
    private func getProfileRequest(authToken: String) -> URLRequest? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.unsplash.com"
        components.path = "/me"
        
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
