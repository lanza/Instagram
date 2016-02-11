import UIKit

class CommentVC: UIViewController {
    
    var post: Post!
    
    
    @IBOutlet weak var commentTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    func saveComment(commentString: String) {
        post.commentStrings.append(commentString)
        CloudManager.sharedManager.addComment(commentString, toPost: post)
        post.saveRecord(inDatabase: CloudManager.sharedManager.publicDatabase) { () -> () in
            print("comment added to post")
        }
     }
    
    @IBAction func onSaveButtonTapped(sender: UIBarButtonItem) {
        guard let commentText = commentTextView.text else { return }
        saveComment(commentText)
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func onCancelButtonTapped(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
