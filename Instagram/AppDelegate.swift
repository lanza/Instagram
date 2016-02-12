import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)        
        
        let defaults = NSUserDefaults.standardUserDefaults()
        if defaults.boolForKey("didOnboard") == true {
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let tbc = storyBoard.instantiateInitialViewController() as! UITabBarController
            self.window!.rootViewController = tbc
        } else {
            let storyBoard = UIStoryboard(name: "Onboarding", bundle: nil)
            let ouvc = storyBoard.instantiateViewControllerWithIdentifier("OnboardingVC")
            self.window!.rootViewController = ouvc
        }
        self.window!.makeKeyAndVisible()
        return true
    }

    func applicationWillResignActive(application: UIApplication) {    }
    func applicationDidEnterBackground(application: UIApplication) {    }
    func applicationWillEnterForeground(application: UIApplication) {    }
    func applicationDidBecomeActive(application: UIApplication) {    }
    func applicationWillTerminate(application: UIApplication) {    }
}

