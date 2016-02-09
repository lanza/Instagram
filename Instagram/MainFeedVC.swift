import UIKit

class MainFeedVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, ChecksError {
    
    let manager = CloudManager.sharedManager
    var user: User!
    
    
    // storyboard outlets
    @IBOutlet weak var collectionView: UICollectionView!
    
    // properties
    var posts = [Post]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        
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
    
    // MARK: – Set the collectionView size:
    
    //Use for size
    func collectionView(collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
            var size = CGSize(width: 200, height: 100)
            return size
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
    
    // MARK: - CollectionView delegate methods
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as! PostCollectionViewCell
        let post = posts[indexPath.row]
        print(post.posterName)
        cell.imageView.image = post.image
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
}
