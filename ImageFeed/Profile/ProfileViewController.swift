//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by   Дмитрий Кривенко on 14.03.2025.
//
import UIKit
import Kingfisher

final class ProfileViewController: UIViewController & ProfileViewControllerProtocol {
    // MARK: - private properties
    
    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [headerStackView, nameLabel, accountNameLabel, bioLabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 8
        return stackView
    }()
    private lazy var headerStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [profileImageView, exitButton])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        return stackView
    }()
    private lazy var profileImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "Avatar"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    private lazy var exitButton: UIButton = {
        let buttonImage = UIImage(named: "Exit") ?? UIImage()
        let button = UIButton()
        button.setImage(buttonImage, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .none
        button.addTarget(self, action: #selector(onPressExitButton), for: .touchUpInside)
        button.accessibilityIdentifier = "logout-button"
        return button
    }()
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Екатерина Новикова"
        label.font = UIFont.systemFont(ofSize: 23, weight: .bold)
        label.textColor = .ypWhite
        return label
    }()
    private lazy var accountNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "@ekaterina_nov"
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.textColor = .ypGray
        return label
    }()
    private lazy var bioLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Hello, world!"
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.textColor = .ypWhite
        return label
    }()
    
    var presenter: ProfileViewPresenterProtocol?
    
    // MARK: - override methods

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .ypBlack
        view.addSubview(contentStackView)
        NSLayoutConstraint.activate([
            contentStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            contentStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            contentStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16)
        ])
        
        if let avatarURL = ProfileImageService.shared.avatarURL,
           let url = URL(string: avatarURL) {
        }
        
        presenter?.viewDidLoad()
    }
    
    func updateProfileDetails(profile: Profile?) {
        guard let profile = profile else { return }
        
        accountNameLabel.text = profile.loginName
        nameLabel.text = profile.name
        bioLabel.text = profile.bio
    }
    
    func updateAvatar(avatarURL: String) {
        guard let url = URL(string: avatarURL)
        else { return }
        profileImageView.kf.setImage(with: url, placeholder: UIImage(named: "NoAvatar"))
    }
    
    @objc func onPressExitButton() {
        let alertController = UIAlertController(title: "Уходите?",
                                                message: "Уверены, что хотите выйти",
                                                preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Нет", style: .default, handler: nil)
        let logoutAction = UIAlertAction(title: "Да", style: .default) {_ in
            
            self.presenter?.logout()
            
            if let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) {
                let splashViewController = UIStoryboard(name: "Main", bundle: .main)
                    .instantiateViewController(withIdentifier: "SplashViewController")
                window.rootViewController = splashViewController
            }
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(logoutAction)
        alertController.preferredAction = cancelAction
        
        present(alertController, animated: true, completion: nil)
    }
}

public protocol ProfileViewControllerProtocol: AnyObject {
    var presenter: ProfileViewPresenterProtocol? { get set }
    
    func updateAvatar(avatarURL: String)
    func updateProfileDetails(profile: Profile?)
}
