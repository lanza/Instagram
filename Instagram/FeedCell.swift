import UIKit

protocol FeedCellDelegate {
    func feedCell(feedCell: FeedCell, likeButtonTapped likeButton: UIButton)
    func feedCell(feedCell: FeedCell, commentButtonTapped commentButton: UIButton)
    func feedCell(feedCell: FeedCell, onImageDoubleTapped image: UIImage)
    
}

class FeedCell: UITableViewCell {
    var doubleTap = UITapGestureRecognizer()
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        doubleTap = UITapGestureRecognizer(target: self, action: "onImageDoubleTapped:")
        doubleTap.delegate = self
        doubleTap.numberOfTapsRequired = 2
        self.addGestureRecognizer(doubleTap)

    }
    
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
    
    @IBAction func onCommentButtonTapped(sender: UIButton) {
        delegate.feedCell(self, commentButtonTapped: sender)
    }
    
    func onImageDoubleTapped(sender: UIImage) {
        delegate.feedCell(self, onImageDoubleTapped: sender)
    }
}
