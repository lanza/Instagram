import UIKit
import CloudKit

extension FeedVC: FeedCellDelegate {
    func feedCell(feedCell: FeedCell, likeButtonTapped likeButton: UIButton) {
        guard let indexPath = tableView.indexPathForCell(feedCell) else {

            print("\(__FUNCTION__) could not get indexPath")
            return
        }
        let post = posts[indexPath.row]
        
        if !post.likersAliases.contains(manager.currentUser.alias) {
            post.likersAliases.append(manager.currentUser.alias)
            manager.addLike(toPost: post)
            post.saveRecord(inDatabase: manager.publicDatabase) { () -> () in
                print("like added to post")
            }
            tableView.reloadData()
        }
    }
    func feedCell(feedCell: FeedCell, commentButtonTapped likeButton: UIButton) {
        guard let indexPath = tableView.indexPathForCell(feedCell) else {
            print("\(__FUNCTION__) could not get indexPath")
            return
        }
        let post = posts[indexPath.row]
        performSegueWithIdentifier("commentSegue", sender: post)
    }

}


