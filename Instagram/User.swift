import UIKit
import CloudKit

class User: RecordToClassProtocol {
    var record: CKRecord
    
    var alias: String {
        get { return record.objectForKey("NameAlias") as? String ?? "No Alias" }
        set { record.setObject("NameAlias", forKey: newValue) }
    }    
  
    required init() {
        self.record = CKRecord.init(recordType: "User")
    }
    
    required convenience init(fromRecord record: CKRecord) {
        self.init()
        self.record = record
    }
}

