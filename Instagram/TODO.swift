import CloudKit
import UIKit

enum CarType: String {
    case Hatchback = "Hatchback"
    case Estate = "Estate"
    
    func zoneId() -> CKRecordZoneID {
        let zoneId = CKRecordZoneID(zoneName: self.rawValue, ownerName: CKOwnerDefaultName)
        return zoneId
    }
    
    func zone() -> CKRecordZone {
        return CKRecordZone(zoneID: self.zoneId())
    }
}


//switch to child->parent relationships
