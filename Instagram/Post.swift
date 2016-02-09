import UIKit
import CloudKit

struct Post: RecordToClassProtocol {
    var record: CKRecord
    
//    var image: UIImage {
//        get {
//            let imageAsset = record.objectForKey("imageAsset") as? CKAsset
//            
//            let image = UIImage(contentsOfFile: imageAsset?.fileURL.absoluteString)
//            NSURL
//        }
//    }
    
    var posterName: String {
        get { return record.objectForKey("posterName") as? String ?? "No Name"
        }
    }
    
    init(){
        self.record = CKRecord.init(recordType: "Post")
    }
    
    init(withImageURL imageURL: NSURL, andDescription description: String) {
        self.record = CKRecord(recordType: "Post")
        let imageAsset = CKAsset(fileURL: imageURL)
        self.record.setObject(imageAsset, forKey: "imageAsset")
        self.record.setObject(description, forKey: "description")
    }
}