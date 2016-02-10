import UIKit
import CloudKit

struct User: RecordToClassProtocol {
    var record: CKRecord
    
    //switch to child->parent relationships

    func addNewPost(post: Post) {
        let referenceToPost = CKReference(record: post.record, action: .None)
        let referenceToUser = CKReference(record: record, action: .None)
        
        post.record.setObject(referenceToUser, forKey: "poster")
        var posts = record.objectForKey("posts") as? [CKReference]
        if var posts = posts {
            posts.append(referenceToPost)
            record.setObject(posts, forKey: "posts")
        } else {
            posts = [referenceToPost]
            record.setObject(posts, forKey: "posts")
        }
        saveRecord(inDatabase: CloudManager.sharedManager.publicDatabase, withCompletionHandler: nil)
    }    
    
    init() {
        self.record = CKRecord.init(recordType: "User")
    }
}