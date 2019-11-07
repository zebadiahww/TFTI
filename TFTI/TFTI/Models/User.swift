//
//  User.swift
//  TFTI
//
//  Created by Zebadiah Watson on 11/4/19.
//  Copyright © 2019 Zebadiah Watson. All rights reserved.
//

import UIKit
import CloudKit

struct UserStrings {
    static let typeKey = "user"
    static let nameKey = "name"
    static let userReferenceKey = "userReference"
    static let photoAssetKey = "photoAsset"
}

class User {
    let name: String
    var friends: [User]
    let ckRecordID: CKRecord.ID
    let userReference: CKRecord.Reference
    var friendReferences: [CKRecord.Reference] = []
    let userLocation: CLLocationManager? = nil
    var profileImage: UIImage? {
        get {
            guard let photoData = self.photoData else { return nil }
            return UIImage(data: photoData)
        } set {
            photoData = newValue?.jpegData(compressionQuality: 0.5)
        }
    }
    
    var photoData: Data?
    
    var photoAsset: CKAsset? {
        let tempDirectory = NSTemporaryDirectory()
        let tempDirectoryURL = URL(fileURLWithPath: tempDirectory)
        let fileURL = tempDirectoryURL.appendingPathComponent(UUID().uuidString).appendingPathExtension("jpg")
        do {
            try photoData?.write(to: fileURL)
        } catch {
            print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
            print("CKAsset not able to be set")
        }
        return CKAsset(fileURL: fileURL)
    }
    
    init(name: String, friends: [User] = [], ckRecordID: CKRecord.ID = CKRecord.ID(recordName: UUID().uuidString), userReference: CKRecord.Reference, profileImage: UIImage? = nil) {
        self.name = name
        self.friends = friends
        self.ckRecordID = ckRecordID
        self.userReference = userReference
        self.profileImage = profileImage
    }
}

extension User {
    convenience init?(ckRecord: CKRecord) {
        guard let name = ckRecord[UserStrings.nameKey] as? String,
            let userReference = ckRecord[UserStrings.userReferenceKey] as? CKRecord.Reference
            else { return nil }
        
        var foundPhoto: UIImage?
        if let photoAsset = ckRecord[UserStrings.photoAssetKey] as? CKAsset {
            do {
                let data = try Data(contentsOf: photoAsset.fileURL!)
                foundPhoto = UIImage(data: data)
            } catch {
                print("Could not get image data")
            }
        }
        self.init(name: name, ckRecordID: ckRecord.recordID, userReference: userReference, profileImage: foundPhoto)
    }
}

extension CKRecord {
    
    convenience init(user: User) {
        self.init(recordType: UserStrings.typeKey, recordID: user.ckRecordID)
        self.setValuesForKeys([
            UserStrings.nameKey : user.name,
            UserStrings.userReferenceKey : user.userReference
        ])
        if let asset = user.photoAsset {
            self.setValue(asset, forKey: UserStrings.photoAssetKey)
        }
    }
}
