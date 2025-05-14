//
//  AuthViewController.swift
//  ImageFeed
//
//  Created by   Дмитрий Кривенко on 16.04.2025.
//
import UIKit

final class AuthViewController: UIViewController {
    // MARK: - public properties
    
    var delegate: AuthViewControllerDelegate?
    
    // MARK: - private properties
    
    private let tokenStorage = OAuth2TokenStorage()
    
    // MARK: - override methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureBackButton()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? WebViewViewController {
            vc.delegate = self
        }
    }
    
    // MARK: - private methods
    
    private func configureBackButton() {
        navigationController?.navigationBar.backIndicatorImage = UIImage(named: "BackwardBlack")
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(named: "BackwardBlack")
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem?.tintColor = UIColor(named: "YPBlack")
    }
}

extension AuthViewController: WebViewViewControllerDelegate {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String) {
        OAuth2Service.shared.fetchOAuthToken(code: code) { result in
            switch result {
            case .success(let data):
                do {
                    let oAuth2TokenResponse = try JSONDecoder().decode(OAuth2TokenResponseBody.self, from: data)
                    
                    self.tokenStorage.token = oAuth2TokenResponse.accessToken
                    self.delegate?.didAuthenticate(self)
                } catch let error {
                    print(error)
                }
                break
            case .failure(let error):
                print(error)
                break
            }
        }
    }
    
    func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
        vc.dismiss(animated: true)
    }
}

protocol AuthViewControllerDelegate: AnyObject {
    func didAuthenticate(_ vc: AuthViewController)
}
