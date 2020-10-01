//
//  AboutTableViewCell.swift
//  LifeGoals
//
//  Created by knight on 9/30/20.
//

import UIKit

class AboutTableViewCell: UITableViewCell {
    
    @IBOutlet weak var aboutLifeGoalDescription: UILabel! {
        didSet {
            aboutLifeGoalDescription.numberOfLines = 0
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
