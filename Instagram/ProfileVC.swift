import UIKit
import CloudKit

class ProfileVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, CloudManagerDelegate {
    
    // CloudKit
    let manager = CloudManager.sharedManager
    var posts = [Post]()
    var user: User?
    var userIsFriend = false
    
    // storyboard
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet var userInfoLabel: UILabel!
    
    @IBOutlet weak var postsNumberLabel: UILabel!
    @IBOutlet weak var followersNumberLabel: UILabel!
    @IBOutlet weak var followingNumberLabel: UILabel!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.user = CloudManager.sharedManager.currentUser
    }
    
    @IBAction func editOrFollowButtonTapped(sender: UIButton) {
        if userIsFriend {
            guard let user = user else { return }
            let reference = CKReference(record: user.record, action: .None)
            let currentUser = CloudManager.sharedManager.currentUser
            guard var followings = currentUser.record.objectForKey("Followings") as? [CKReference] else { return }
            followings.append(reference)
            currentUser.record.setObject(followings, forKey: "Followings")
            currentUser.saveRecord(inDatabase: CloudManager.sharedManager.publicDatabase, withCompletionHandler: nil)
        } else {
            //do something eventually
        }
    }
    
    
    @IBOutlet var editOrFollowButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()       
        
        collectionView.delegate = self
        collectionView.dataSource = self
        setUpUI()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.currentlyWaitingForGetPostsToReturn = false
        CloudManager.sharedManager.delegate = self
        if !self.userIsFriend {
            self.user = CloudManager.sharedManager.currentUser
        }
        setViewsToUser()
        getPosts()
        
        if self.userIsFriend {
            guard let followings = CloudManager.sharedManager.currentUser.record.objectForKey("Followings") as? [CKReference] else { return }
            let followingsIDs = followings.map { (reference) -> String in
                return reference.recordID.recordName
            }
            guard let user = user else { return }
            if followingsIDs.contains(user.record.recordID.recordName) {
                self.editOrFollowButton.enabled = false
                self.editOrFollowButton.setTitle("Following", forState: .Normal)
            }
        } else {
            self.editOrFollowButton.setTitle("Edit Profile", forState: .Normal)
        }
    }
    
    func setViewsToUser() {
        self.postsNumberLabel.text  = "\(self.posts.count)"
        self.userInfoLabel.text = self.user?.alias
        self.imageView.image = self.user?.avatar?.circle
        guard let followings = self.user?.record.objectForKey("Followings") as? [CKReference] else { return }
        self.followingNumberLabel.text = String(followings.count)
        self.followersNumberLabel.text = String(followings.count)
    }
    
    var currentlyWaitingForGetPostsToReturn = false
    func getPosts() {
        guard let user = user else { return }
        if !currentlyWaitingForGetPostsToReturn {
            self.posts = []
            self.collectionView.reloadData()
            self.currentlyWaitingForGetPostsToReturn = true
            manager.getPostsForUser(user) { (post, error) in
                self.currentlyWaitingForGetPostsToReturn = false
            }
        }
    }
    func cloudManager(cloudManager: CloudManager, gotUser user: User?) {
        if !userIsFriend {
            NSOperationQueue.mainQueue().addOperationWithBlock {
                self.user = user
                self.setViewsToUser()
                self.getPosts()
            }
        }
    }
    func cloudManager(cloudManager: CloudManager, gotFollowings followings: [User]?) {
        getPosts()
    }
    func cloudManager(cloudManager: CloudManager, gotAllUsers allUsers: [User]?) {}
    func cloudManager(cloudManager: CloudManager, gotFeedPost post: Post?) {}
    func cloudManager(cloudManager: CloudManager, gotUserPost post: Post?) {
        guard let post = post else { return }
        self.posts.append(post)
        self.posts.sortInPlace { (postOne, postTwo) -> Bool in
            if (postOne.postTime.compare(postTwo.postTime) == .OrderedDescending) {
                return true
            } else {
                return false
            }
        }
        NSOperationQueue.mainQueue().addOperationWithBlock {
            
            self.collectionView.reloadData()
            self.setViewsToUser()
        }
    }
    
}

