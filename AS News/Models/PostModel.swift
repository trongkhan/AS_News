//
//  PostModel.swift
//  AS News
//
//  Created by Trọng Khang Hồ on 20/4/25.
//

import Foundation

struct Post: Identifiable, Decodable {
    let id: String  // Using objectID as id
    let title: String?
    let url: String?
    let points: Int?
    let author: String?
    let createdAt: TimeInterval?
    
    enum CodingKeys: String, CodingKey {
        case id = "objectID"  // Hacker News uses objectID as the identifier
        case title, url, points, author
        case createdAt = "created_at_i"  // This is a timestamp
    }
}

struct HNResponse: Decodable {
    let hits: [Post]
}
