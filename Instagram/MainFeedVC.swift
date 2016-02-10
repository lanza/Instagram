import UIKit

class MainFeedVC: UIViewController, UITableViewDelegate, UITableViewDataSource, ChecksError {
    
    let manager = CloudManager.sharedManager
    var user: User!
    
    
    // storyboard outlets
    @IBOutlet weak var collectionView: UICollectionView!
    
    // properties
    var posts = [Post]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set the navbar image and color:
        let logo = UIImage(named: "Instagram_logo")
        let navImageView = UIImageView(image:logo)
        self.navigationItem.titleView = navImageView
        navImageView.frame = CGRectMake(0, 0, 50, 30)
        
        // set myInstagram
        let instagramColor = UIColor(
            red:0.165,
            green:0.357,
            blue:0.514,
            alpha:1.0)
        
        navigationController!.navigationBar.barTintColor = instagramColor
        
        manager.getCurrentUser { (user, error) -> () in
            if let error = error {
                print(__FUNCTION__,error)
            }
            guard let user = user else { return }
            self.user = user
            self.getPostsOfFollowings()
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
                self.collectionView.reloadData()
                print(self.posts)
            }
        }
    }
    
    
    // MARK: - TableView delegate methods
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell")!
        return cell
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
}
