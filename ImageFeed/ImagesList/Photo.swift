//
//  Photos.swift
//  ImageFeed
//
//  Created by   Дмитрий Кривенко on 14.07.2025.
//
import UIKit

struct Photo {
    let id: String
    let size: CGSize
    let createdAt: Date?
    let welcomeDescription: String?
    let thumbImageURL: String
    let largeImageURL: String
    let isLiked: Bool
}
