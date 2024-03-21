//
//  ProductModel.swift
//  Maccabi-Assignment
//
//  Created by Michael Menashe on 19/03/2024.
//

import Foundation

struct Product: Codable {
    let id: Int 
    let title: String
    let description: String
    let price: Double
    let discountPercentage: Double
    let rating: Double
    let stock: Int
    let brand: String
    let category: String
    let thumbnail: String
    let images: [String]
}

