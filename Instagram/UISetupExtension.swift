import UIKit

extension UIViewController {
    
    func setUpUI() {
        
        // set top navigation bar color:
        navigationController?.navigationBar.barTintColor = UIColor.instagramColor()
        
        //add the Instagram logo:
        let titleView = UIImageView(frame:CGRectMake(0, 0, 15, 35))
        titleView.contentMode = .ScaleAspectFit
        titleView.image = UIImage(named: "Instagram_logo")
        print("HI")
        
        navigationItem.titleView = titleView
        
        self.tabBarController?.tabBar.tintColor = UIColor.instagramTabBarIconGray()
        self.tabBarController?.tabBar.barTintColor = UIColor.instagramTabBarLightGray()
//        self.tabBarController?.tabBar.selectedItem = UIColor.instagramTabBarSelected()
    }
}
