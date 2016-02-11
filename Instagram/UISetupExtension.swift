import UIKit

extension UIViewController {
    
    func setUpUI() {
        // set myInstagram
        navigationController?.navigationBar.barTintColor = UIColor.instagramColor()
        
        //navigationController?.setNavigationBarHidden(true, animated: true)
        //navigationController?.interactivePopGestureRecognizer!.delegate = self
        
        //add the Instagram logo:
        let titleView = UIImageView(frame:CGRectMake(0, 0, 15, 35))
        titleView.contentMode = .ScaleAspectFit
        titleView.image = UIImage(named: "Instagram_logo")
        print("HI")
        
        navigationItem.titleView = titleView
        
        //navigationController?.setNavigationBarHidden(true, animated: true)
    }
}