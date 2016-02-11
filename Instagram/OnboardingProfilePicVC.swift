//
//  OnboardingProfilePicVC.swift
//  Instagram
//
//  Created by Nicholas Naudé on 10/02/2016.
//  Copyright © 2016 Nathan Lanza. All rights reserved.
//

import UIKit

class OnboardingProfilePicVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    let imagePickerController = UIImagePickerController()
    var usersImage: UIImage!
    var imageURL: NSURL?
    
    @IBOutlet weak var profilePictureImageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()

        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
    }

    @IBAction func onSetPictureTapped(sender: UIButton) {
        imagePickerController.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        presentViewController(imagePickerController, animated: true, completion: nil)
    }

    @IBAction func onSkipTapped(sender: UIButton) {
    }

    @IBAction func onCameraButtonTapped(sender: UIButton) {
        imagePickerController.sourceType = UIImagePickerControllerSourceType.Camera
        presentViewController(imagePickerController, animated: true, completion: nil)
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
// segue to ComposeVC
// self.performSegueWithIdentifier("composeSegue", sender: nil)
        }
    }
    
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    //
    
}