import UIKit

extension UIViewController {
    
    func setUpUI() {
        // set myInstagram
        navigationController!.navigationBar.barTintColor = UIColor.instagramColor()
        
//        navigationController?.setNavigationBarHidden(true, animated: true)
        //        navigationController?.interactivePopGestureRecognizer!.delegate = self
        
        // add the Instagram logo:
        var titleView : UIImageView
        titleView = UIImageView(frame:CGRectMake(0, 0, 15, 35))
        titleView.contentMode = .ScaleAspectFit
        titleView.image = UIImage(named: "Instagram_logo")
        self.navigationItem.titleView = titleView
//        navigationController?.setNavigationBarHidden(true, animated: true)
    }
}