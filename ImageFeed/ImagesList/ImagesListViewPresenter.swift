//
//  ImagesListViewPresenter.swift
//  ImageFeed
//
//  Created by   Дмитрий Кривенко on 02.09.2025.
//
import Foundation

final class ImagesListViewPresenter: ImagesListViewPresenterProtocol {
    var photosCount: Int {
        return photos.count
    }
    
    private var imagesListService: ImagesListServiceProtocol
    private var imagesListServiceObserver: NSObjectProtocol?
    private var photos: [Photo] = []
    weak var view: ImagesListViewControllerProtocol?
    
    init(imagesListService: ImagesListServiceProtocol = ImagesListService.shared) {
        self.imagesListService = imagesListService
    }
    
    func viewDidLoad () {
        imagesListServiceObserver = NotificationCenter.default
            .addObserver(
                forName: ImagesListService.didChangeNotification,
                object: nil,
                queue: .main
            ) { [weak self] _ in
                guard let oldCount = self?.photos.count,
                      let newCount = self?.imagesListService.photos.count
                else { return }
                if (oldCount < newCount) {
                    DispatchQueue.main.async {
                        self?.photos = self?.imagesListService.photos ?? []
                        self?.view?.updateTableViewAnimated(oldCount: oldCount,
                                                            newCount: newCount)
                    }
                }
            }
        
        imagesListService.fetchPhotosNextPage()
    }
    
    func getPhoto(by index: Int) -> Photo? {
        if photos.indices.contains(index) {
            return photos[index]
        } else {
            return nil
        }
    }
    
    func willShowPhoto(of index: Int) {
        if index + 1 == photos.count {
            imagesListService.fetchPhotosNextPage()
        }
    }
    
    func likePhoto(by index: Int) {
        let photo = photos[index]
        
        imagesListService.changeLike(photoId: photo.id, isLike: photo.isLiked) { [weak self] result in
            switch result {
            case .success:
                DispatchQueue.main.async {
                    self?.photos = self?.imagesListService.photos ?? []
                    self?.view?.successLike(index: index)
                }
                break
            case .failure:
                DispatchQueue.main.async {
                    self?.view?.showLikeError()
                }
                break
            }
        }
    }
}

public protocol ImagesListViewPresenterProtocol {
    var view: ImagesListViewControllerProtocol? { get set }
    var photosCount: Int { get }
    
    func viewDidLoad()
    func willShowPhoto(of index: Int)
    func likePhoto(by index: Int)
    func getPhoto(by index: Int) -> Photo?
}
