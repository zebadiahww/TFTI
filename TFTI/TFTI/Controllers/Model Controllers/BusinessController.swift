//
//  BusinessController.swift
//  TFTI
//
//  Created by Zebadiah Watson on 11/6/19.
//  Copyright © 2019 Zebadiah Watson. All rights reserved.
//

import UIKit
import CloudKit

struct StringConstants {
    fileprivate static let baseURL = "https://api.yelp.com/v3/businesses"
    fileprivate static let search = "search"
    fileprivate static let term = "term"
    fileprivate static let latitude = "latitude"
    fileprivate static let longitude = "longitude"
    fileprivate static let location = "location"
    fileprivate static let apiKey = "Authorization"
    fileprivate static let apiKeyValue = "Bearer hhEhBrHELiG7us-gO9-etdOAJu7Gz8VX1zDPhgwKyXtAGSGVjI4x9FeyFPnccq6zRihr4021OLEF3NYge_4eWp9XrXGQvgq2IT8Lec-8CH2u9c3xBv8S08sozGPAXXYx"
}

class BusinessController {
    
    static var reviewImage: UIImage?
    
    static func fetchBusiness(term: String, location: String?, latitude: Double?, longitude: Double?, completion: @escaping ([Business]) -> Void) {
        
        guard var baseURL = URL(string: StringConstants.baseURL) else { completion ([]); return }
        baseURL.appendPathComponent(StringConstants.search)
        guard var components = URLComponents(url: baseURL, resolvingAgainstBaseURL: true) else {completion([]); return }
        let termQuery = URLQueryItem(name: StringConstants.term, value: term)
        
        components.queryItems = [termQuery]
        
        
        if let location = location {
            let locationQuery = URLQueryItem(name: StringConstants.location, value: location)
            components.queryItems?.append(locationQuery)
        }
        
        if let latitude = latitude, let longitude = longitude {
            let latitudeQuery = URLQueryItem(name: StringConstants.latitude, value: "\(latitude)")
            let longitudeQuery = URLQueryItem(name: StringConstants.longitude, value: "\(longitude)")
            components.queryItems?.append(latitudeQuery)
            components.queryItems?.append(longitudeQuery)
        }
        
        
        guard let finalURL = components.url else { return }
        print(finalURL)
        
        var request = URLRequest(url: finalURL)
        request.addValue(StringConstants.apiKeyValue, forHTTPHeaderField: StringConstants.apiKey)
        
        let dataTask = URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let error = error {
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                completion([])
                return
            }
            guard let data = data else {
                print("unable to retrieve data")
                completion([])
                return
            }
            let jsonDecoder = JSONDecoder()
            do {
                let business = try jsonDecoder.decode(TopLevelDictionary.self, from: data)
                completion(business.businesses)
            } catch {
                print("there was an error decoding the data")
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                completion([])
            }
        }
        dataTask.resume()
    }
    
    static func getImage(item: Business, completion: @escaping (UIImage?) -> Void) {
        guard let posterURL = item.imageURL,
            let url = URL(string: posterURL) else {
                print("business does not have image")
                completion(nil)
                return
        }
        URLSession.shared.dataTask(with: url) { (data, _, error) in
            if let error = error {
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                completion(nil)
                return
            }
            guard let data = data else {
                print("could not get image data")
                completion(nil)
                return
            }
            let image = UIImage(data: data)
            completion(image)
        } .resume()
    }
    
    static func convertYelpRating(rating: Double) {
        if rating == 0 {
            reviewImage = UIImage(named: "small_0")
        } else if rating == 1 {
            reviewImage = UIImage(named: "small_1")
        } else if rating == 1.5 {
            reviewImage = UIImage(named: "small_1_half")
        } else if rating == 2 {
            reviewImage = UIImage(named: "small_2")
        } else if rating == 2.5 {
            reviewImage = UIImage(named: "small_2_half")
        } else if rating == 3 {
            reviewImage = UIImage(named: "small_3")
        } else if rating == 3.5 {
            reviewImage = UIImage(named: "small_3_half")
        } else if rating == 4 {
            reviewImage = UIImage(named: "small_4")
        } else if rating == 4.5 {
            reviewImage = UIImage(named: "small_4_half")
        } else if rating == 5 {
            reviewImage = UIImage(named: "small_5")
        }
    }
} // End Of Class
