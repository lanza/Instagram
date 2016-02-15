import UIKit

class CommentVC: UIViewController {
    
    var post: Post!
    
    @IBOutlet weak var commentField: UITextField!
    
    override func viewDidLoad() {
        setUpUI()
    }
    
    func saveComment(commentString: String) {
        post.commentStrings.append(commentString)
        CloudManager.sharedManager.addComment(commentString, toPost: post)
        post.saveRecord(inDatabase: CloudManager.sharedManager.publicDatabase) { () -> () in
            print("comment added to post")
        }
    }
    
    @IBAction func onSaveButtonTapped(sender: UIBarButtonItem) {
        guard let commentText = commentField.text else { return }
        saveComment(commentText)
        let nvc = self.navigationController
        nvc?.popViewControllerAnimated(true)
    }
    
    
    @IBAction func onCancelButtonTapped(sender: UIBarButtonItem) {
        let nvc = self.navigationController
        nvc?.popViewControllerAnimated(true)
    }
}
