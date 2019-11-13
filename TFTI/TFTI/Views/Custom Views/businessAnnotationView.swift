//
//  businessAnnotationView.swift
//  TFTI
//
//  Created by Zebadiah Watson on 11/8/19.
//  Copyright © 2019 Zebadiah Watson. All rights reserved.
//

import UIKit
import MapKit
import Contacts

class BusinessAnnotation: NSObject, MKAnnotation {
    
    var business: Business
    
    var title: String? {
        return business.name
    }
    var subtitle: String? {
        if let rating = business.rating {
            return "Rating \(String(describing: rating)) on Yelp!"
        } else {
            return "N/A"
        }
    }
    
    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: business.coordinates.latitude, longitude: business.coordinates.longitude)
    }
    
    var placemark: MKPlacemark {
        return MKPlacemark(coordinate: self.coordinate)
    }
    
    init(business: Business) {
        self.business = business
    }
    
    func mapItem() -> MKMapItem {
        let addressDict = [CNPostalAddressStreetKey: subtitle!]
        let placemark = MKPlacemark(coordinate: coordinate, addressDictionary: addressDict)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = title
        return mapItem
    }
}
