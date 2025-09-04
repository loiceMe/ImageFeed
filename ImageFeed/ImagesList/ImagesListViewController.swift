//
//  ImageListViewController.swift
//  ImageFeed
//
//  Created by   Дмитрий Кривенко on 27.02.2025.
//

import UIKit
import Kingfisher

final class ImagesListViewController: UIViewController & ImagesListViewControllerProtocol {
    
    // MARK: - @IBOutlet properties
    
    @IBOutlet weak var tableView: UITableView?
    
    // MARK: - private properties
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()
    
    private let showSingleImageSegueIdentifier = "ShowSingleImage"
    
    var presenter: ImagesListViewPresenterProtocol?
    
    // MARK: - View controller lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView?.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
        tableView?.showsVerticalScrollIndicator = false
        
        presenter?.viewDidLoad()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showSingleImageSegueIdentifier {
            guard
                let viewController = segue.destination as? SingleImageViewController,
                let indexPath = sender as? IndexPath,
                let photo = presenter?.getPhoto(by: indexPath.row),
                let imageUrl = URL(string: photo.largeImageURL)
            else {
                assertionFailure("Invalid segue destination")
                return
            }
            viewController.imageURL = imageUrl
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }

    func showLikeError() {
        UIBlockingProgressHUD.dismiss()
        let alert = UIAlertController()
        alert.message = "Произошла ошибка лайка"
        self.present(alert, animated: true)
    }
    
    func successLike(index: Int) {
        UIBlockingProgressHUD.dismiss()
        tableView?.reloadRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
    }
    
    func updateTableViewAnimated(oldCount: Int, newCount: Int) {
        if oldCount != newCount {
            tableView?.performBatchUpdates {
                let indexPaths = (oldCount..<newCount).map { i in
                    IndexPath(row: i, section: 0)
                }
                tableView?.insertRows(at: indexPaths, with: .automatic)
            } completion: { _ in }
        }
    }
}

extension ImagesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter?.photosCount ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let imagesListCell = tableView.dequeueReusableCell(
            withIdentifier: ImagesListCell.reuseIdentifier,
            for: indexPath
        ) as? ImagesListCell,
              let photo = presenter?.getPhoto(by: indexPath.row)
        else {
            return UITableViewCell()
        }
        imagesListCell.delegate = self
        imagesListCell.configure(with: URL(string: photo.thumbImageURL),
                       liked: photo.isLiked,
                       dateText: dateFormatter.string(from: .init()))
        
        return imagesListCell
    }
}

extension ImagesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if let photo = presenter?.getPhoto(by: indexPath.row) {
            let imageHeight = photo.size.height
            let imageWidth = photo.size.width
            
            return (imageHeight - 8) * (tableView.contentSize.width / imageWidth)
        }
        
        return 0.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: showSingleImageSegueIdentifier, sender: indexPath)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        presenter?.willShowPhoto(of: indexPath.row)
    }
}

protocol ImagesListCellDelegate: AnyObject {
    func imageListCellDidTapLike(_ cell: ImagesListCell)
}

extension ImagesListViewController: ImagesListCellDelegate {
    func imageListCellDidTapLike(_ cell: ImagesListCell) {
        guard let indexPath = tableView?.indexPath(for: cell) else { return }
        
        UIBlockingProgressHUD.show()
        presenter?.likePhoto(by: indexPath.row)
    }
}

public protocol ImagesListViewControllerProtocol: AnyObject {
    var presenter: ImagesListViewPresenterProtocol? { get set }
    
    func updateTableViewAnimated(oldCount: Int, newCount: Int)
    func showLikeError()
    func successLike(index: Int)
}
