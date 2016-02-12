import UIKit
import CloudKit

class NotificationsVC: UIViewController, UITableViewDelegate, UITableViewDataSource, CloudManagerDelegate {
    
    // CloudKit
    let manager = CloudManager.sharedManager
    var user: User!
    
    // shows a list of notifications
    @IBOutlet weak var tableView: UITableView!
    
    var likesAndComments = [RecordToClassProtocol]()
    var likes = [Like]()
    var comments = [Comment]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // set badge to # of objects in data array
        self.updateTabBadge("\(likesAndComments.count)")
        setUpUI()
    }
    
    
    
    var currentlyWaitingForGetLikesToReturn: Bool = false {
        didSet (new) {
        if new == false {
            for like in likes {
                likesAndComments.append(like)
            }
        }
        }
    }
    
    var currentlyWaitingForGetCommentsToReturn: Bool = false {
        didSet (new) {
        if new == false {
            for comment in comments {
                self.likesAndComments.append(comment)
            }
        }
        }
    }
    
    var currentlyWaitingForEitherToReturn: Bool {
        get { return currentlyWaitingForGetCommentsToReturn || currentlyWaitingForGetLikesToReturn }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        CloudManager.sharedManager.delegate = self
        getLikesAndComments()
    }
    
    func getLikesAndComments() {
        if !currentlyWaitingForEitherToReturn {
            self.likesAndComments = []
        }
        if !currentlyWaitingForGetLikesToReturn {
            likes = []
            self.currentlyWaitingForGetLikesToReturn = true
            CloudManager.sharedManager.getLikesForUser(CloudManager.sharedManager.currentUser) { (likes, error) -> () in
                if let error = error {
                    print(error)
                }
                guard let likes = likes else { return }
                for like in likes {
                    self.likesAndComments.append(like)
                }
                NSOperationQueue.mainQueue().addOperationWithBlock{ () -> Void in
                    self.tableView.reloadData()
                    self.currentlyWaitingForGetCommentsToReturn = false
                }
            }
        }
        if !currentlyWaitingForGetCommentsToReturn {
            comments = []
            self.currentlyWaitingForGetCommentsToReturn = true
            CloudManager.sharedManager.getCommentsForUser(CloudManager.sharedManager.currentUser) { (comments, error) -> () in
                if let error = error {
                    print(error)
                }
                guard let comments = comments else { return }
                for comment in comments {
                    self.likesAndComments.append(comment)
                }
                NSOperationQueue.mainQueue().addOperationWithBlock{ () -> Void in
                    self.tableView.reloadData()
                    self.currentlyWaitingForGetLikesToReturn = false
                }
            }
        }
    }
    
    //MARK: - Table view delegate
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let likeOrComment = likesAndComments[indexPath.row]
        let postReference = likeOrComment.record.objectForKey("Post") as! CKReference
        let postRecord = postReference.recordID
        
        CloudManager.sharedManager.publicDatabase.fetchRecordWithID(postRecord) { (record, error) -> Void in
            if let error = error {
                print(error)
            }
            guard let record = record else { return }
            let post = Post(fromRecord: record)
            
            NSOperationQueue.mainQueue().addOperationWithBlock { () -> Void in
                
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let feedVC = storyboard.instantiateViewControllerWithIdentifier("FeedVC") as! FeedVC
                feedVC.singlePost = post
                self.navigationController?.pushViewController(feedVC, animated: true)
            }
        }
    }
    
    
    // MARK: - Table view data source
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell")! as UITableViewCell
        
        let likeOrComment = likesAndComments[indexPath.row]
        var text = ""
        if let like = likeOrComment as? Like {
            text = "\(like.likerAlias) liked your post"
        } else if let comment = likeOrComment as? Comment {
            text = "\(comment.commenterAlias) commented on your post"
        }
        cell.textLabel?.text = text
        
        //cell.imageView?.image = UIImage(named: "user")
        
        cell.textLabel?.numberOfLines = 0
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return likesAndComments.count
    }
    
    func updateTabBadge(value: String) {
        (tabBarController!.tabBar.items![3]).badgeValue = value
    }
    
    func cloudManager(cloudManager: CloudManager, gotCurrentUser currentUser: User?) {}
    func cloudManager(cloudManager: CloudManager, gotFollowings followings: [User]?) {
        getLikesAndComments()
    }
    func cloudManager(cloudManager: CloudManager, gotAllUsers allUsers: [User]?) {}
    func cloudManager(cloudManager: CloudManager, gotFeedPost post: Post?) {}
    func cloudManager(cloudManager: CloudManager, gotCurrentUserPost post: Post?) {}
}
