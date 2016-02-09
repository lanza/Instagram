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
        print("FUCK")
        
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
    
    
    func getFollowersForUser(user: User, withCompletionHandler completionHandler: ([User]?,ErrorType?) -> ()) {
        let reference = CKReference(record: user.record, action: .None)
        let predicate = NSPredicate(format: "Followings CONTAINS %@", reference)
        let query = CKQuery(recordType: "User", predicate: predicate)
        publicDatabase.performQuery(query, inZoneWithID: nil) { (records, error) -> Void in
            guard let records = records else { return }
            var users = [User]()
            for record in records {
                let user = User(fromRecord: record)
                users.append(user)
            }
            completionHandler(users,error)
        }
        
    }
    
    func getFollowingsForUser(user: User, withCompletionHandler completionHandler: ([User]?,ErrorType?) -> ()) {
        let reference = CKReference(record: user.record, action: .None)
        let predicate = NSPredicate(format: "Followers CONTAINS %@", reference)
        let query = CKQuery(recordType: "User", predicate: predicate)
        publicDatabase.performQuery(query, inZoneWithID: nil) { (records, error) -> Void in
            guard let records = records else { return }
            var users = [User]()
            for record in records {
                let user = User(fromRecord: record)
                users.append(user)
            }
            completionHandler(users,error)
        }
        
    }
    
    func getcommentsForPost(post: Post) {
        
    }
}