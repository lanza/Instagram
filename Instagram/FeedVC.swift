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
        self.currentlyWaitingForPosts = false
        manager.delegate = self
        self.getPostsOfFollowings()
    }
    var currentlyWaitingForPosts = false
    
    func setUpPullToRefresh() {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "pulledToRefresh", forControlEvents: .ValueChanged)
        self.tableVieew.addSubview(refreshControl)
    }
    
    func pulledToRefresh() {
        self.getPostsOfFollowings()
    }
    
    func getPostsOfFollowings() {
        if !currentlyWaitingForPosts {
            currentlyWaitingForPosts = true
            self.posts = []
            tableVieew.reloadData()
            manager.getFeedPosts { (post, error) in
                self.currentlyWaitingForPosts = false
            }
        }
    }
    
    
    // MARK: - TableView delegate methods
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell") as! FeedCell
        let post = singlePost ?? posts[indexPath.row]
        
        cell.delegate = self
        
        cell.avatarImageView.image = post.posterAvatar?.circle
        
        cell.userFullNameLabel.text = post.posterName
        cell.postImageView.image = post.image
        cell.descriptionLabel.text = post.description
        
        let formatter = NSDateFormatter()
        formatter.dateStyle = .ShortStyle
        formatter.timeStyle = .ShortStyle
        cell.timeStamp.text = formatter.stringFromDate(post.postTime)
        
        var likersText = ""
        for liker in post.likersAliases {
            if likersText != "" {
                likersText.appendContentsOf(", ")
            }
            likersText.appendContentsOf(liker)
        }       
        
        var commentsText = ""
        for comment in post.commentStrings {
            if commentsText != "" {
                commentsText.appendContentsOf("\n")
            }
            commentsText.appendContentsOf(comment)
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
    
    
    func cloudManager(cloudManager: CloudManager, gotUser user: User?) {

    }
    func cloudManager(cloudManager: CloudManager, gotFollowings followings: [User]?) {
        getPostsOfFollowings()
    }
    func cloudManager(cloudManager: CloudManager, gotAllUsers allUsers: [User]?) {}
    func cloudManager(cloudManager: CloudManager, gotFeedPost post: Post?) {
        guard let post = post else { return }
        self.posts.append(post)
        NSOperationQueue.mainQueue().addOperationWithBlock {
            self.posts.sortInPlace { (postOne, postTwo) -> Bool in
                if postOne.postTime.compare(postTwo.postTime) == .OrderedAscending {
                    return false
                } else {
                    return true
                }
            }
            self.tableVieew.reloadData()
        }
    }
    func cloudManager(cloudManager: CloudManager, gotUserPost post: Post?) {}
    
}

