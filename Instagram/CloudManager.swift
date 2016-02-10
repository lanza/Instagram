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
    func getAllUsers(withPredicate: NSPredicate, andCompletionHandler completionHandler: ([User]?,ErrorType?) -> () ) {
        
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: "AllUsers", predicate: predicate)
        publicDatabase.performQuery(query, inZoneWithID: nil) { (records, error) -> Void in
            if let error = error {
                print(error)
            }
            guard let allUsersReference = records?[0].objectForKey("AllUsers") as? [CKReference] else { return }
            var recordIDs = [CKRecordID]()
            for reference in allUsersReference {
                recordIDs.append(reference.recordID)
            }
            let operation = CKFetchRecordsOperation(recordIDs: recordIDs)
            operation.completionBlock = {
                print("done fetching all users")
            }
            operation.qualityOfService = .UserInitiated
            operation.fetchRecordsCompletionBlock = { recordsDictionary, error in
                guard let recordsDictionary = recordsDictionary else { completionHandler(nil,error); return }
                var users = [User]()
                for (_, userRecord) in recordsDictionary {
                    let user = User(fromRecord: userRecord)
                    users.append(user)
                }
                completionHandler(users,error)
            }
            self.publicDatabase.addOperation(operation)
        }
    }
    
    
    
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
    

    func postImage(imageURL: NSURL, description: String) {
        let post = Post(withImageURL: imageURL, andDescription: description, andPoster: currentUser)
        post.saveRecord(inDatabase: publicDatabase) { () -> () in
            print("new post saved to database")
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
    
    func addLike(toPost post: Post) {
        let like = Like(withLiker: currentUser, andPost: post)
        like.saveRecord(inDatabase: publicDatabase) { () -> () in
            print("new like saved")
        }
    }
    func addComment(comment: String, toPost post: Post) {
        let comment = Comment(withComment: comment, andCommenter: currentUser, andPost: post)
        comment.saveRecord(inDatabase: publicDatabase) { () -> () in
            print("new comment saved")
        }
    }
    

    //get children for parent
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
    
    
    //get parents for child
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
    
    // Get children for parent
    func getLikesForPost(post: Post, withCompletionHandler completionHandler: ([Like]?,ErrorType?) -> ()) {
        let reference = CKReference(record: post.record, action: .None)
        let predicate = NSPredicate(format: "Post == %@", reference)
        let query = CKQuery(recordType: "Like", predicate: predicate)
        publicDatabase.performQuery(query, inZoneWithID: nil) { (records, error) -> Void in
            if let error = error {
                print("\(__FUNCTION__) had error: \(error)")
            }
            
            var likes = [Like]()
            
            guard let records = records else { completionHandler(nil,error); return }
            for record in records {
                let like = Like(fromRecord: record)
                likes.append(like)
            }
            completionHandler(likes,error)
        }
    }
    
    func getCommentsForUser(user: User, withCompletionHandler completionHandler: ([Comment]?,ErrorType?) -> ()) {
        var comments = [Comment]()
        
        let reference = CKReference(record: user.record, action: .None)
        let predicate = NSPredicate(format: "ToUser == %@", reference)
        
        let query = CKQuery(recordType: "Comment", predicate: predicate)
        let operation = CKQueryOperation(query: query)
        operation.qualityOfService = .UserInitiated
        operation.recordFetchedBlock = { record in
            let comment = Comment(fromRecord: record)
            comments.append(comment)
        }
        operation.queryCompletionBlock = { cursor, error in
            print("get comments query completed")
            completionHandler(comments,error)
        }
        publicDatabase.addOperation(operation)        
    }
    
    func getLikesForUser(user: User, withCompletionHandler completionHandler: ([Like]?,ErrorType?) -> ()) {
        var likes = [Like]()
        
        let reference = CKReference(record: user.record, action: .None)
        let predicate = NSPredicate(format: "ToUser == %@", reference)
        
        let query = CKQuery(recordType: "Like", predicate: predicate)
        let operation = CKQueryOperation(query: query)
        operation.qualityOfService = .UserInitiated
        operation.recordFetchedBlock = { record in
            let like = Like(fromRecord: record)
            likes.append(like)
        }
        operation.queryCompletionBlock = { cursor, error in
            print("get likes query completed")
            completionHandler(likes,error)
        }
        publicDatabase.addOperation(operation)
    }
}












