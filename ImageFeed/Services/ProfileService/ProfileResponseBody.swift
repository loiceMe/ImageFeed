//
//  ProfileResponseBody.swift
//  ImageFeed
//
//  Created by   Дмитрий Кривенко on 23.05.2025.
//

struct ProfileResponseBody: Decodable {
    let username: String
    let firstName: String
    let lastName: String
    let bio: String?
    
    private enum CodingKeys: String, CodingKey {
        case username = "username"
        case firstName = "first_name"
        case lastName = "last_name"
        case bio = "bio"
    }
}
