//
//  InviteController.swift
//  TFTI
//
//  Created by Zebadiah Watson on 11/6/19.
//  Copyright © 2019 Zebadiah Watson. All rights reserved.
//

import UIKit
import CloudKit

class InviteController {
    
    //MARK: - shared instance
    static let shared = InviteController()
    
    //MARK: - source of truth
    var currentInvite: [Invite] = []
    
    //MARK: - properties
    let publicDB = CKContainer.default().publicCloudDatabase
    
    //MARK: - CRUD
    func createInviteWith(title: String?, venue: String, Date: Date = Date(), location: CLLocation, completion: @escaping (_ success: Bool) -> Void) {
        guard let userID = UserController.shared.currentUser?.ckRecordID else { return }
        let reference = CKRecord.Reference(recordID: userID, action: .deleteSelf)
        let newInvite = Invite(title: title, venue: venue, userReference: reference, location: location)
        let inviteRecord = CKRecord(invite: newInvite)
        publicDB.save(inviteRecord) { (record, error) in
            if let error = error {
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                completion(false)
                return
            }
            guard let record = record,
                let savedInvite = Invite(ckRecord: record)
                else { completion(false); return }
            
            self.currentInvite.append(savedInvite)
        }
    }
    
    // THE PREDICATE HERE MIGHT BE AN ISSUE LATER
    func fetchInvite(completion: @escaping (_ success: Bool) -> Void) {
        guard let currentUser = UserController.shared.currentUser else { completion(false); return }
        let predicate = NSPredicate(format: "\(InviteStrings.recordTypeKey) ALL %@", currentUser.friendReferences)
        let query = CKQuery(recordType: InviteStrings.recordTypeKey, predicate: predicate)
        publicDB.perform(query, inZoneWith: nil) { (foundRecords, error) in
            if let error = error {
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                completion(false)
                return
            }
            guard let records = foundRecords else {
                completion(false); return }
            
            let invites = records.compactMap( { Invite(ckRecord: $0) } )
            
            self.currentInvite = invites
            print("fetched invites successfully")
            completion(true)
        }
    }
    
    func updateInvite(_ invite: Invite, completion: @escaping (_ success: Bool) -> Void) {
        let recordToUpdate = CKRecord(invite: invite)
        let operation = CKModifyRecordsOperation(recordsToSave: [recordToUpdate], recordIDsToDelete: nil)
        operation.savePolicy = .changedKeys
        operation.qualityOfService = .userInteractive
        operation.modifyRecordsCompletionBlock = { records, _, error in
            if let error = error {
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                completion(false)
                return
            }
            
            guard recordToUpdate == records?.first else {
                print("unexpected record was updated")
                completion(false)
                return
            }
            
            print("updated \(recordToUpdate.recordID) successfully")
            completion(true)
        }
        publicDB.add(operation)
    }
    
    func deleteInvite(_ invite: Invite, completion: @escaping (Bool) -> Void) {
        let operation = CKModifyRecordsOperation(recordsToSave: nil, recordIDsToDelete: [invite.ckRecordID])
        operation.qualityOfService = .userInitiated
        operation.modifyRecordsCompletionBlock = { _, recordIDs, error in
            if let error = error {
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                completion(false)
                return
            }
            
            guard invite.ckRecordID == recordIDs?.first else {
                completion(false); return }
            print("sucessfully deleted Invite")
            completion(true)
        }
        publicDB.add(operation)
    }
    
    func subscribeForNotifications(completion: @escaping (_ _error: Error?) -> Void) {
        let predicate = NSPredicate(value: true)
        let subscription = CKQuerySubscription(recordType: InviteStrings.recordTypeKey, predicate: predicate, options: .firesOnRecordCreation)
        let notificationInfo = CKSubscription.NotificationInfo()
        notificationInfo.title = "You're Invited"
        notificationInfo.alertBody = "the invite DID NOT get lost in the mail"
        notificationInfo.shouldBadge = true
        notificationInfo.soundName = "default"
        
        subscription.notificationInfo = notificationInfo
        publicDB.save(subscription) { (_, error) in
            if let error = error {
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                completion(error)
            }
            completion(nil)
        }
    }
} // End of Class
