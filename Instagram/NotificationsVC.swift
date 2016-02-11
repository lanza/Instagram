import UIKit

class NotificationsVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // CloudKit
    let manager = CloudManager.sharedManager
    var user: User!
    
    // shows a list of notifications
    @IBOutlet weak var tableView: UITableView!
    
    var likesAndComments = [RecordToClassProtocol]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        CloudManager.sharedManager.getLikesForUser(CloudManager.sharedManager.currentUser) { (likes, error) -> () in
            if let error = error {
                print(error)
            }
            guard let likes = likes else { return }
            for like in likes {
                self.likesAndComments.append(like)
            }
            self.tableView.reloadData()
        }
        CloudManager.sharedManager.getCommentsForUser(CloudManager.sharedManager.currentUser) { (comments, error) -> () in
            if let error = error {
                print(error)
            }
            guard let comments = comments else { return }
            for comment in comments {
                self.likesAndComments.append(comment)
            }
            self.tableView.reloadData()
            print(self.likesAndComments)
        }
        
        // set badge to # of objects in data array
        self.updateTabBadge("\(likesAndComments.count)")
        
        
        setUpUI()
    }
    
    
    // MARK: - Table view data source
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell")! as UITableViewCell
        
        let likeOrComment = likesAndComments[indexPath.row]
        var text = ""
        if let like = likeOrComment as? Like {
            text = "Such and such liked your post"
        } else if let comment = likeOrComment as? Comment {
            text = "Such and such commented on your post"
        }
        cell.textLabel?.text = text
        
        //cell.imageView?.image = UIImage(named: "user")
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return likesAndComments.count
    }
    
    func updateTabBadge(value: String) {
        
        (tabBarController!.tabBar.items![3]).badgeValue = value
    }
    
}
