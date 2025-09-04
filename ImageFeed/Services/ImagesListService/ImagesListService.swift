//
//  ImagesListService.swift
//  ImageFeed
//
//  Created by   Дмитрий Кривенко on 20.07.2025.
//
import Foundation

final class ImagesListService: ImagesListServiceProtocol {
    // MARK: - static properties
    
    static let didChangeNotification = Notification.Name(rawValue: "ImagesListServiceDidChange")
        
    static let shared = ImagesListService()
    
    // MARK: - private properties
    
    private var currentPageNumber = 1
    
    private let dateFormatter = ISO8601DateFormatter()
    
    private let storage = OAuth2TokenStorage()
    
    var photos: [Photo] = []
    
    private var task: URLSessionTask?
    
    public func fetchPhotosNextPage() {
        assert(Thread.isMainThread)
        if task == nil {
            guard let request = getImagesListRequest(page: currentPageNumber) else {
                print("Invalid Request")
                return
            }
            
            let task = URLSession.shared.objectTask(for: request, completion: { [weak self] (result: Result<[PhotoResult], Error>) in
                switch result {
                case .success(let photosResult):
                    let newPhotos = self?.resultToPhotos(photosResult)
                    self?.photos.append(contentsOf: newPhotos ?? [])
                    self?.currentPageNumber += 1
                    NotificationCenter.default.post(name: ImagesListService.didChangeNotification,
                                                    object: self,
                                                    userInfo: ["photos": self?.photos ?? []])
                    break
                case .failure(let error):
                    print(error)
                    break
                }

                self?.task = nil
            })
            task.resume()
            self.task = task
        }
    }
    
    public func changeLike(photoId: String, isLike: Bool, _ completion: @escaping (Result<Void, Error>) -> Void) {
        assert(Thread.isMainThread)
        if task == nil {
            guard let request = getChangeLikeRequest(photoId: photoId, isLike: isLike) else {
                print("Invalid Request")
                return
            }
            
            let task = URLSession.shared.objectTask(for: request, completion: { [weak self] (result: Result<LikePhotoResult, Error>) in
                switch result {
                case .success(let photoResult):
                    if let index = self?.photos.firstIndex(where: { $0.id == photoId }) {
                        if let photo = self?.photos[index] {
                            let newPhoto = Photo(
                                     id: photo.id,
                                     size: photo.size,
                                     createdAt: photo.createdAt,
                                     welcomeDescription: photo.welcomeDescription,
                                     thumbImageURL: photo.thumbImageURL,
                                     largeImageURL: photo.largeImageURL,
                                     isLiked: !photo.isLiked
                                 )
                            
                            self?.photos[index] = newPhoto
                        }
                    }
                    completion(.success(()))
                    break
                case .failure(let error):
                    completion(.failure(error))
                    break
                }

                self?.task = nil
            })
            task.resume()
            self.task = task
        }
    }
    
    private func getImagesListRequest(page: Int) -> URLRequest? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.unsplash.com"
        components.path = "/photos"
        components.queryItems = [
            URLQueryItem(name: "page", value: "\(page)"),
            URLQueryItem(name: "per_page", value: "10"),
        ]
        
        return getBaseAuthorizedRequest(url: components.url(relativeTo: Constants.defaultBaseURL))
    }
    
    private func getChangeLikeRequest(photoId: String, isLike: Bool) -> URLRequest? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.unsplash.com"
        components.path = "/photos/\(photoId)/like"
        
        return getBaseAuthorizedRequest(url: components.url(relativeTo: Constants.defaultBaseURL),
                                        method: isLike ? "DELETE" : "POST")
    }
    
    private func getBaseAuthorizedRequest(url: URL?, method: String = "GET") -> URLRequest? {
        guard let token = storage.token else {
            print("No token")
            return nil
        }
        guard let url = url else {
            print("Failed URL")
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        return request
    }
    
    private func resultToPhotos(_ photosResult: [PhotoResult]) -> [Photo] {
        return photosResult.map { photoResult in
            return Photo(id: photoResult.id,
                         size: CGSize(width: photoResult.width, height: photoResult.height),
                         createdAt: dateFormatter.date(from: photoResult.createdAt ?? ""),
                         welcomeDescription: photoResult.description ?? "",
                         thumbImageURL: photoResult.urls.regular,
                         largeImageURL: photoResult.urls.full,
                         isLiked: photoResult.likedByUser)
        }
    }
}

extension ImagesListService: DataResettable {
    func resetData() {
        photos = []
        currentPageNumber = 1
    }
}

public protocol ImagesListServiceProtocol {
    var photos: [Photo] { get }
    
    func changeLike(photoId: String, isLike: Bool, _ completion: @escaping (Result<Void, Error>) -> Void)
    func fetchPhotosNextPage()
}
