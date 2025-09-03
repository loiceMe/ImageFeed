//
//  ImageListViewController.swift
//  ImageFeed
//
//  Created by   Дмитрий Кривенко on 27.02.2025.
//

import UIKit
import Kingfisher

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
    
    private let showSingleImageSegueIdentifier = "ShowSingleImage"
    
    private let imagesListService = ImagesListService.shared
    
    private var imagesListServiceObserver: NSObjectProtocol?
    
    private var photos: [Photo] = []
    
    // MARK: - View controller lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
        tableView.showsVerticalScrollIndicator = false
        
        imagesListServiceObserver = NotificationCenter.default
            .addObserver(
                forName: ImagesListService.didChangeNotification,
                object: nil,
                queue: .main
            ) { [weak self] _ in
                self?.updateTableViewAnimated()
            }
        
        imagesListService.fetchPhotosNextPage()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showSingleImageSegueIdentifier {
            guard
                let viewController = segue.destination as? SingleImageViewController,
                let indexPath = sender as? IndexPath
            else {
                assertionFailure("Invalid segue destination")
                return
            }
            if let imageUrl = URL(string: photos[indexPath.row].largeImageURL) {
                viewController.imageURL = imageUrl
            }
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
    
    // MARK: - Table cell configure method
    
    private func configureCell(for cell: ImagesListCell, with indexPath: IndexPath) {
        cell.contentView.layer.cornerRadius = 16
        if let imageUrl = URL(string: photos[indexPath.row].thumbImageURL) {
            cell.tableCellImageView?.kf.setImage(with: imageUrl, completionHandler: { [weak cell] result in
                switch result {
                case .success(let imageResult):
                    cell?.tableCellImageView?.image = imageResult.image
                    break
                case .failure(let error):
                    print("[ImagesListViewController.configureCell]: 🚫 Set image error — \(error.localizedDescription)")
                    break
                }
            })
        }
        cell.dateLabel?.text = dateFormatter.string(from: .init())
        let likeImage = photos[indexPath.row].isLiked ? "FavoriteActive" : "FavoriteInactive"
        cell.likeButton.setImage( UIImage(named: likeImage), for: .normal)
        cell.selectionStyle = .none;
    }
    
    func updateTableViewAnimated() {
        let oldCount = photos.count
        let newCount = imagesListService.photos.count
        photos = imagesListService.photos
        if oldCount != newCount {
            tableView.performBatchUpdates {
                let indexPaths = (oldCount..<newCount).map { i in
                    IndexPath(row: i, section: 0)
                }
                tableView.insertRows(at: indexPaths, with: .automatic)
            } completion: { _ in }
        }
    }
}

extension ImagesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let imagesListCell = tableView.dequeueReusableCell(
            withIdentifier: ImagesListCell.reuseIdentifier,
            for: indexPath
        ) as? ImagesListCell else {
            return UITableViewCell()
        }
        imagesListCell.delegate = self
        configureCell(for: imagesListCell, with: indexPath)
        
        return imagesListCell
    }
}

extension ImagesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let imageHeight = photos[indexPath.row].size.height
        let imageWidth = photos[indexPath.row].size.width
        
        return (imageHeight - 8) * (tableView.contentSize.width / imageWidth)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: showSingleImageSegueIdentifier, sender: indexPath)
    }
    
    func tableView(
      _ tableView: UITableView,
      willDisplay cell: UITableViewCell,
      forRowAt indexPath: IndexPath
    ) {
        if indexPath.row + 1 == photos.count {
            imagesListService.fetchPhotosNextPage()
        }
    }
}

protocol ImagesListCellDelegate: AnyObject {
    func imageListCellDidTapLike(_ cell: ImagesListCell)
}

extension ImagesListViewController: ImagesListCellDelegate {
    func imageListCellDidTapLike(_ cell: ImagesListCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        let photo = photos[indexPath.row]
        
        UIBlockingProgressHUD.show()
        imagesListService.changeLike(photoId: photo.id, isLike: photo.isLiked) { [weak cell, weak self] result in
            switch result {
            case .success:
                self?.photos = self?.imagesListService.photos ?? []
                cell?.setIsLiked(((self?.photos[indexPath.row].isLiked) ?? false))
                UIBlockingProgressHUD.dismiss()
                break
            case .failure:
                UIBlockingProgressHUD.dismiss()
                let alert = UIAlertController()
                alert.message = "Произошла ошибка лайка"
                self?.present(alert, animated: true)
                break
            }
        }
    }
}
