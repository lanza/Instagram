import UIKit
import CloudKit

class CloudManager {
    static var sharedManager = CloudManager()
    let container: CKContainer
    let publicDatabase: CKDatabase
    private init() {
        container = CKContainer.defaultContainer()
        publicDatabase = container.publicCloudDatabase
    }
    
    var currentUser: User!
    
    func getCurrentUser(completionHandler: (User?,ErrorType?) -> () ) {
        
        container.fetchUserRecordIDWithCompletionHandler { (userRecordID, errorOne) -> Void in
            if let errorOne = errorOne {
                completionHandler(nil,errorOne)
                return
            }
            guard let userRecordID = userRecordID else { return }
            self.publicDatabase.fetchRecordWithID(userRecordID, completionHandler: { (userRecord, errorTwo) -> Void in
                if let errorTwo = errorTwo {
                    completionHandler(nil,errorTwo)
                    return
                }
                guard let userRecord = userRecord else { return }
                let user = User(fromRecord: userRecord)
                self.currentUser = user
                completionHandler(user,nil)
            })
        }
    }
    
    func postImage(imageURL: NSURL, description: String) {
        
        func savePost(post: Post) {
            post.saveRecord(inDatabase: publicDatabase, withCompletionHandler: nil)
        }
        
        let post = Post(withImageURL: imageURL, andDescription: description, andPoster: currentUser)
        let referenceToPost = CKReference(record: post.record, action: .None)
        
        var usersPosts = currentUser.record.objectForKey("Posts") as? [CKReference]
        if var usersPosts = usersPosts {
            usersPosts.append(referenceToPost)
            currentUser.record.setObject(usersPosts, forKey: "Posts")
        } else {
            usersPosts = [referenceToPost]
            currentUser.record.setObject(usersPosts, forKey: "Posts")
        }

        currentUser.saveRecord(inDatabase: publicDatabase) { () -> () in
            savePost(post)
        }
        
//        let ckModifyRecordsOperation = CKModifyRecordsOperation(recordsToSave: [currentUser.record, post.record], recordIDsToDelete: nil)
//        ckModifyRecordsOperation.modifyRecordsCompletionBlock = { records, recordIDs, error in
//            print("Started")
//            if let error = error {
//                print("The function \(__FUNCTION__) had the error: \(error)")
//            }
//            guard let records = records else { return }
//        }
//        ckModifyRecordsOperation.completionBlock = {
//            print("finished")
//        }
//        publicDatabase.addOperation(ckModifyRecordsOperation)
    }
    

    
    func getPostsForUser(user: User, withCompletionHandler completionHandler: ([Post]?,ErrorType?) -> ()) {
       
        
        let reference = CKReference(record: user.record, action: .None)
        let predicate = NSPredicate(format: "Poster == %@", reference)
        let query = CKQuery(recordType: "Post", predicate: predicate)
        publicDatabase.performQuery(query, inZoneWithID: nil) { (records, error) -> Void in
            guard let records = records else { return }
            var posts = [Post]()
            for record in records {
                let post = Post(fromRecord: record)
                posts.append(post)
            }
            completionHandler(posts,error)
        }
    }
    //switch to child->parent relationships
    
    func getFollowersForUser(user: User, withCompletionHandler completionHandler: ([User]?,ErrorType?) -> ()) {
        
    }
    
    func getFollowingsForUser(user: User, withCompletionHandler completionHandler: ([User]?,ErrorType?) -> ()) {
        
        guard let followingsReferences = user.record["Followings"] as? [CKReference] else {
            print("no followingsReferences")
            return
        }
        
        var followedUsers = [User]()
        var recordIDs = [CKRecordID]()
        for reference in followingsReferences {
            let recordID = reference.recordID
            recordIDs.append(recordID)
        }
        let operation = CKFetchRecordsOperation(recordIDs: recordIDs)
        operation.qualityOfService = .UserInitiated
        operation.fetchRecordsCompletionBlock = { recordsDictionary, error in
            guard let recordsDictionary = recordsDictionary else { return }
            for (_, record) in recordsDictionary {
                let newFollowee = User(fromRecord: record)
                followedUsers.append(newFollowee)
            }
            completionHandler(followedUsers, error)
        }
        operation.completionBlock = {
            print("CKFetchRecordsOperation finished")
        }
        publicDatabase.addOperation(operation)
    }
    
    func getcommentsForPost(post: Post) {
        
    }
}