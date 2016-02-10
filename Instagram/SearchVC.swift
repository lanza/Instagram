import UIKit

class SearchVC: UIViewController, UISearchResultsUpdating {

    @IBOutlet weak var tableView: UITableView!
    
    // these arrays will need to hold Post objects
    var users = [User]()
    var filteredUsers = [User]()
    var resultSearchController = UISearchController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        CloudManager.sharedManager.getAllUsers(NSPredicate(value: true)) { (users, error) -> () in
            if let error = error {
                print(error)
            }
            print("TEST")
            guard let users = users else { return }
            print("TEST2")
            self.users = users
            self.tableView.reloadData()
        }
        
        setUpUI()
        
        // set up SearchController
        self.resultSearchController = ({
            let controller = UISearchController(searchResultsController: nil)
            controller.searchResultsUpdater = self
            controller.dimsBackgroundDuringPresentation = false
            controller.searchBar.sizeToFit()
            
            self.tableView.tableHeaderView = controller.searchBar
            
            return controller
        })()
        
    }

    func updateSearchResultsForSearchController(searchController: UISearchController) {
        
        filteredUsers.removeAll(keepCapacity: false)
        
        filteredUsers = users.filter { (user) -> Bool in
            guard let searchText = searchController.searchBar.text else { return true }
            if user.alias.containsString(searchText) {
                return true
            } else {
                return false
            }
        }
        

        self.tableView.reloadData()
    }
    

    // MARK: - Table view data source
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // if filter applied, re-calculate # of rows
        if (self.resultSearchController.active) { return self.filteredUsers.count }
            
        else { return self.users.count }
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        if (self.resultSearchController.active) {
            let user = filteredUsers[indexPath.row]
            cell.textLabel?.text = user.alias
            cell.detailTextLabel?.text = "Something goes here."
            return cell
        } else {
            let user = users[indexPath.row]
            cell.textLabel?.text = user.alias
            cell.detailTextLabel?.text = "something goes here."
            return cell
        }
    }
}
