//
//  OnboardingFriendsTVC.swift
//  Instagram
//
//  Created by Nicholas Naudé on 10/02/2016.
//  Copyright © 2016 Nathan Lanza. All rights reserved.
//

import UIKit

class OnboardingFriendsTVC: UIViewController {
    
    @IBOutlet weak var friendsTableView: UITableView!
    
    var tempFriendsArray = ["Nathan", "Nicholas", "Steve", "Susan", "Mike", "Evgeny"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tempFriendsArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        
        cell.textLabel!.text = self.tempFriendsArray[indexPath.row]
        
        return cell
    }
    
    @IBAction func onCancelTapped(sender: UIButton)
    {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
}
