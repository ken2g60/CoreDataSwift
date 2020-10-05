//
//  GoalDetailViewController.swift
//  LifeGoals
//
//  Created by knight on 10/5/20.
//

import UIKit

class GoalDetailViewController: UIViewController {

    @IBOutlet var goalDetailimage: UIImageView!
    var goal:  GoalsMO!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.largeTitleDisplayMode = .never
        if let goalImage = goal.goalImage {
            goalDetailimage.image = UIImage(data: goalImage as Data)
        }
        
    }
    

}
