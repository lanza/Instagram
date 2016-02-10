import UIKit

class SearchVC: UIViewController, UISearchResultsUpdating {

    @IBOutlet weak var tableView: UITableView!
    
    // these arrays will need to hold Post objects
    let tableData = ["Bob Smith", "Jane Benson", "Marcus Peters"] // dummy data for testing
    var filteredTableData = [String]()
    var resultSearchController = UISearchController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
        filteredTableData.removeAll(keepCapacity: false)
        let searchPredicate = NSPredicate(format: "SELF CONTAINS[c] %@", searchController.searchBar.text!)
        
        let array = (tableData as NSArray).filteredArrayUsingPredicate(searchPredicate)
        filteredTableData = array as! [String]
        
        self.tableView.reloadData()
    }
    

    // MARK: - Table view data source
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // if filter applied, re-calculate # of rows
        if (self.resultSearchController.active) { return self.filteredTableData.count }
            
        else { return self.tableData.count }
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        // using a generic cell to list user names
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        
        // if SearchController is active, show filtered data
        if (self.resultSearchController.active) {
            
            cell.textLabel?.text = filteredTableData[indexPath.row]
            cell.detailTextLabel?.text = "User's Handle"
            
            return cell
        } else {
            
            cell.textLabel?.text = tableData[indexPath.row]
            cell.detailTextLabel?.text = "User's Handle"
            
            return cell
        }
        
    }


}
