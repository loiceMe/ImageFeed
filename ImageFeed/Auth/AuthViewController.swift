//
//  AuthViewController.swift
//  ImageFeed
//
//  Created by   Дмитрий Кривенко on 16.04.2025.
//
import UIKit

final class AuthViewController: UIViewController {
    // MARK: - public properties
    
    weak var delegate: AuthViewControllerDelegate?
    
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
        UIBlockingProgressHUD.show()
        OAuth2Service.shared.fetchOAuthToken(code: code) { [weak self] result in
            guard let self = self else { return }
            
            UIBlockingProgressHUD.dismiss()
            switch result {
            case .success(let data):
                self.tokenStorage.token = data.accessToken
                self.delegate?.didAuthenticate(self)
                break
            case .failure(let error):
                print("[webViewViewController]: \(error)")
                let alert = UIAlertController(title: "Что-то пошло не так",
                                              message: "Не удалось войти в систему",
                                              preferredStyle: .alert)
                let alertAction = UIAlertAction(title: "Ok", style: .default)
                alert.addAction(alertAction)
                present(alert, animated: true)
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
