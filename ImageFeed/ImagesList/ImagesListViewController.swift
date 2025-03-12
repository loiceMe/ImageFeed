//
//  ImageListViewController.swift
//  ImageFeed
//
//  Created by   Дмитрий Кривенко on 27.02.2025.
//

import UIKit

final class ImagesListViewController: UIViewController {
    
    // MARK: - @IBOutlet properties
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - private properties
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()
    private let photosName: [String] = Array(0..<20).map{ "\($0)" }
    private let gradientColors = [
        UIColor(red: 0.102, green: 0.105, blue: 0.133, alpha: 0.0).cgColor,
        UIColor(red: 0.102, green: 0.105, blue: 0.133, alpha: 0.5).cgColor
    ]
    
    // MARK: - View controller lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
        tableView.showsVerticalScrollIndicator = false
    }
    
    // MARK: - Table cell configure method
    
    private func configureCell(for cell: ImagesListCell, with indexPath: IndexPath) {
        cell.contentView.layer.cornerRadius = 16
        cell.tableCellImage.image = UIImage(named: photosName[indexPath.row])
        cell.dateLabel?.text = dateFormatter.string(from: .init())
        cell.favoriteButton.imageView?.image = UIImage(named: indexPath.row % 2 == 0 ? "FavoriteActive" : "FavoriteInactive")
        if cell.dateLabelContainer.layer.sublayers?.count ?? 0 < 2 {
            let gradient = CAGradientLayer()
            gradient.frame = cell.dateLabelContainer.bounds
            gradient.colors = gradientColors
            cell.dateLabelContainer.layer.insertSublayer(gradient, at: 0)
        }
        cell.selectionStyle = .none;
    }
}

extension ImagesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photosName.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let imagesListCell = tableView.dequeueReusableCell(
            withIdentifier: ImagesListCell.reuseIdentifier,
            for: indexPath
        ) as? ImagesListCell else {
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
