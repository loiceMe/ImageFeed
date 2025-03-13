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

    // MARK: - Private properties
    
    private let gradientColors = [
        UIColor(red: 0.102, green: 0.105, blue: 0.133, alpha: 0.0).cgColor,
        UIColor(red: 0.102, green: 0.105, blue: 0.133, alpha: 0.5).cgColor
    ]
    
    private let gradient = CAGradientLayer()
    
    // MARK: - @IBOutlet properties
    
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var tableCellImage: UIImageView!
    @IBOutlet weak var dateLabelContainer: UIView!
    @IBOutlet weak var dateLabel: UILabel!
    
    // MARK: - Override methods
    
    override func layoutSubviews() {
        super.layoutSubviews()

        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 4, left: 0, bottom: 4, right: 0))
        gradient.frame = dateLabelContainer.bounds
        gradient.colors = gradientColors
        dateLabelContainer.layer.insertSublayer(gradient, at: 0)
    }
    
    override func prepareForReuse() {
        dateLabelContainer.layer.sublayers?.removeAll(where: { layer in
            gradient == layer
        })
    }
}
