import UIKit
import CloudKit

struct User: RecordToClassProtocol {
    var record: CKRecord
    
    var alias: String {
        get { return record.objectForKey("Alias") as? String ?? "No Alias" }
        set { record.setObject("Alias", forKey: newValue) }
    }    
  
    init() {
        self.record = CKRecord.init(recordType: "User")
    }
}