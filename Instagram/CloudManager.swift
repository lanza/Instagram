import UIKit
import CloudKit

protocol CloudManagerDelegate {

    func cloudManager(cloudManager: CloudManager, gotFollowings followings: [User]?)
    func cloudManager(cloudManager: CloudManager, gotAllUsers allUsers: [User]?)
    func cloudManager(cloudManager: CloudManager, gotFeedPost post: Post?)
    func cloudManager(cloudManager: CloudManager, gotUserPost post: Post?)
    func cloudManager(cloudManager: CloudManager, gotUser user: User?)
}

class CloudManager {
    
    var delegate: CloudManagerDelegate?
    
    var allUsers = [User]()
    var currentUser = User()
    var followings = [User]() {
        didSet {
            delegate?.cloudManager(self, gotFollowings: self.followings)
        }
    }
    var feedPosts = [Post]()
    var currentUsersPosts = [Post]()
    
    static var sharedManager = CloudManager()
    let container: CKContainer
    let publicDatabase: CKDatabase
    
    private init() {
        container = CKContainer.defaultContainer()
        publicDatabase = container.publicCloudDatabase
        getCurrentUser { (user, error) in
            self.getFollowingsForUser(self.currentUser) { (users, error) in
                self.getFeedPosts(withCompletionHandler: nil)
            }
            self.checkIfInAllUsers()
        }
    }
        
    func getAllUsers(withPredicate: NSPredicate, andCompletionHandler completionHandler: (([User]?,ErrorType?) -> ())? ) {
        
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: "AllUsers", predicate: predicate)
        publicDatabase.performQuery(query, inZoneWithID: nil) { (records, error) -> Void in
            if let error = error {
                print(error)
            }
            guard let allUsersReference = records?[0].objectForKey("AllUsers") as? [CKReference] else { return }
            let recordIDs = allUsersReference.map { reference -> CKRecordID in
                return reference.recordID
            }
            let operation = CKFetchRecordsOperation(recordIDs: recordIDs)
            
            operation.qualityOfService = .UserInteractive
            operation.fetchRecordsCompletionBlock = { recordsDictionary, error in
                guard let recordsDictionary = recordsDictionary else { completionHandler?(nil,error); return }
                let records = Array(recordsDictionary.values)
                self.allUsers = records.map { record -> User in
                    return User(fromRecord: record)
                }
                completionHandler?(self.allUsers,error)
            }
            operation.completionBlock = {
                print("done fetching all users")
                self.delegate?.cloudManager(self, gotAllUsers: self.allUsers)
            }
            self.publicDatabase.addOperation(operation)
        }
    }
    
    func getFollowingsForUser(user: User, withCompletionHandler completionHandler: (([User]?,ErrorType?) -> ())?) {
        guard let followingsReferences = user.record["Followings"] as? [CKReference] else {
            print("no followingsReferences")
            return
        }
        let followingsRecordIDs = followingsReferences.map { (reference) -> CKRecordID in
            return reference.recordID
        }
        let operation = CKFetchRecordsOperation(recordIDs: followingsRecordIDs)
        operation.qualityOfService = .UserInteractive
        operation.fetchRecordsCompletionBlock = { recordsDictionary, error in
            guard let recordsDictionary = recordsDictionary else { completionHandler?(nil,error); return }
            let records = Array(recordsDictionary.values)
            self.followings = records.map { (record) -> User in
                return User(fromRecord: record)
            }
            completionHandler?(self.followings, error)
        }
        operation.completionBlock = {
            print("Get followings for user finished")
            self.delegate?.cloudManager(self, gotFollowings: self.followings)
        }
        publicDatabase.addOperation(operation)
    }
    
    func getFeedPosts(withCompletionHandler completionHandler: (([Post]?,ErrorType?) -> ())?) {
        guard followings.count > 0 else { return }
        func getUsersPosts(user: User, completion: (([Post]?,ErrorType?)->())?) {
            let reference = CKReference(record: user.record, action: .None)
            let predicate = NSPredicate(format: "Poster == %@", reference)
            let query = CKQuery(recordType: "Post", predicate: predicate)
            let operation = CKQueryOperation(query: query)
            operation.qualityOfService = .UserInteractive
            operation.recordFetchedBlock = { record in
                let post = Post(fromRecord: record)
                self.feedPosts.append(post)
                self.delegate?.cloudManager(self, gotFeedPost: post)
            }
            operation.completionBlock = {
                "getFeedPosts finished"
                completion?(nil,nil)
            }
            publicDatabase.addOperation(operation)
        }     
        
        for user in followings {
            getUsersPosts(user, completion: nil)
        }
        getUsersPosts(self.currentUser, completion: completionHandler)
    }
    
    func getPostsForUser(user: User, withCompletionHandler completionHandler: (([Post]?,ErrorType?) -> ())?) {
        let reference = CKReference(record: user.record, action: .None)
        let predicate = NSPredicate(format: "Poster == %@", reference)
        let query = CKQuery(recordType: "Post", predicate: predicate)
        let operation = CKQueryOperation(query: query)
        operation.qualityOfService = .UserInteractive
        operation.recordFetchedBlock = { record in
            let post = Post(fromRecord: record)
            self.currentUsersPosts.append(post)
            self.delegate?.cloudManager(self, gotUserPost: post)
        }
        operation.completionBlock = {
            print("got posts for user finished")
            completionHandler?(nil,nil)
        }
        publicDatabase.addOperation(operation)
    }
}













