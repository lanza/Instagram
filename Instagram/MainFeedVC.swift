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
        manager.getCurrentUser { (user, error) -> () in
            if let error = error {
                print(__FUNCTION__,error)
            }
            guard let user = user else { return }
            self.user = user
            self.getPosts()
        }
    }
    
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
        cell.imageView.image = UIImage(named: "placeholder")
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
}
