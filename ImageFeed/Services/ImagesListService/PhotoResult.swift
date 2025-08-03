//
//  PhotoResult.swift
//  ImageFeed
//
//  Created by   Дмитрий Кривенко on 14.07.2025.
//

struct PhotoResult: Decodable {
    let id: String
    let createdAt: String
    let width: Int
    let height: Int
    let likes: Int
    let likedByUser: Bool
    let description: String
    
    private enum CodingKeys: String, CodingKey {
        case id = "id"
        case createdAt = "created_at"
        case width = "width"
        case height = "height"
        case likes = "likes"
        case likedByUser = "liked_by_user"
        case description = "description"
    }
}
