//
//  OAuth2Service.swift
//  ImageFeed
//
//  Created by   Дмитрий Кривенко on 20.04.2025.
//
import Foundation

final class OAuth2Service {
    // MARK: - static properties
    
    static let shared = OAuth2Service()
    
    // MARK: - public methods
    
    func fetchOAuthToken(code: String, completion: @escaping (_ result: Result<Data, Error>) -> Void) {
        guard let request = getTokenRequest(code: code) else {
            print("Empty token request")
            return
        }
        let task = URLSession.shared.data(for: request, completion: { result in
            completion(result)
        })
        
        task.resume()
    }
    
    // MARK: - private methods
    
    private init() {}
    
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
