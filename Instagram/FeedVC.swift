import UIKit

class FeedVC: UIViewController, UITableViewDelegate, UITableViewDataSource, ChecksError, CloudManagerDelegate {
    @IBOutlet var tableView: UITableView!
    
    let manager = CloudManager.sharedManager
    
    // properties
    var posts = [Post]()
    var singlePost: Post?
    var hidingNavBarManager: HidingNavigationBarManager?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hidingNavBarManager = HidingNavigationBarManager(viewController: self, scrollView: tableView)
        setUpUI()
        
//        if let _ = singlePost {
//            //self.navigationItem.titleView = nil
//            self.navigationItem.title = "Photo"
//        }
        
        tableView.estimatedRowHeight = 500
        tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    //
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        hidingNavBarManager?.viewDidLayoutSubviews()
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        hidingNavBarManager?.viewWillDisappear(animated)
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        manager.delegate = self
        self.getPostsOfFollowings()
        hidingNavBarManager?.viewWillAppear(animated)
        
    }
    //
    
    func setUpPullToRefresh() {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "pulledToRefresh", forControlEvents: .ValueChanged)
        self.tableView.addSubview(refreshControl)
    }
    
    func pulledToRefresh() {
        self.getPostsOfFollowings()
    }
    
    func getPostsOfFollowings() {
        self.posts = []
        tableView.reloadData()
        manager.getFeedPosts(withCompletionHandler: nil)
    }
    
    
    // MARK: - TableView delegate methods
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell") as! FeedCell
        let post = singlePost ?? posts[indexPath.row]
        
        cell.delegate = self
        
        cell.avatarImageView.image = UIImage(named: "Nathan")!.circle
        
        cell.userFullNameLabel.text = post.posterName
        cell.postImageView.image = post.image
        cell.descriptionLabel.text = post.description
        
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
            self.tableView.reloadData()
        }
    }
    func cloudManager(cloudManager: CloudManager, gotCurrentUserPost post: Post?) {}
    
}

