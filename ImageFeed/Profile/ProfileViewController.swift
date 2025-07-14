//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by   Дмитрий Кривенко on 14.03.2025.
//
import UIKit
import Kingfisher

final class ProfileViewController: UIViewController {
    
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
    
    private let profileService = ProfileService.shared
    
    private var profileImageServiceObserver: NSObjectProtocol?
    
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
        
        updateProfileDetails()
        
        profileImageServiceObserver = NotificationCenter.default
            .addObserver(
                forName: ProfileImageService.didChangeNotification,
                object: nil,
                queue: .main
            ) { [weak self] _ in
                guard let self = self else {
                    self?.profileImageView.image = UIImage(named: "NoAvatar")
                    return
                }
                self.updateAvatar()
            }
    }
    
    // MARK: - Private methods
    
    private func updateProfileDetails() {
        guard let profile = profileService.profile else { return }
        
        accountNameLabel.text = profile.loginName
        nameLabel.text = profile.name
        bioLabel.text = profile.bio
        updateAvatar()
    }
    
    private func updateAvatar() {
        guard
            let profileImageURL = ProfileImageService.shared.avatarURL,
            let url = URL(string: profileImageURL)
        else { return }
        profileImageView.kf.setImage(with: url, placeholder: UIImage(named: "NoAvatar"))
    }
}
