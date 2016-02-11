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
    
    var commenterAlias: String {
        get { return record.objectForKey("CommenterAlias") as? String ?? "No Alias" }
        set { record.setObject(newValue, forKey: "CommenterAlias") }
    }
    
    init(withComment comment: String, andCommenter commenter: User, andPost post: Post) {
        self.record = CKRecord(recordType: "Comment")
        
        let referenceToCommenter = CKReference(record: commenter.record, action: .None)
        self.record.setObject(referenceToCommenter, forKey: "Commenter")
        
        let referenceToPost = CKReference(record: post.record, action: .None)
        self.record.setObject(referenceToPost, forKey: "Post")
        
        let referenceToUser = post.record.objectForKey("Poster")
        self.record.setObject(referenceToUser, forKey: "ToUser")
        
        self.record.setObject(commenter.alias, forKey: "CommenterAlias")
        self.commentString = comment    
    }
    
    required convenience init(fromRecord record: CKRecord) {
        self.init()
        self.record = record
    }
}