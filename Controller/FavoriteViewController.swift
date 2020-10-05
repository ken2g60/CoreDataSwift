//
//  FavoriteViewController.swift
//  LifeGoals
//
//  Created by knight on 9/28/20.
//

import UIKit
import CoreData


class FavoriteViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate {

    @IBOutlet weak var tableView: UITableView!
    var goals: [GoalsMO] = []
    
    // fetchresult
    var fetchResultController: NSFetchedResultsController<GoalsMO>!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        // remove separator
        self.tableView.separatorStyle = .none
        
        // fetched achieved goals
        let fetchRequest: NSFetchRequest<GoalsMO> = GoalsMO.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "goalAchieved", ascending: false)
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
                print(error)
            }
    
        }

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return goals.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "favoriteCell", for: indexPath) as! FavoriteTableViewCell
        
        cell.goalName.text = goals[indexPath.row].goalName
        if let goalImage = goals[indexPath.row].goalImage {
            cell.goalImage.image = UIImage(data: goalImage as Data)

        }
        
        return cell
    }
    

}
