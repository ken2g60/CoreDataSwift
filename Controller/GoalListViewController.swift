//
//  GoalUIViewController.swift
//  LifeGoals
//
//  Created by knight on 9/28/20.
//

import UIKit
import CoreData

class GoalListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate, UISearchResultsUpdating {
  
    

    @IBOutlet weak var tableView: UITableView!
    var goals: [GoalsMO] = []
    var searchResults: [GoalsMO] = []
    
    // searchbar
    var searchController: UISearchController!
    
    // fetchresult
    var fetchResultController: NSFetchedResultsController<GoalsMO>!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    
        
        
        // fetching goals
        let fetchRequest: NSFetchRequest<GoalsMO> = GoalsMO.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "goalName", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
            let context = appDelegate.persistentContainer.viewContext
            fetchResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
            fetchResultController.delegate = self
            
            do {
                try fetchResultController.performFetch()
                if let fetchObjects = fetchResultController.fetchedObjects {
                    goals = fetchObjects
                }
            } catch {
                
                let alertController = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                let okController = UIAlertAction(title: "OK", style: .default, handler: nil)
                alertController.addAction(okController)
                self.present(alertController, animated: true, completion: nil)
            }
        }
        
        navigationController?.navigationBar.prefersLargeTitles = true
        
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.placeholder = "Search"
        searchController.searchBar.barTintColor = .white
        searchController.searchBar.backgroundImage = UIImage()
        searchController.searchBar.tintColor = UIColor(red: 231, green: 76, blue: 60, alpha: 1)
        
        
        // update search result
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
       

    }
    
    
    func filterContent(for searchText: String){
        searchResults = goals.filter({ (goals) -> Bool in
            if let name = goals.goalName {
                let isMatch = name.localizedCaseInsensitiveContains(searchText)
                return isMatch
            }
            return false
        })
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        
        if let searchText = searchController.searchBar.text {
            filterContent(for: searchText)
            tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return goals.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "goalsList", for: indexPath) as! LifeGoalTableViewCell
        return cell
    }
    

}
