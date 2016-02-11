import UIKit
import CloudKit

extension CloudManager {
    
    func postImage(imageURL: NSURL, description: String) {
        let post = Post(withImageURL: imageURL, andDescription: description, andPoster: currentUser)
        post.saveRecord(inDatabase: publicDatabase) { () -> () in
            print("new post saved to database")
        }
    }
    
    func addLike(toPost post: Post) {
        let like = Like(withLiker: currentUser, andPost: post)
        like.saveRecord(inDatabase: publicDatabase) { () -> () in
            print("new like saved")
        }
    }
    func addComment(comment: String, toPost post: Post) {
        let comment = Comment(withComment: comment, andCommenter: currentUser, andPost: post)
        comment.saveRecord(inDatabase: publicDatabase) { () -> () in
            print("new comment saved")
        }
    }
}
