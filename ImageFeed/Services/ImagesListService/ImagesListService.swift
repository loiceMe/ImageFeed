//
//  ImagesListService.swift
//  ImageFeed
//
//  Created by   Дмитрий Кривенко on 20.07.2025.
//
import Foundation

class ImagesListService {
    // MARK: - static properties
    
    static let didChangeNotification = Notification.Name(rawValue: "ImagesListServiceDidChange")
    
    private var currentPageNumber = 1
    
    var photos: [Photo] = []
    
    private var task: URLSessionTask?
    
    public func fetchPhotosNextPage(authToken: String, completion: @escaping (_ result: Result<[PhotoResult], Error>) -> Void) {
        assert(Thread.isMainThread)
        if task == nil {
            guard let request = getImagesListRequest(authToken: authToken, page: currentPageNumber) else {
                completion(.failure(ProfileServiceError.invalidRequest))
                return
            }
            
            let task = URLSession.shared.objectTask(for: request, completion: { [weak self] (result: Result<[PhotoResult], Error>) in
                switch result {
                case .success(let data):
                    self?.photos.append(contentsOf: [])
                    self?.currentPageNumber += 1
                    break
                case .failure(let error):
                    print(error)
                    break
                }

                NotificationCenter.default.post(name: ImagesListService.didChangeNotification,
                                                object: self,
                                                userInfo: ["photos": self?.photos ?? []])
                self?.task = nil
            })
            task.resume()
            self.task = task
        }
    }
    
    private func getImagesListRequest(authToken: String, page: Int) -> URLRequest? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.unsplash.com"
        components.path = "/photos"
        components.queryItems = [
            URLQueryItem(name: "page", value: "\(page)"),
            URLQueryItem(name: "per_page", value: "10"),
        ]
        
        guard let url = components.url(relativeTo: Constants.defaultBaseURL) else {
            print("Failed URL Components")
            return nil
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        // request.setValue("Bearer \(authToken)", forHTTPHeaderField: "Authorization")
        
        return request
    }
}

