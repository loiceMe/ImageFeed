//
//  ImageFeedTests.swift
//  ImageFeedTests
//
//  Created by   Дмитрий Кривенко on 27.02.2025.
//

import XCTest
@testable import ImageFeed

final class ImageFeedTests: XCTestCase {
    func testExample() throws {
        let service = ImagesListService()
        
        let expectation = self.expectation(description: "Wait for Notification")
        NotificationCenter.default.addObserver(
            forName: ImagesListService.didChangeNotification,
            object: nil,
            queue: .main) { _ in
                expectation.fulfill()
            }
        
        service.fetchPhotosNextPage(completion: {result in } )
        wait(for: [expectation], timeout: 100)
        
        XCTAssertEqual(service.photos.count, 10)
    }
}
