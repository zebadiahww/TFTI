//
//  business.swift
//  TFTI
//
//  Created by Zebadiah Watson on 11/6/19.
//  Copyright © 2019 Zebadiah Watson. All rights reserved.
//

import Foundation


struct TopLevelDictionary: Codable {
    let businesses: [Businesses]
}

struct Businesses: Codable {
    
    enum CodingKeys: String, CodingKey {
        case businessID = "id"
        case name
        case imageURL = "image_url"
        case rating
        case price
        case categories
        case coordinates 
    }
    
    let businessID: String
    let name: String
    let imageURL: String?
    let rating: Double?
    let price: String?
    let categories: [Categories]
    let coordinates: Coordinates
}

struct Categories: Codable {
    let title: String
}

struct Coordinates: Codable {
    let latitude: Double
    let longitude: Double
}
