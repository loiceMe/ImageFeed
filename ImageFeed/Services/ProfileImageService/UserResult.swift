//
//  UserResult.swift
//  ImageFeed
//
//  Created by   Дмитрий Кривенко on 24.05.2025.
//

struct UserResult: Decodable {
    let profileImage: ProfileImage
    
    private enum CodingKeys: String, CodingKey {
        case profileImage = "profile_image"
    }
}

struct ProfileImage: Decodable {
    let small: String
}
