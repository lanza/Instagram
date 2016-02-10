import UIKit
import CloudKit

class Post: RecordToClassProtocol {
    var record: CKRecord
    //switch to child->parent relationships

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
        get { return record.objectForKey("Description") as? String ?? "No description"}
        set { record.setObject(newValue, forKey: "Description") }
    }
    
    var posterName: String {
        get { return record.objectForKey("PosterName") as? String ?? "No Name" }
        set { record.setObject(newValue, forKey: "PosterName") }
    }
    
    var likersAliases: [String] {
        get { return record.objectForKey("LikersAliases") as? [String] ?? [String]() }
        set { record.setObject(newValue, forKey: "LikersAliases") }
    }
    
    var commentStrings: [String] {
        get { return record.objectForKey("CommentStrings") as? [String] ?? [String]() }
        set { record.setObject(newValue, forKey: "CommentStrings") }
    }
    
    required init(){
        self.record = CKRecord.init(recordType: "Post")
    }
    
    init(withImageURL imageURL: NSURL, andDescription description: String, andPoster poster: User) {
        self.record = CKRecord(recordType: "Post")
        let imageAsset = CKAsset(fileURL: imageURL)
        self.record.setObject(imageAsset, forKey: "Image")
       
        self.record.setObject(description, forKey: "Description")
        let reference = CKReference(record: poster.record, action: .None)
        self.record.setObject(reference, forKey: "Poster")
        
        self.posterName = poster.alias
    }
    required convenience init(fromRecord record: CKRecord) {
        self.init()
        self.record = record
    }
}