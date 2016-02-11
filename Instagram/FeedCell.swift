import UIKit

protocol FeedCellDelegate {
    func feedCell(feedCell: FeedCell, likeButtonTapped likeButton: UIButton)
    func feedCell(feedCell: FeedCell, commentButtonTapped commentButton: UIButton)
}

class FeedCell: UITableViewCell {
    
    var delegate: FeedCellDelegate!

    @IBOutlet var postImageView: UIImageView!
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var friendsCommentsLabel: UILabel!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var userFullNameLabel: UILabel!
    @IBOutlet weak var likesLabel: UILabel!
    
    @IBAction func onLikeButtonTapped(sender: UIButton) {
        delegate.feedCell(self, likeButtonTapped: sender)
    }
}
