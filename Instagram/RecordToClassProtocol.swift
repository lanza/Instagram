import UIKit
import CloudKit

protocol RecordToClassProtocol {
    var record: CKRecord { get set }
    func saveRecord(inDatabase database: CKDatabase, withCompletionHandler handler: (() -> ())?)
    init(fromRecord record: CKRecord)
    init()
    
}

extension RecordToClassProtocol {
    
    func saveRecord(inDatabase database: CKDatabase, withCompletionHandler handler: (() -> Void)?){
        database.saveRecord(record) { (record, error) in
            if let error = error {
                print("\(__FUNCTION__) failed to save the record with error: \(error.localizedDescription)")
            }
            guard let handler = handler else { return }
            NSOperationQueue.mainQueue().addOperationWithBlock(handler)
        }
    }
    init(fromRecord record: CKRecord) {
        self.init()
        self.record = record
    }
}