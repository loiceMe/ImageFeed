//
//  ImageListViewController.swift
//  ImageFeed
//
//  Created by   Дмитрий Кривенко on 27.02.2025.
//

import UIKit

final class ImagesListViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()
    private let photosName: [String] = Array(0..<20).map{ "\($0)" }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
        tableView.showsVerticalScrollIndicator = false
    }
    
    private func configureCell(for cell: ImagesListCell, with indexPath: IndexPath) {
        cell.contentView.layer.cornerRadius = 16
        let gradient = CAGradientLayer()
        gradient.frame = cell.dateLabelContainer.bounds
        gradient.colors = [
            UIColor(red: 0.102, green: 0.105, blue: 0.133, alpha: 0.0).cgColor,
            UIColor(red: 0.102, green: 0.105, blue: 0.133, alpha: 0.5).cgColor
        ]
        cell.dateLabelContainer.layer.insertSublayer(gradient, at: 0)
        cell.tableCellImage.image = UIImage(named: photosName[indexPath.row])
        cell.dateLabel.text = dateFormatter.string(from: .now)
        cell.favoriteButton.imageView?.image = UIImage(named: indexPath.row % 2 != 0 ? "FavoriteActive" : "FavoriteInactive")
        cell.selectionStyle = .none;
    }
}

extension ImagesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photosName.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath)
        guard let imagesListCell = cell as? ImagesListCell else {
            return UITableViewCell()
        }
        configureCell(for: imagesListCell, with: indexPath)
        
        return imagesListCell
    }
    
    
}

extension ImagesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let image = UIImage(named: photosName[indexPath.row]), image.size.width > 0 else {
            return 0
        }
        
        return (image.size.height - 8) * (tableView.contentSize.width / image.size.width)
    }
}
