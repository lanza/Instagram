import UIKit
import CloudKit

class Comment: RecordToClassProtocol {
    var record: CKRecord
    
    required init(){
        self.record = CKRecord.init(recordType: "Comment")
    }
    
    var commentString: String {
        get { return record.objectForKey("CommentString") as? String ?? "No comment." }
        set { record.setObject(newValue, forKey: "CommentString") }
    }
    
    init(withComment comment: String, andCommenter commenter: User, andPost post: Post) {
        self.record = CKRecord(recordType: "Comment")
        
        let referenceToCommenter = CKReference(record: commenter.record, action: .None)
        self.record.setObject(referenceToCommenter, forKey: "Commenter")
        
        let referenceToPost = CKReference(record: post.record, action: .None)
        self.record.setObject(referenceToPost, forKey: "Post")
        
        let referenceToUser = post.record.objectForKey("Poster")
        self.record.setObject(referenceToUser, forKey: "ToUser")
        
    }
    
    required convenience init(fromRecord record: CKRecord) {
        self.init()
        self.record = record
    }
}