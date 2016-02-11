import UIKit

class ComposeVC: UIViewController {
    
    // show the image chosen or taken
    @IBOutlet weak var imageView: UIImageView!
    
    //WARNING NICK CHANGE THIS... WHY? – Nicholas
    @IBOutlet var textFieldNickChangeThis: UITextView!
    
    
    var usersImage: UIImage?
    var imageURL: NSURL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        imageView.image = usersImage
    }
    
    
    @IBAction func onShareTapped(sender: AnyObject) {
        
        guard let imageURL = imageURL else { return }
        if let text = textFieldNickChangeThis.text {
            CloudManager.sharedManager.postImage(imageURL, description: text)
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    
    @IBAction func onCancelTapped(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // resign first responder:
    func textFieldShouldReturn(textField: UITextField!) -> Bool // called when 'return' key pressed. return NO to ignore.
    {
        textField.resignFirstResponder()
        return true;
    }    //
    
    
}