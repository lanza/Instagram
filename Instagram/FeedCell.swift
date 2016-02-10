import UIKit

class FeedCell: UITableViewCell {
    @IBOutlet var postImageView: UIImageView!
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var friendsCommentsLabel: UILabel!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var userFullNameLabel: UILabel!
    @IBOutlet weak var likesLabel: UILabel!
    
    @IBAction func onLikeButtonTapped(sender: UIButton) {
        // like
    }
    
    
    @IBAction func onCommentButtonTapped(sender: UIButton) {
        // comment
    }
}
