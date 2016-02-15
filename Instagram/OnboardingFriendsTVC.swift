import UIKit
import CloudKit

class OnboardingFriendsTVC: UIViewController {
    
    @IBOutlet weak var friendsTableView: UITableView!
    
    var tempFriendsArray = ["Nathan", "Nicholas", "Steve", "Susan", "Mike", "Evgeny"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpUI()
        }
    
    
    @IBAction func onDoneTapped(sender: UIBarButtonItem) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let tbc = storyboard.instantiateInitialViewController() as! UITabBarController
        presentViewController(tbc, animated: true, completion: nil)
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setBool(true, forKey: "didOnboard")
    }
    
    func subscribeToSelf() {
        let userRecord = CloudManager.sharedManager.currentUser.record
        let reference = CKReference(record: userRecord, action: .None)
        let predicate = NSPredicate(format: "Poster == %@", reference)
        
        let subscription = CKSubscription(recordType: "Post", predicate: predicate, options: CKSubscriptionOptions.FiresOnRecordCreation)
        CloudManager.sharedManager.publicDatabase.saveSubscription(subscription) { (subscription, error) in
            if let error = error {
                print(error)
            }
        }
    }
    
 
    // MARK: - Table view data source
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tempFriendsArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        
        cell.textLabel!.text = self.tempFriendsArray[indexPath.row]
        
        return cell
    }
    
    @IBAction func onCancelTapped(sender: UIButton)
    {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
}
