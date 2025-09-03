//
//  SingleImageViewController.swift
//  ImageFeed
//
//  Created by   Дмитрий Кривенко on 21.03.2025.
//
import UIKit

final class SingleImageViewController: UIViewController {
    
    // MARK: - public properties
    
    var imageURL: URL?
    
    // MARK: - outlets
    
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet var imageView: UIImageView!
    
    // MARK: - overrides methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.minimumZoomScale = 0.1
        scrollView.maximumZoomScale = 1.25
        
        UIBlockingProgressHUD.show()
        imageView.kf.setImage(with: imageURL, completionHandler: { [weak self] result in
            switch result {
            case .success(let imageResult):
                self?.imageView.image = imageResult.image
                self?.imageView.frame.size = imageResult.image.size
                self?.rescaleAndCenterImageInScrollView(image: imageResult.image)
                break
            case .failure(let error):
                print("[ImagesListViewController.configureCell]: 🚫 Set image error — \(error.localizedDescription)")
                break
            }
            UIBlockingProgressHUD.dismiss()
        })
    }
    
    // MARK: - actions
    
    @IBAction private func didTapBackButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction private func didTapShareButton(_ sender: Any) {
        guard let image = self.imageView.image else { return }
        let activityViewController = UIActivityViewController.init(activityItems: [image], applicationActivities: nil);
        present(activityViewController, animated: true)
    }
    
    // MARK: - private methods
    
    private func rescaleAndCenterImageInScrollView(image: UIImage) {
        let minZoomScale = scrollView.minimumZoomScale
        let maxZoomScale = scrollView.maximumZoomScale
        view.layoutIfNeeded()
        let visibleRectSize = scrollView.bounds.size
        let imageSize = image.size
        let hScale = imageSize.width != 0 ? (visibleRectSize.width / imageSize.width) : 0
        let vScale = imageSize.width != 0 ? (visibleRectSize.height / imageSize.height) : 0
        let scale = min(maxZoomScale, max(minZoomScale, min(hScale, vScale)))
        scrollView.setZoomScale(scale, animated: false)
        scrollView.layoutIfNeeded()
        let newContentSize = scrollView.contentSize
        let x = (newContentSize.width - visibleRectSize.width) / 2
        let y = (newContentSize.height - visibleRectSize.height) / 2
        scrollView.setContentOffset(CGPoint(x: x, y: y), animated: false)
    }
}

extension SingleImageViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
}
