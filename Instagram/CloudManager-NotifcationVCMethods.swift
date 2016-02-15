import UIKit
import CloudKit

extension CloudManager {
    
    
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