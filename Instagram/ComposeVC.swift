import UIKit

class ComposeVC: UIViewController {
    
    // storyboard connections
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var addTextButton: UIButton!

    // properties
    var usersImage: UIImage?
    var imageURL: NSURL?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        imageView.image = usersImage
        
        textView.hidden = true
        
        cancelButton.tintColor = UIColor.whiteColor()
        shareButton.tintColor = UIColor.whiteColor()
        addTextButton.tintColor = UIColor.instagramColor()

        self.navBar.barTintColor = UIColor.instagramColor()
        
    }
    
    @IBAction func onAddTextButtonTapped(sender: AnyObject) {
        
        textView.hidden = false
        textView.becomeFirstResponder()
        
    }
    
    @IBAction func onShareTapped(sender: AnyObject) {
        
        guard let imageURL = imageURL else { return }
        if let text = textView.text {
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