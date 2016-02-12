import UIKit
import CloudKit

class OnboardingProfilePicVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    let imagePickerController = UIImagePickerController()
    var usersImage: UIImage!
    var imageURL: NSURL?
    
    @IBOutlet weak var profilePictureImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true

        profilePictureImageView.layer.cornerRadius = 67.0
        profilePictureImageView.clipsToBounds = true
        
    }
    
    @IBAction func onSetPictureTapped(sender: UIButton) {
        imagePickerController.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        presentViewController(imagePickerController, animated: true, completion: nil)
    }
    
    
    @IBAction func onCameraButtonTapped(sender: UIButton) {
        imagePickerController.sourceType = UIImagePickerControllerSourceType.Camera
        presentViewController(imagePickerController, animated: true, completion: nil)
    }
    
    //connect
    @IBAction func onContinueButtonTapped(sender: UIButton) {
        guard let imageURL = imageURL else { return }
        let asset = CKAsset(fileURL: imageURL)
        
        CloudManager.sharedManager.currentUser.record.setObject(asset, forKey: "Avatar")
        CloudManager.sharedManager.currentUser.saveRecord(inDatabase: CloudManager.sharedManager.publicDatabase) {
            NSOperationQueue.mainQueue().addOperationWithBlock {
                self.performSegueWithIdentifier("showFriendsSegue", sender: nil)
            }
        }
    }
    
    //
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let pickedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            
            self.usersImage = pickedImage
            
            let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
            let path = paths[0] as NSString
            let pathString = path.stringByAppendingPathComponent("cached.png")
            
            var dataFormat = UIImageJPEGRepresentation(pickedImage, 1.0)
            if dataFormat == nil {
                dataFormat = UIImagePNGRepresentation(pickedImage)
            }
            dataFormat?.writeToFile(pathString, atomically: true)
            
            self.imageURL = NSURL(fileURLWithPath: pathString)
            picker.dismissViewControllerAnimated(true, completion: nil)
            
            profilePictureImageView.image = usersImage
        }
    }
    
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    //
    
}