//
//  OAuth2Service.swift
//  ImageFeed
//
//  Created by   Дмитрий Кривенко on 20.04.2025.
//
import Foundation

enum AuthServiceError: Error {
    case invalidRequest
}

final class OAuth2Service {
    // MARK: - static properties
    
    static let shared = OAuth2Service()
    
    // MARK: - private properties
    
    private var task: URLSessionTask?
    
    private var lastCode: String?
    
    // MARK: - init
    
    private init() {}
    
    // MARK: - public methods
    
    func fetchOAuthToken(code: String, completion: @escaping (_ result: Result<OAuth2TokenResponseBody, Error>) -> Void) {
        assert(Thread.isMainThread)
        if task != nil {
            if code != lastCode {
                task?.cancel()
            } else {
                completion(.failure(AuthServiceError.invalidRequest))
                return
            }
        } else {
            if lastCode == code {
                completion(.failure(AuthServiceError.invalidRequest))
                return
            }
        }
        lastCode = code
        
        guard let request = getTokenRequest(code: code) else {
            completion(.failure(AuthServiceError.invalidRequest))
            return
        }

        let task = URLSession.shared.objectTask(for: request,
                                                completion: { [weak self] (result: Result<OAuth2TokenResponseBody, Error>) in
            completion(result)
            self?.task = nil
            self?.lastCode = nil
        })
        self.task = task
        task.resume()
    }
    
    // MARK: - private methods
    
    private func getTokenRequest(code: String) -> URLRequest? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "unsplash.com"
        components.path = "/oauth/token"
        components.queryItems = [
            URLQueryItem(name: "client_id", value: Constants.accessKey),
            URLQueryItem(name: "client_secret", value: Constants.secretKey),
            URLQueryItem(name: "redirect_uri", value: Constants.redirectURI),
            URLQueryItem(name: "code", value: code),
            URLQueryItem(name: "grant_type", value: "authorization_code")
        ]
        
        guard let url = components.url(relativeTo: Constants.defaultBaseURL) else {
            print("Failed URL Components")
            return nil
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        return request
    }
}
