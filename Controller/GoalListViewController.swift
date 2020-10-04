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
        
        
        tableView.dataSource = self
        tableView.delegate = self
        
        
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
        tableView.tableHeaderView = searchController.searchBar
        searchController.searchBar.placeholder = "Search Goals"
        searchController.searchBar.barTintColor = .white
        searchController.searchBar.backgroundImage = UIImage()
        
        // update search result
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        
        
 
       

    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        
        switch type {
        case .insert:
            if let newIndexPath = newIndexPath {
                tableView.insertRows(at: [newIndexPath], with: .fade)
            }
        case .delete:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        case .update:
            if let indexPath = indexPath {
                tableView.reloadRows(at: [indexPath], with: .fade)
            }
        default:
            tableView.reloadData()
        }
        
        if let fetchedObjects = controller.fetchedObjects {
            goals = fetchedObjects as! [GoalsMO]
        }
    }
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
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
        if searchController.isActive{
            return goals.count
        }else{
            return goals.count
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "goalsList", for: indexPath) as! LifeGoalTableViewCell
        
        cell.goalName.text = goals[indexPath.row].goalName
        if let goalImage = goals[indexPath.row].goalImage {
            cell.goalImage.image = UIImage(data: goalImage as Data)

        }
        cell.selectionStyle = .none
        
        return cell
    }
    
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if searchController.isActive {
            return false
        }else{
            return true
        }
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
     
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (action, sourceView, completionHandler) in
            if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
                let context = appDelegate.persistentContainer.viewContext
                let goalToDelete = self.fetchResultController.object(at: indexPath)
                
                context.delete(goalToDelete)
                appDelegate.saveContext()
            }
            completionHandler(true)
        }
        
       
        let shareAction = UIContextualAction(style: .normal, title: "Share") { (action, sourceView, completionHandler) in
            let defaultText = "Share Goal " + self.goals[indexPath.row].goalName!
            
            let activityController: UIActivityViewController
            
            if let goalImage = self.goals[indexPath.row].goalImage, let imageToShare = UIImage(data: goalImage) {
                activityController = UIActivityViewController(activityItems: [defaultText, imageToShare], applicationActivities: nil)
            } else  {
                activityController = UIActivityViewController(activityItems: [defaultText], applicationActivities: nil)
            }
            
            // For iPad
            if let popoverController = activityController.popoverPresentationController {
                if let cell = tableView.cellForRow(at: indexPath) {
                    popoverController.sourceView = cell
                    popoverController.sourceRect = cell.bounds
                }
            }
            
            self.present(activityController, animated: true, completion: nil)
            completionHandler(true)
        }
        
        deleteAction.backgroundColor = UIColor(red: 231.0/255.0, green: 76.0/255.0, blue: 60.0/255.0, alpha: 1.0)
        deleteAction.image = UIImage(systemName: "trash")

        shareAction.backgroundColor = UIColor(red: 254.0/255.0, green: 149.0/255.0, blue: 38.0/255.0, alpha: 1.0)
        shareAction.image = UIImage(systemName: "square.and.arrow.up")
        
        let swipeConfiguration = UISwipeActionsConfiguration(actions: [deleteAction, shareAction])
        
        return swipeConfiguration
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        
        let achievedAction = UIContextualAction(style: .normal, title: "Goal Achieved") { [self] (action, sourceView, completionHandler) in

            self.goals[indexPath.row].goalAchieved = self.goals[indexPath.row].goalAchieved ? false : true
            
            completionHandler(true)
        }
        achievedAction.backgroundColor = UIColor.systemGreen
        achievedAction.image = UIImage(systemName: "hand.thumbsup")
   
        let swipeConfiguretion = UISwipeActionsConfiguration(actions: [achievedAction])
        return swipeConfiguretion
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
   
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetails" {
            
        }
    }


}
