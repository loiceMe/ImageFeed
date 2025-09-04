//
//  ImagesListViewControllerSpy.swift
//  ImageFeed
//
//  Created by   Дмитрий Кривенко on 03.09.2025.
//

import ImageFeed
import Foundation

final class ImagesListViewControllerSpy: ImagesListViewControllerProtocol {
    static let fakePhotoCount = 10
    
    var presenter: (any ImageFeed.ImagesListViewPresenterProtocol)?
    var newPhotosCount = 0
    
    func updateTableViewAnimated(oldCount: Int, newCount: Int) {
        newPhotosCount = ImagesListViewControllerSpy.fakePhotoCount
    }
    
    func showLikeError() {
        
    }
    
    func successLike(index: Int) {
        
    }
}
