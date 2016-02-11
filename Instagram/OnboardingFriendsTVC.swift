import UIKit

class OnboardingFriendsTVC: UIViewController {
    
    @IBOutlet weak var friendsTableView: UITableView!
    
    var tempFriendsArray = ["Nathan", "Nicholas", "Steve", "Susan", "Mike", "Evgeny"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let height = UIScreen.mainScreen().bounds.height
        let width = UIScreen.mainScreen().bounds.width
        
        let frame = CGRectMake(width/2 - 15, height - 100, 100, 30)
        let continueButton = UIButton(frame: frame)
        continueButton.addTarget(self, action: "onContinueButtonTapped:", forControlEvents: .TouchUpInside)
        continueButton.setTitle("Continue", forState: .Normal)
        continueButton.setTitleColor(UIColor.blueColor(), forState: .Normal)
        self.view.addSubview(continueButton)
        print("HI")
    }
    
    @IBAction func onContinueButtonTapped(sender: UIButton) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let tbc = storyboard.instantiateInitialViewController() as! UITabBarController
        presentViewController(tbc, animated: true, completion: nil)
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setBool(true, forKey: "didOnboard")
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
