import UIKit

protocol DisplaysAlerts {
    func presentViewController(viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)?)
    
    func displayAlert(withTitle title: String, andMessage message: String)
}

extension DisplaysAlerts {
    func displayAlert(withTitle title: String, andMessage message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        let action = UIAlertAction(title: "Okay", style: .Destructive, handler: nil)
        alertController.addAction(action)
        self.presentViewController(alertController, animated: true, completion: nil)
    }    
}