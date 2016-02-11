import UIKit

protocol CommentVCProtocol {
    func commentVC(commentVC: CommentViewController, saveButtonTapped: UIButton)
}

class CommentViewController: UIViewController {
    
    var delegate: CommentVCProtocol!
    
    @IBOutlet weak var commentTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }

    func saveComment() {
        guard let indexPath = tableVieew.indexPathForCell(feedCell) else {
            print("\(__FUNCTION__) could not get indexPath")
            return
        }
        let commentString = "No comment yet"
        let post = posts[indexPath.row]
        post.commentStrings.append(commentString)
        manager.addComment("No comment yet", toPost: post)
        post.saveRecord(inDatabase: manager.publicDatabase) { () -> () in
            print("comment added to post")
        }
        tableVieew.reloadData()
    }
    
    @IBAction func onSaveButtonTapped(sender: UIBarButtonItem) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func onCancelButtonTapped(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
