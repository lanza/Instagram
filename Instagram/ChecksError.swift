import UIKit

protocol ChecksError {
    func checkError(error: ErrorType?)
}

extension ChecksError {
    func checkError(error: ErrorType?) {
        if let error = error {
            print("\(__FUNCTION__) had error: \(error)")
        }
    }
}