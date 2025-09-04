//
//  ImagesListViewPresenterSpy.swift
//  ImageFeed
//
//  Created by   Дмитрий Кривенко on 03.09.2025.
//

import ImageFeed
import Foundation

final class ImagesListViewPresenterSpy: ImagesListViewPresenterProtocol {
    var viewDidLoadCalled: Bool = false
    var view: ImagesListViewControllerProtocol?
    
    var photosCount: Int = 0
    
    func willShowPhoto(of index: Int) {
        
    }
    
    func likePhoto(by index: Int) {
        
    }
    
    func fetchPhotos() {
        
    }
    
    func getPhoto(by index: Int) -> ImageFeed.Photo? {
        return nil
    }
    
    func viewDidLoad() {
        viewDidLoadCalled = true
    }
    
    func didUpdateProgressValue(_ newValue: Double) {
    
    }
    
    func code(from url: URL) -> String? {
        return nil
    }
}

final class ImagesListServiceStub: ImagesListServiceProtocol {
    var photos: [ImageFeed.Photo] = [Photo(
        id: "",
        size: CGSize(),
        createdAt: nil,
        welcomeDescription: nil,
        thumbImageURL: "",
        largeImageURL: "",
        isLiked: false
    )]
    var calledFetchNextPage = false
    
    func changeLike(photoId: String, isLike: Bool, _ completion: @escaping (Result<Void, any Error>) -> Void) {
        
    }
    
    func fetchPhotosNextPage() {
        calledFetchNextPage = true
    }
}
