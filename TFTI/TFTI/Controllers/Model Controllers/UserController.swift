//
//  UserController.swift
//  TFTI
//
//  Created by Zebadiah Watson on 11/6/19.
//  Copyright © 2019 Zebadiah Watson. All rights reserved.
//

import UIKit
import CloudKit

class UserController {
    //MARK: - shared instance
    static let shared = UserController()
    
    //MARK: - source of truth
    var currentUser: User?
    
    //MARK: - Properties
    let publicDB = CKContainer.default().publicCloudDatabase
    
    
    //MARK: - CRUD functions
    func createUserWith(name: String, profileImage: UIImage?, completion: @escaping(_ success: Bool) -> Void) {
        fetchUserReference { (reference) in
            guard let reference = reference else { completion(false); return }
            let newUser = User(name: name, userReference: reference , profileImage: profileImage)
            let record = CKRecord(user: newUser)
            self.publicDB.save(record) { (record, error) in
                if let error = error {
                    print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                    completion(false)
                    return
                }
                guard let savedRecord = record,
                    let savedUser = User(ckRecord: savedRecord)
                    else { completion(false); return }
                
                self.currentUser = savedUser
                print("user successfully created")
                completion(true)
            }
        }
    }
    
    func fetchUser(completion: @ escaping (_ success: Bool) -> Void) {
        fetchUserReference { (reference) in
            guard let reference = reference else {completion(false); return }
            let predicate = NSPredicate(format: "%K == %@", argumentArray: [UserStrings.userReferenceKey, reference ])
            let query = CKQuery(recordType: UserStrings.typeKey, predicate: predicate)
            self.publicDB.perform(query, inZoneWith: nil) { (records, error) in
                if let error = error {
                    print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                    completion(false)
                    return
                }
                
                guard let record = records?.first,
                    let foundUser = User(ckRecord: record)
                    else { completion(false); return }
                
                self.currentUser = foundUser
                print("fetched User : \(record.recordID.recordName) successfully")
                completion(true)
            }
        }
    }
    
    func fetchUserReference(completion: @escaping (_ reference: CKRecord.Reference?) -> Void) {
        CKContainer.default().fetchUserRecordID { (recordID, error) in
            if let error = error {
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                completion(nil)
                return
            }
            
            guard let recordID = recordID else { completion(nil); return }
            let reference = CKRecord.Reference(recordID: recordID, action: .deleteSelf)
            completion(reference)
        }
    }
    
    func removeUser() {
        
    }
    
    func updateUser() {
        
    }
    
}
