import UIKit
import CloudKit

struct Post: RecordToClassProtocol {
    var record: CKRecord
    
    var image: UIImage? {
        get {
            guard let asset = record.objectForKey("Image") as? CKAsset else { return nil }
            let url = asset.fileURL
            guard let data = NSData(contentsOfURL: url) else { return nil }
            let image = UIImage(data: data)
            return image
        }
    }
    var description: String {
        get { return record.objectForKey("Desription") as! String }
        set { record.setObject(newValue, forKey: "Description") }
    }
    
    var posterName: String {
        get { return record.objectForKey("PosterName") as? String ?? "No Name"
        }
    }
    
    init(){
        self.record = CKRecord.init(recordType: "Post")
    }
    
    init(withImageURL imageURL: NSURL, andDescription description: String, andPoster poster: User) {
        self.record = CKRecord(recordType: "Post")
        let imageAsset = CKAsset(fileURL: imageURL)
        self.record.setObject(imageAsset, forKey: "Image")
        
        let data = NSData(contentsOfURL: imageURL)!
        let image = UIImage(data: data)
        
        self.record.setObject(description, forKey: "Description")
        let reference = CKReference(record: poster.record, action: .None)
        self.record.setObject(reference, forKey: "Poster")
    }
}