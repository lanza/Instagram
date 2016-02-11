//
//  CommentViewController.swift
//  Instagram
//
//  Created by Nicholas Naudé on 10/02/2016.
//  Copyright © 2016 Nathan Lanza. All rights reserved.
//

import UIKit

class CommentViewController: UIViewController {
    
    @IBOutlet weak var commentTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onSaveButtonTapped(sender: UIBarButtonItem) {
    }

    @IBAction func onCancelButtonTapped(sender: UIBarButtonItem) {
    }
}
