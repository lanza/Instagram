import UIKit

class NotificationsVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    // shows a list of notifications
    @IBOutlet weak var tableView: UITableView!
    
    var notificationsArray = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpUI()

        notificationsArray = ["Susan Smith liked your photo", "Jane Peters followed you", "Bob Mansfield liked your photo"]
        
        // set badge to # of objects in data array
        self.updateTabBadge("\(notificationsArray.count)")
    }
    
    
    
    // MARK: - Table view data source
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell")! as UITableViewCell
        
        cell.textLabel?.text = notificationsArray[indexPath.row]
        
        cell.imageView?.image = UIImage(named: "user")
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return notificationsArray.count
    }
    
    func updateTabBadge(value: String) {
        
        (tabBarController!.tabBar.items![3]).badgeValue = value
    }

}
