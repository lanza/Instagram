import UIKit

class ComposeVC: UIViewController {

    // show the image chosen or taken
    @IBOutlet weak var imageView: UIImageView!
    
    var usersImage: UIImage?
    var imageURL: NSURL?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        imageView.image = usersImage        
    }

    @IBAction func onShareTapped(sender: AnyObject) {
        
        guard let imageURL = imageURL else { return }
        CloudManager.sharedManager.postImage(imageURL, description: "Something something darkside")
        
    }
    
    @IBAction func onCancelTapped(sender: AnyObject) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
}
