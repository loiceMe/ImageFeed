//
//  ProfileTests.swift
//  ImageFeed
//
//  Created by   Дмитрий Кривенко on 03.09.2025.
//

import XCTest
@testable import ImageFeed

final class ProfileTests: XCTestCase {
    func testViewControllerCallsViewDidLoad() {
        // Given
        let viewController = ProfileViewController()
        let presenter = ProfileViewPresenterSpy()
        viewController.presenter = presenter
        presenter.view = viewController

        // When
        _ = viewController.view

        // Then
        XCTAssertTrue(presenter.viewDidLoadCalled)
    }

    func testPresenterHandlesAvatarUpdateNotification() {
        // Given
        let presenter = ProfileViewPresenter(profileImageService: ProfileImageServiceStub())
        let view = ProfileViewControllerSpy()
        presenter.view = view
        presenter.viewDidLoad()

        // When

        NotificationCenter.default.post(
            name: ProfileImageService.didChangeNotification,
            object: nil,
            userInfo: ["URL": ""]
        )

        // Then
        XCTAssertEqual(view.avatarUpdatedCount, 2)
    }
}
