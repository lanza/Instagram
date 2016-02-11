import UIKit
import CloudKit

extension FeedVC: FeedCellDelegate {
    func feedCell(feedCell: FeedCell, likeButtonTapped likeButton: UIButton) {
        guard let indexPath = tableVieew.indexPathForCell(feedCell) else {
            print("\(__FUNCTION__) could not get indexPath")
            return
        }
        let post = posts[indexPath.row]
        
        if !post.likersAliases.contains(user.alias) {
            post.likersAliases.append(user.alias)
            manager.addLike(toPost: post)
            post.saveRecord(inDatabase: manager.publicDatabase) { () -> () in
                print("like added to post")
            }
            tableVieew.reloadData()
        }       
    }
}
