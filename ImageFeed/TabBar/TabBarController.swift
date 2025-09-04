//
//  TabBarController.swift
//  ImageFeed
//
//  Created by   Дмитрий Кривенко on 29.05.2025.
//

import UIKit
 
final class TabBarController: UITabBarController {
    override func awakeFromNib() {
        super.awakeFromNib()
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        
        let imagesListViewController = storyboard.instantiateViewController(
            withIdentifier: "ImagesListViewController"
        )
        let imagesListViewPresenter = ImagesListViewPresenter()
        (imagesListViewController as? ImagesListViewControllerProtocol)?.presenter = imagesListViewPresenter
        imagesListViewPresenter.view = (imagesListViewController as? ImagesListViewControllerProtocol)
        
        let profileViewController = ProfileViewController()
        let profileViewPresenter = ProfileViewPresenter()
        profileViewController.presenter = profileViewPresenter
        profileViewPresenter.view = profileViewController
        profileViewController.tabBarItem = UITabBarItem(
            title: "",
            image: UIImage(named: "TabProfileEditorial"),
            selectedImage: nil
        )
        
        self.viewControllers = [imagesListViewController, profileViewController]
    }
}
