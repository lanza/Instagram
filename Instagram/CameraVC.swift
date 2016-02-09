import UIKit

class CameraVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let imagePicker = UIImagePickerController()
    var usersImage: UIImage!
    var imageURL: NSURL?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
    }
    
    @IBAction func onTakePhotoButtonTapped(sender: AnyObject) {

        imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
        presentViewController(imagePicker, animated: true, completion: nil)
    }

    @IBAction func onChoosePhotoButtonTapped(sender: AnyObject) {
        
        imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    

    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        if let pickedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            
            self.usersImage = pickedImage
            self.imageURL = info[UIImagePickerControllerMediaURL] as? NSURL
            picker.dismissViewControllerAnimated(true, completion: nil)
            
            // segue to ComposeVC
            self.performSegueWithIdentifier("ShowComposeVC", sender: nil)
        }
    }

    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        
        picker.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        let destination = segue.destinationViewController as! ComposeVC
        destination.usersImage = self.usersImage
        destination.imageURL = self.imageURL
    }
    
}
