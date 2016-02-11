import UIKit

class FeedVC: UIViewController, UITableViewDelegate, UITableViewDataSource, ChecksError {
    @IBOutlet var tableVieew: UITableView!

    
    
    let manager = CloudManager.sharedManager
    var user: User!   
    
    // properties
    var posts = [Post]()
    var singlePost: Post?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpUI()
        
        if let _ = singlePost {
//            self.navigationItem.titleView = nil
            self.navigationItem.title = "Photo"
        }
        manager.getCurrentUser { (user, error) -> () in
            if let error = error {
                print(__FUNCTION__,error)
            }
            guard let user = user else { return }
            self.user = user
            self.getPostsOfFollowings()
            self.manager.checkIfInAllUsers()
        }
        
        tableVieew.estimatedRowHeight = 500
        tableVieew.rowHeight = UITableViewAutomaticDimension
    }
    
    
    // MARK: – Process data.
    
    func getPostsOfFollowings() {
        self.posts = [Post]()
        manager.getFollowingsForUser(user) { (followedUsers, errorOne) -> () in
            if let error = errorOne {
                print("\(__FUNCTION__) has had an error: \(error)")
            }
            guard let followedUsers = followedUsers else { return }
            
            for followedUser in followedUsers {
                self.getPostsForUser(followedUser)
            }
            self.getPostsForUser(self.user) 
        }
    }
    
    
    func getPostsForUser(followedUser: User ) {
        self.manager.getPostsForUser(followedUser) { (posts, errorTwo) -> () in
            if let error = errorTwo {
                print("\(__FUNCTION__) has had an error: \(error)")
            }
            guard let posts = posts else { return }
            for post in posts {
                self.posts.append(post)
            }
            NSOperationQueue.mainQueue().addOperationWithBlock { () -> Void in
                self.tableVieew.reloadData()
            }
        }
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
        var commentsText = ""
        for comment in post.commentStrings {
            commentsText = commentsText + "\n" + comment
        }
        if commentsText.characters.count > 3 {
            commentsText.removeRange(Range<String.Index>(start: commentsText.startIndex, end: commentsText.startIndex.advancedBy(1)))
        }
        
        
        print("here is the commentsText \(commentsText)")
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

}

