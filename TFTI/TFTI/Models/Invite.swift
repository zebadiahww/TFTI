//
//  Invite.swift
//  TFTI
//
//  Created by Zebadiah Watson on 11/4/19.
//  Copyright © 2019 Zebadiah Watson. All rights reserved.
//

import UIKit
import CloudKit
import MapKit

struct InviteStrings {
    static let recordTypeKey = "Invite"
    fileprivate static let titleKey = "title"
    fileprivate static let venueKey = "venue"
    fileprivate static let userReferenceKey = "userReference"
    fileprivate static let locationKey = "location"
}

class Invite {
    let title: String?
    let venue: String
    let duration: Date 
    let ckRecordID: CKRecord.ID
    let userReference: CKRecord.Reference
    let location: CLLocation
    
    init(title: String? = nil, venue: String, duration: Date = Date(), recordID: CKRecord.ID = CKRecord.ID(recordName: UUID().uuidString), userReference: CKRecord.Reference, location: CLLocation){
        self.title = title
        self.venue = venue
        self.duration = duration
        self.ckRecordID = recordID
        self.userReference = userReference
        self.location = location
    }
}

extension Invite: Equatable {
    static func == (lhs: Invite, rhs: Invite) -> Bool {
        return lhs.ckRecordID == rhs.ckRecordID
    }
}

extension Invite {
    convenience init?(ckRecord: CKRecord) {
        guard let title = ckRecord[InviteStrings.titleKey] as? String,
            let venue = ckRecord[InviteStrings.venueKey] as? String,
            let location = ckRecord[InviteStrings.locationKey] as? CLLocation,
            let userReference = ckRecord[InviteStrings.userReferenceKey] as? CKRecord.Reference
            else { return nil }
        
        self.init(title: title, venue: venue, recordID: ckRecord.recordID, userReference: userReference, location: location)
    }
}

extension CKRecord {
    
    convenience init(invite: Invite) {
        self.init(recordType: InviteStrings.recordTypeKey, recordID: invite.ckRecordID)
        self.setValuesForKeys([
            InviteStrings.titleKey : invite.title!,
            InviteStrings.venueKey : invite.venue,
            InviteStrings.userReferenceKey : invite.userReference,
            InviteStrings.locationKey : invite.location
        ])
    }
}
