import UIKit

class FeedVC: UIViewController, UITableViewDelegate, UITableViewDataSource, ChecksError, CloudManagerDelegate {
    @IBOutlet var tableVieew: UITableView!
   
    let manager = CloudManager.sharedManager
    
    // properties
    var posts = [Post]()
    var singlePost: Post?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        setUpUI()
        
        if let _ = singlePost {
            self.navigationItem.titleView = nil
            self.navigationItem.title = "Photo"
        }
        
        tableVieew.estimatedRowHeight = 500
        tableVieew.rowHeight = UITableViewAutomaticDimension
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        manager.delegate = self        
        self.getPostsOfFollowings()
    }
    
    func setUpPullToRefresh() {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "pulledToRefresh", forControlEvents: .ValueChanged)
        self.tableVieew.addSubview(refreshControl)
    }
    
    func pulledToRefresh() {
        self.getPostsOfFollowings()
    }
    
    func getPostsOfFollowings() {
        self.posts = []
        tableVieew.reloadData()
        manager.getFeedPosts(withCompletionHandler: nil)
    }

    
    // MARK: - TableView delegate methods
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell") as! FeedCell
        let post = singlePost ?? posts[indexPath.row]
        
        cell.delegate = self
        
        cell.userFullNameLabel.text = post.posterName
        cell.postImageView.image = post.image
        cell.descriptionLabel.text = post.description
        cell.avatarImageView.image = UIImage(named: "Nathan")
        
//        post.avatarImage!.layer.cornerRadius = post.avatarImage!.frame.size.width/2
        post.avatarImage?.layer.cornerRadius = 67.0
        post.avatarImage?.clipsToBounds = true
        
        
        var likersText = ""
        for liker in post.likersAliases {
            likersText.appendContentsOf(liker)
            likersText.appendContentsOf(", ")
        }
        if likersText.characters.count > 0 {
            likersText.removeAtIndex(likersText.endIndex.predecessor())
        }
        
        
        var commentsText = ""
        for comment in post.commentStrings {
            commentsText = commentsText + "\n" + comment
        }
        if commentsText.characters.count > 3 {
            commentsText.removeRange(Range<String.Index>(start: commentsText.startIndex, end: commentsText.startIndex.advancedBy(1)))
        }
        
        cell.likesLabel.text = likersText
        cell.friendsCommentsLabel.text = commentsText

        cell.friendsCommentsLabel.sizeToFit()
        cell.userFullNameLabel.text = post.posterName
        cell.sizeToFit()
        
        return cell
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let _ = singlePost {
            return 1
        } else {
            return posts.count
        }
    }
    
    
    func tableView(tableView: UITableView, shouldHighlightRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "commentSegue" {
            let post = sender as! Post
            let cVC = segue.destinationViewController as! CommentVC
            cVC.post = post
        }
    }
    
    
    func cloudManager(cloudManager: CloudManager, gotCurrentUser currentUser: User?) {}
    func cloudManager(cloudManager: CloudManager, gotFollowings followings: [User]?) {
        getPostsOfFollowings()
    }
    func cloudManager(cloudManager: CloudManager, gotAllUsers allUsers: [User]?) {}
    func cloudManager(cloudManager: CloudManager, gotFeedPost post: Post?) {
        guard let post = post else { return }
        self.posts.append(post)
        NSOperationQueue.mainQueue().addOperationWithBlock { 
            self.tableVieew.reloadData()
        }
    }
    func cloudManager(cloudManager: CloudManager, gotCurrentUserPost post: Post?) {}
    
}

