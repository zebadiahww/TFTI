//
//  InviteAnnotation.swift
//  TFTI
//
//  Created by Zebadiah Watson on 11/14/19.
//  Copyright © 2019 Zebadiah Watson. All rights reserved.
//

import UIKit
import MapKit
import Contacts

class InviteAnnotation: NSObject, MKAnnotation {
    
    var invite: Invite
    
    var venue: String? {
        return invite.venue
    }
    var duration: Date {
        return invite.duration
        
    }
    
    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: invite.location.coordinate.latitude, longitude: invite.location.coordinate.longitude)
    }
    
    var placemark: MKPlacemark {
        return MKPlacemark(coordinate: self.coordinate)
    }
    
    init(invite: Invite) {
        self.invite = invite
    }
    
    func mapItem() -> MKMapItem {
        let addressDict = [CNPostalAddressStreetKey: venue!]
        let placemark = MKPlacemark(coordinate: coordinate, addressDictionary: addressDict)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = venue
        return mapItem
    }
}
