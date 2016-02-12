import UIKit

class ProfileVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, CloudManagerDelegate {
    
    // CloudKit
    let manager = CloudManager.sharedManager
    var posts = [Post]()
    
    // storyboard
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var usernameTextView: UITextView!
    @IBOutlet weak var postsNumberLabel: UILabel!
    @IBOutlet weak var followersNumberLabel: UILabel!
    @IBOutlet weak var followingNumberLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        setUpUI()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        CloudManager.sharedManager.delegate = self
        self.usernameTextView.text = CloudManager.sharedManager.currentUser.alias
        getPosts()
    }
    
    var currentlyWaitingForGetPostsToReturn = false
    func getPosts() {
        if !currentlyWaitingForGetPostsToReturn {
            self.posts = []
            self.currentlyWaitingForGetPostsToReturn = true
            manager.getPostsForCurrentUser { (post, error) in
                self.currentlyWaitingForGetPostsToReturn = false
            }
        }
    }
    func cloudManager(cloudManager: CloudManager, gotCurrentUser currentUser: User?) {
        NSOperationQueue.mainQueue().addOperationWithBlock { 
            self.usernameTextView.text = currentUser?.alias
        }
    }
    func cloudManager(cloudManager: CloudManager, gotFollowings followings: [User]?) {
        getPosts()
    }
    func cloudManager(cloudManager: CloudManager, gotAllUsers allUsers: [User]?) {}
    func cloudManager(cloudManager: CloudManager, gotFeedPost post: Post?) {}
    func cloudManager(cloudManager: CloudManager, gotCurrentUserPost post: Post?) {
        guard let post = post else { return }
        self.posts.append(post)
        NSOperationQueue.mainQueue().addOperationWithBlock {
            self.collectionView.reloadData()
            self.postsNumberLabel.text  = "\(self.posts.count)"
        }
    }
    
}

