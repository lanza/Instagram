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
        
        
        //        collectionView.delegate = self
        let placeHolderImage = NSURL(fileURLWithPath: "http://www.yosemitepark.com/Images/home-img-01.jpg")
        let placeHolder = Post(withImageURL: placeHolderImage, andDescription: "This is a great picture!")
        posts = [placeHolder]
        
        manager.getCurrentUser { (user, error) -> () in
            if let error = error {
                print(__FUNCTION__,error)
            }
            guard let user = user else { return }
            self.user = user
            self.getPosts()
        }
    }
    
    
    //Use for interspacing
    func collectionView(collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
            return 1.0
    }
    
    
    func collectionView(collectionView: UICollectionView, layout
        collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
            return 1.0
    }
    
    
    // MARK: – Process posts.
    
    func getPosts() {
        manager.getPostsForUser(user) { (posts, error) -> () in
            if let error = error {
                print(__FUNCTION__,error)
            }
            guard let posts = posts else { return }
            self.posts = posts
            NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                self.collectionView.reloadData()
            })
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
