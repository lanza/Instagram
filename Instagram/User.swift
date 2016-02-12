import UIKit
import CloudKit

class User: RecordToClassProtocol {
    var record: CKRecord
    
    var avatar: UIImage? {
        get {
            guard let asset = record.objectForKey("Avatar") as? CKAsset else { return nil }
            let url = asset.fileURL
            guard let data = NSData(contentsOfURL: url) else { return nil }
            let image = UIImage(data: data)
            return image
        }
    }

    
    var alias: String {
        get { return record.objectForKey("NameAlias") as? String ?? "No Alias" }
        set { record.setObject(newValue, forKey: "NameAlias") }
    }    
  
    required init() {
        self.record = CKRecord.init(recordType: "Users")
    }
    
    required convenience init(fromRecord record: CKRecord) {
        self.init()
        self.record = record
    }
}

