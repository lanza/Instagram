import UIKit
import CloudKit

struct Like: RecordToClassProtocol {
    var record: CKRecord

    init(){
        self.record = CKRecord.init(recordType: "Post")
    }
    
    init(withLiker liker: User, andPost post: Post) {
        self.record = CKRecord(recordType: "Post")
        
        let referenceToLiker = CKReference(record: liker.record, action: .None)
        self.record.setObject(referenceToLiker, forKey: "Liker")
        
        let referenceToPost = CKReference(record: post.record, action: .None)
        self.record.setObject(referenceToPost, forKey: "Post")
        
    }
}