import UIKit

class MainFeedVC: UIViewController, UITableViewDelegate, UITableViewDataSource, ChecksError {
    @IBOutlet var tableVieew: UITableView!

    let manager = CloudManager.sharedManager
    var user: User!
    
    // properties
    var posts = [Post]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpUI()
        
        
        manager.getCurrentUser { (user, error) -> () in
            if let error = error {
                print(__FUNCTION__,error)
            }
            guard let user = user else { return }
            self.user = user
            self.getPostsOfFollowings()
            self.manager.checkIfInAllUsers()
        }
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
                self.getPostsForFollowedUser(followedUser)
            }
        }
    }
    
    
    func getPostsForFollowedUser(followedUser: User ) {
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
        let post = posts[indexPath.row]

        cell.delegate = self
        
        cell.userFullNameLabel.text = post.posterName
        cell.postImageView.image = post.image
        cell.descriptionLabel.text = post.description
        //        cell.friendsCommentsLabel.text = post.comments
        //        cell.avatarImageView.image = post.avatarImage
        
        var likersText = ""
        for liker in post.likersAliases {
            likersText.appendContentsOf(liker)
            likersText.appendContentsOf(", ")
        }
        var commentsText = ""
        for comment in post.commentStrings {
            commentsText = commentsText + "\n" + comment
        }
        print(commentsText)
        cell.likesLabel.text = likersText
        cell.friendsCommentsLabel.text = commentsText

        let avatarImageToBeRounded = post.image!
        
        cell.postImageView.image = maskRoundedImage(avatarImageToBeRounded, radius: 0)
        cell.userFullNameLabel.text = post.posterName
       
        return cell
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    

    func tableView(tableView: UITableView, shouldHighlightRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }
}

