//
//  ImagesListCell.swift
//  ImageFeed
//
//  Created by   Дмитрий Кривенко on 10.03.2025.
//

import UIKit


final class ImagesListCell: UITableViewCell {
    
    // MARK: - Static properties
    
    public static let reuseIdentifier: String = "ImagesListCell"
    
    // MARK: - Public properties
    
    weak var delegate: ImagesListCellDelegate?

    // MARK: - Private properties
    
    private let gradientColors = [
        UIColor(red: 0.102, green: 0.105, blue: 0.133, alpha: 0.0).cgColor,
        UIColor(red: 0.102, green: 0.105, blue: 0.133, alpha: 0.5).cgColor
    ]
    
    private let gradient = CAGradientLayer()
    
    private var isLiked: Bool = false {
        didSet {
            updateLikeButton()
        }
    }
    
    // MARK: - @IBOutlet properties
    
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var tableCellImageView: UIImageView!
    @IBOutlet weak var dateLabelContainer: UIView!
    @IBOutlet weak var dateLabel: UILabel!
    
    // MARK: - @IBAction properties
    
    @IBAction private func likeButtonClicked() {
        delegate?.imageListCellDidTapLike(self)
    }
    
    // MARK: - Override methods
    
    override func layoutSubviews() {
        super.layoutSubviews()

        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 4, left: 0, bottom: 4, right: 0))
        gradient.frame = dateLabelContainer.bounds
        gradient.colors = gradientColors
        dateLabelContainer.layer.insertSublayer(gradient, at: 0)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        tableCellImageView.kf.cancelDownloadTask()
        tableCellImageView.image = nil
        dateLabel.text = ""
        dateLabelContainer.layer.sublayers?.removeAll(where: { layer in
            gradient == layer
        })
        
        likeButton.imageView?.image = UIImage(named: "FavoriteInactive")
    }
    
    func setIsLiked(_ liked: Bool) {
        isLiked = liked
    }
    
    private func updateLikeButton() {
        let imageName = isLiked ? "FavoriteActive" : "FavoriteInactive"
        likeButton.setImage(UIImage(named: imageName), for: .normal)
    }
}
