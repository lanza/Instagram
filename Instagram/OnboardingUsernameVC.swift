import UIKit

class OnboardingUsernameVC: UIViewController {
    
    @IBOutlet weak var usernameLoginTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func onLoginButtonTapped(sender: UIButton) {
        
        guard let aliasText = usernameLoginTextField.text else { return }
        
        CloudManager.sharedManager.currentUser?.alias = aliasText
        CloudManager.sharedManager.currentUser?.saveRecord(inDatabase: CloudManager.sharedManager.publicDatabase) {
            NSOperationQueue.mainQueue().addOperationWithBlock {
                self.performSegueWithIdentifier("onboardingProfilePicSegue", sender: nil)
            }
        }
        
    }
}
