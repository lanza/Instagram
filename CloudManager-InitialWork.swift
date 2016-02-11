import UIKit
import CloudKit

extension CloudManager {
    
    func getCurrentUser(completionHandler: ((User?,ErrorType?) -> ())? ) {
        container.fetchUserRecordIDWithCompletionHandler { (userRecordID, errorOne) -> Void in
            if let errorOne = errorOne {
                completionHandler?(nil,errorOne)
                return
            }
            guard let userRecordID = userRecordID else { return }
            self.publicDatabase.fetchRecordWithID(userRecordID, completionHandler: { (userRecord, errorTwo) -> Void in
                if let errorTwo = errorTwo {
                    completionHandler?(nil,errorTwo)
                    return
                }
                guard let userRecord = userRecord else { return }
                let user = User(fromRecord: userRecord)
                self.currentUser = user
                completionHandler?(user,nil)
            })
        }
    }
    func checkIfInAllUsers() {
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: "AllUsers", predicate: predicate)
        publicDatabase.performQuery(query, inZoneWithID: nil) { (records, error) -> Void in
            if let error = error {
                print(error)
            }
            guard let allUsersRecord = records?[0] else { return }
            guard var allUsersReferences = allUsersRecord.objectForKey("AllUsers") as? [CKReference] else { return }
            var recordIDs = [CKRecordID]()
            for userReference in allUsersReferences {
                recordIDs.append(userReference.recordID)
            }
            if !recordIDs.contains(self.currentUser.record.recordID) {
                let newReference = CKReference(record: self.currentUser.record, action: .None)
                allUsersReferences.append(newReference)
                allUsersRecord.setObject(allUsersReferences, forKey: "AllUsers")
                self.publicDatabase.saveRecord(allUsersRecord, completionHandler: { (record, error) -> Void in
                    if let error = error {
                        print(error)
                    }
                    guard let _ = record else { return }
                    print("did update AllUsers with currentUser")
                })
            } else {
                print("user already a part of AllUsers")
            }
        }
    }
}
