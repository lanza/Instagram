import UIKit
import CloudKit

class Like: RecordToClassProtocol {
    var record: CKRecord
    //switch to child->parent relationships

    required init(){
        self.record = CKRecord.init(recordType: "Comment")
    }
    
    init(withLiker liker: User, andPost post: Post) {
        self.record = CKRecord(recordType: "Like")
        
        let referenceToLiker = CKReference(record: liker.record, action: .None)
        self.record.setObject(referenceToLiker, forKey: "Liker")
        
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