import UIKit

class ComposeVC: UIViewController {
    
    // storyboard connections
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var addTextButton: UIButton!
    @IBOutlet var textField: UITextField!

    // properties
    var usersImage: UIImage?
    var imageURL: NSURL?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        imageView.image = usersImage
        
        textField.hidden = true
        
        cancelButton.tintColor = UIColor.whiteColor()
        shareButton.tintColor = UIColor.whiteColor()
        addTextButton.tintColor = UIColor.instagramColor()

        self.navBar.barTintColor = UIColor.instagramColor()
        
        
        
    }
    
    @IBAction func onAddTextButtonTapped(sender: AnyObject) {
        
        textField.hidden = false
        textField.becomeFirstResponder()
        
    }
    
    @IBAction func onShareTapped(sender: AnyObject) {
        
        guard let imageURL = imageURL else { return }
        if let text = textField.text {
            CloudManager.sharedManager.postImage(imageURL, description: text)
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    
    @IBAction func onCancelTapped(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)
        UIApplication.sharedApplication().setStatusBarHidden(true, withAnimation: UIStatusBarAnimation.None)
    }
    
    override func viewWillDisappear(animated: Bool) {
        
        super.viewWillDisappear(animated)
        UIApplication.sharedApplication().setStatusBarHidden(false, withAnimation: UIStatusBarAnimation.None)
    }
    
}