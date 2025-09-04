//
//  ImagesListTests.swift
//  ImageFeed
//
//  Created by   Дмитрий Кривенко on 03.09.2025.
//

import XCTest
@testable import ImageFeed

final class ImagesListTests: XCTestCase {
    func testViewControllerCallsViewDidLoad() {
        // Given
        let viewController = ImagesListViewController()
        let presenter = ImagesListViewPresenterSpy()
        viewController.presenter = presenter
        presenter.view = viewController
        
        // When
        _ = viewController.view
        
        // Then
        XCTAssertTrue(presenter.viewDidLoadCalled)
    }
    
    func testPresenterHandlesFetchPhotosNotification() {
        // Given
        let service = ImagesListServiceStub()
        let presenter = ImagesListViewPresenter(imagesListService: service)
        let view = ImagesListViewControllerSpy()
        presenter.view = view
        
        // When
        presenter.viewDidLoad()
        
        // Then
        XCTAssertTrue(service.calledFetchNextPage)
    }
}
