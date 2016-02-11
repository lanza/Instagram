import UIKit

class ProfileVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, CloudManagerDelegate {
    
    // CloudKit
    let manager = CloudManager.sharedManager
    var posts = [Post]()
    
    // storyboard
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var postsNumberLabel: UILabel!
    @IBOutlet weak var followersNumberLabel: UILabel!
    @IBOutlet weak var followingNumberLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getPosts()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        setUpUI()
        
        // store iCloud user in local property
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        CloudManager.sharedManager.delegate = self
        getPosts()
        
    }
    
    func getPosts() {
        self.posts = []
        manager.getPostsForCurrentUser(withCompletionHandler: nil)
    }
    
    // MARK: - UICollectionViewDataSource protocol
    
    // tell the collection view how many cells to make
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.posts.count
    }
    
    // make a cell for each cell index path
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        // get a reference to our storyboard cell
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as! ProfileVCCell
        let post = posts[indexPath.row]
        // Use the outlet in our custom class to get a reference to the UILabel in the cell
        cell.backgroundColor = UIColor.greenColor()
        cell.imageView.image = post.image
        
        //        cell.layer.borderWidth = 0    
        
        return cell
    }
    
    // MARK: - UICollectionViewDelegate protocol
    
    override func viewWillLayoutSubviews() {
        
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let post = posts[indexPath.row]
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let feedVC = storyboard.instantiateViewControllerWithIdentifier("FeedVC") as! FeedVC
        feedVC.singlePost = post
        self.navigationController?.pushViewController(feedVC, animated: true)        
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(0, 0, 0, 0)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        let itemsCount : CGFloat = 3.0
        let width : CGFloat = self.view.frame.size.width / itemsCount - 1
        
        return CGSize(width: width, height: width)
    }
    
    func cloudManager(cloudManager: CloudManager, gotFollowings followings: [User]?) {}
    func cloudManager(cloudManager: CloudManager, gotAllUsers allUsers: [User]?) {}
    func cloudManager(cloudManager: CloudManager, gotFeedPost post: Post?) {}
    func cloudManager(cloudManager: CloudManager, gotCurrentUserPost post: Post?) {
        guard let post = post else { return }
        self.posts.append(post)
        NSOperationQueue.mainQueue().addOperationWithBlock {
            self.collectionView.reloadData()
        }
    }
    
}
