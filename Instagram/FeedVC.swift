import UIKit
import CloudKit

class FeedVC: UIViewController, UITableViewDelegate, UITableViewDataSource, ChecksError, CloudManagerDelegate {
    @IBOutlet var tableView: UITableView!
    
    let manager = CloudManager.sharedManager
    
    // properties
    var posts = [Post]()
    var singlePost: Post?
    var hidingNavBarManager: HidingNavigationBarManager?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.estimatedRowHeight = 500
        tableView.rowHeight = UITableViewAutomaticDimension
        setUpUI()
        hidingNavBarManager = HidingNavigationBarManager(viewController: self, scrollView: tableView)
        
        if let _ = singlePost {
            self.navigationItem.titleView = nil
            self.navigationItem.title = "Photo"
        }
        
        tableView.estimatedRowHeight = 500
        tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    
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
    
    func setUpPullToRefresh() {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "pulledToRefresh", forControlEvents: .ValueChanged)
        self.tableView.addSubview(refreshControl)
    }
    
    func pulledToRefresh() {
        self.getPostsOfFollowings()
    }
    
    func getPostsOfFollowings() {
        guard let _ = CloudManager.sharedManager.currentUser else { return }
        self.posts = []
        tableView.reloadData()
        manager.getFeedPosts { (post, error) in
            CloudManager.sharedManager.currentlyGettingFeedPosts = false
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
        let descriptionLabelText = NSMutableAttributedString(string: post.posterName + " ", attributes: [NSForegroundColorAttributeName : UIColor.instagramColor()])
        descriptionLabelText.appendAttributedString(NSAttributedString(string: post.description))
        cell.descriptionLabel.attributedText = descriptionLabelText
        
        if post.likersAliases.contains(CloudManager.sharedManager.currentUser.alias) {
            cell.likeButtonImageView.imageView?.image = UIImage(named: "liked")
        } else {
            cell.likeButtonImageView.imageView?.image = UIImage(named: "like")
        }
        
        let formatter = NSDateFormatter()
        formatter.dateStyle = .NoStyle
        formatter.timeStyle = .ShortStyle
        cell.timeStamp.text = formatter.stringFromDate(post.postTime)
        
        cell.likesLabel.text = post.likersAliases.joinWithSeparator(", ")
        
        
        getComments(forPost: post) { (comments) in
            let commentStrings = comments.map { (comment) -> NSMutableAttributedString in
                let lineString = NSMutableAttributedString()
                let postName = NSAttributedString(string: comment.commenterAlias + " ", attributes: [NSForegroundColorAttributeName : UIColor.instagramColor()])
                let commentString = NSAttributedString(string: comment.commentString)
                lineString.appendAttributedString(postName)
                lineString.appendAttributedString(commentString)
                return lineString
            }
            let commentString = commentStrings.reduce (NSMutableAttributedString(), combine: { (result, nextString) -> NSMutableAttributedString in
                if !result.isEqual(NSMutableAttributedString()) {
                    result.appendAttributedString(NSAttributedString(string: "\n"))
                }
                result.appendAttributedString(nextString)
                return result
                })
                cell.friendsCommentsLabel.attributedText = commentString
        }
        
        
        cell.friendsCommentsLabel.sizeToFit()
        cell.userFullNameLabel.text = post.posterName
        cell.sizeToFit()
        
        return cell
    }
    
    func getComments(forPost post: Post, withCompletionHandler handler: (comments: [Comment]) -> ()) {
        var comments = [Comment]()
        
        let reference = CKReference(record: post.record, action: .None)
        let predicate = NSPredicate(format: "Post == %@", reference)
        let query = CKQuery(recordType: "Comment", predicate: predicate)
        let operation = CKQueryOperation(query: query)
        operation.qualityOfService = .UserInteractive
        operation.recordFetchedBlock = { record in
            comments.append(Comment(fromRecord: record))
        }
        
        operation.completionBlock = {
            comments.sortInPlace { (first, second) -> Bool in
                guard let firstTime = first.record.creationDate, secondTime = second.record.creationDate else { return true }
                if firstTime.compare(secondTime) == .OrderedDescending {
                    return true
                } else {
                    return false
                }
            }
            dispatch_async(dispatch_get_main_queue()) {
                handler(comments: comments)
            }
        }
        CloudManager.sharedManager.publicDatabase.addOperation(operation)
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
    
    func cloudManager(cloudManager: CloudManager, gotUser user: User?) {}
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
            self.tableView.reloadData()
        }
    }
    func cloudManager(cloudManager: CloudManager, gotUserPost post: Post?) {}
    
}

