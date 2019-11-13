//
//  business.swift
//  TFTI
//
//  Created by Zebadiah Watson on 11/6/19.
//  Copyright © 2019 Zebadiah Watson. All rights reserved.
//

import Foundation
import MapKit
import Contacts

struct TopLevelDictionary: Codable {
    let businesses: [Business]
}

struct Business: Codable {
    
    enum CodingKeys: String, CodingKey {
        case businessID = "id"
        case name
        case imageURL = "image_url"
        case rating
        case reviewCount = "review_count"
        case price
        case categories
        case coordinates 
    }
    
    let businessID: String
    let name: String
    let imageURL: String?
    let rating: Double?
    let reviewCount: Int
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
