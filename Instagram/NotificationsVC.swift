import UIKit

class NotificationsVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    // shows a list of notifications
    @IBOutlet weak var tableView: UITableView!
    
    var notificationsArray = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        notificationsArray = ["Susan Smith liked your photo", "Jane Peters followed you", "Bob Mansfield liked your photo"]
    }
    
    
    // MARK: - Table view data source
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell")! as UITableViewCell
        
        cell.textLabel?.text = notificationsArray[indexPath.row]
        
        // let imageView = UIImageView.init(frame: CGRectMake(0, 0, 30, 30))
        // imageView.image = UIImage(named: "user")
        // cell.contentView.addSubview(imageView)
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return notificationsArray.count
    }
    

}
