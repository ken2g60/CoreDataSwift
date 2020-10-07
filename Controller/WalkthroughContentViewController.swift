//
//  WalkthroughContentViewController.swift
//  LifeGoals
//
//  Created by knight on 10/7/20.
//

import UIKit

class WalkthroughContentViewController: UIViewController, UIPageViewControllerDelegate{

    
    @IBOutlet var headingLabel: UILabel! {
        didSet {
            headingLabel.numberOfLines = 0
        }
    }
    
    @IBOutlet var subHeadlingLabel: UILabel! {
        didSet {
            subHeadlingLabel.numberOfLines = 0
        }
    }
    @IBOutlet var contentImageView: UIImageView!
    
    var index = 0
    var heading = ""
    var subheading = ""
    var imageFile = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
    
        headingLabel.text = heading
        subHeadlingLabel.text = subheading
        contentImageView.image = UIImage(named: imageFile)

    }
    

}
