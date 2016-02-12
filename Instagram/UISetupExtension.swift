import UIKit

extension UIViewController {
    
    func setUpUI() {
        
        // set top navigation bar color:
        navigationController?.navigationBar.barTintColor = UIColor.instagramColor()
        
        //add the Instagram logo:
        let titleView = UIImageView(frame:CGRectMake(0, 0, 15, 35))
        titleView.contentMode = .ScaleAspectFit
        titleView.image = UIImage(named: "Instagram_logo")
        
        navigationItem.titleView = titleView
        
        self.tabBarController?.tabBar.tintColor = UIColor.whiteColor()
        
        self.tabBarController?.tabBar.barTintColor = UIColor.instagramTabBarLightGray()
        
        //
        navigationController?.navigationBar.barStyle = UIBarStyle.Black
        navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        
        
        
        // Set Navigation bar background image
        //        let navBgImage:UIImage = UIImage(named: "Nathan")!
        //        UINavigationBar.appearance().setBackgroundImage(navBgImage, forBarMetrics: .Default)
        
        
        //        self.tabBarController!.tabBar.selectedImageTintColor = UIColor.redColor()
        
        //        self.tabBarController?.tabBar.selectedItem = UIColor.instagramTabBarSelected()
    }
}
