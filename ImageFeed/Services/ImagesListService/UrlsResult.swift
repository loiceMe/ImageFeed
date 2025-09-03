//
//  UrlsResult.swift
//  ImageFeed
//
//  Created by   Дмитрий Кривенко on 14.07.2025.
//

struct UrlsResult: Decodable {
    let raw: String
    let full: String
    let regular: String
    let small: String
    let thumb: String
}
