//
//  SplashViewController.swift
//  ImageFeed
//
//  Created by   Дмитрий Кривенко on 12.05.2025.
//

import UIKit

final class SplashViewController: UIViewController {
    // MARK: - private properties
    
    private let storage = OAuth2TokenStorage()
    private let profileService = ProfileService.shared
    private let profileImageService = ProfileImageService.shared
    
    // MARK: - override methods
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let token = storage.token {
            fetchProfile(token)
        } else {
            performSegue(withIdentifier: "showAuthenticationScreenSegueIdentifier", sender: nil)
        }
    }
    
    // MARK: - private methods
    
    private func switchToTabBarController() {
        guard let window = UIApplication.shared.windows.first else {
            assertionFailure("Invalid window configuration")
            return
        }
        
        let tabBarController = UIStoryboard(name: "Main", bundle: .main)
            .instantiateViewController(withIdentifier: "tabBarViewController")
        window.rootViewController = tabBarController
    }
    
    private func fetchProfile(_ token: String) {
        profileService.fetchProfile(authToken: token) { [weak self] result in
            guard let self = self else { return }

            switch result {
            case .success(let responseBody):
                self.profileService.responseToProfile(response: responseBody)
                self.switchToTabBarController()
                guard
                    let username = profileService.profile?.username,
                    let token = storage.token else { return }
                profileImageService.fetchProfileImageURL(authToken: token,
                                                         username: username) { result in
                    
                }

            case .failure(let error):
                print("[fetchProfile]: \(error)")
                let alert = UIAlertController()
                alert.message = "Ошибка получения профиля"
                alert.present(self, animated: true)
                break
            }
        }
    }
}

extension SplashViewController: WebViewViewControllerDelegate {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String) {
        
    }
    
    func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
        vc.dismiss(animated: true)
    }
}

extension SplashViewController: AuthViewControllerDelegate {
    func didAuthenticate(_ vc: AuthViewController) {
        vc.dismiss(animated: true)
        guard let token = storage.token else {
            print("No token")
            return
        }
        fetchProfile(token)
    }
}

extension SplashViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showAuthenticationScreenSegueIdentifier" {
            guard
                let navigationController = segue.destination as? UINavigationController,
                let viewController = navigationController.viewControllers[0] as? AuthViewController
            else {
                assertionFailure("Failed to prepare for \("")")
                return
            }

            viewController.delegate = self
            
        } else {
            super.prepare(for: segue, sender: sender)
           }
    }
}
