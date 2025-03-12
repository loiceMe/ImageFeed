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
    
    // MARK: - @IBOutlet properties
    
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var tableCellImage: UIImageView!
    @IBOutlet weak var dateLabelContainer: UIView!
    @IBOutlet weak var dateLabel: UILabel!
    
    // MARK: - @IBOutlet properties
    
    override func layoutSubviews() {
        super.layoutSubviews()

        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 4, left: 0, bottom: 4, right: 0))
    }
}
