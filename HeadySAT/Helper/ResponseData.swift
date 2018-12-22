//
//  ResponseData.swift
//  HeadySAT
//
//  Created by Satish Mavani on 19/12/18.
//  Copyright © 2018 satishmavani. All rights reserved.
//

import Foundation

struct ResponseData: Codable {
    let categories: [Category]
    let rankings: [Ranking]
}

struct Category: Codable {
    let id: Int
    let name: String
    let products: [CategoryProduct]
    let childCategories: [Int]
    
    enum CodingKeys: String, CodingKey {
        case id, name, products
        case childCategories = "child_categories"
    }
}

struct CategoryProduct: Codable {
    let id: Int
    let name, dateAdded: String
    let variants: [Variant]
    let tax: Tax
    
    enum CodingKeys: String, CodingKey {
        case id, name
        case dateAdded = "date_added"
        case variants, tax
    }
}

struct Tax: Codable {
    let name: String
    let value: Double
}

enum Name: String, Codable {
    case vat = "VAT"
    case vat4 = "VAT4"
}

struct Variant: Codable {
    let id: Int
    let color: String
    let size: Int?
    let price: Int
}

struct Ranking: Codable {
    let ranking: String
    let products: [RankingProduct]
}

struct RankingProduct: Codable {
    let id: Int
    let viewCount, orderCount, shares: Int?
    
    enum CodingKeys: String, CodingKey {
        case id
        case viewCount = "view_count"
        case orderCount = "order_count"
        case shares
    }
}
