import UIKit
import CloudKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        appLaunch()
        
        let notificationSettings = UIUserNotificationSettings(forTypes: [.Alert, .Sound], categories: nil)
        application.registerUserNotificationSettings(notificationSettings)
        application.registerForRemoteNotifications()
        
        return true
    }
    

    
    func appLaunch() {
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        
        CloudManager.sharedManager.currentlyGettingFeedPosts = false
        
        let defaults = NSUserDefaults.standardUserDefaults()
        if defaults.boolForKey("didOnboard") == true {
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let tbc = storyBoard.instantiateInitialViewController() as! UITabBarController
            self.window!.rootViewController = tbc
        } else {
            let storyBoard = UIStoryboard(name: "Onboarding", bundle: nil)
            let nc = storyBoard.instantiateInitialViewController() as! UINavigationController
            self.window!.rootViewController = nc
        }
        self.window!.makeKeyAndVisible()
    }
    
    func applicationWillResignActive(application: UIApplication) {    }
    func applicationDidEnterBackground(application: UIApplication) {    }
    func applicationWillEnterForeground(application: UIApplication) {    }
    func applicationDidBecomeActive(application: UIApplication) {    }
    func applicationWillTerminate(application: UIApplication) {    }
    
    
    
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        print("did register for remote notifications")
    }
    
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject], fetchCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {
        
        guard let userInfo = userInfo as? [String: NSObject] else { print("failed to convert userInfo"); return }
        let notification = CKQueryNotification(fromRemoteNotificationDictionary: userInfo)
        if notification.queryNotificationReason == .RecordCreated {
            CloudManager.sharedManager.publicDatabase.fetchRecordWithID(notification.recordID!) { (record, error) -> Void in
                guard let record = record else { print("record not record"); return }
                NSOperationQueue.mainQueue().addOperationWithBlock{ () -> Void in
                    CloudManager.sharedManager.delegate?.cloudManager(CloudManager.sharedManager, gotFeedPost: Post(fromRecord: record))
                }
            }
        }        
    }
}

