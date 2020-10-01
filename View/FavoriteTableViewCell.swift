//
//  FavoriteTableViewCell.swift
//  LifeGoals
//
//  Created by knight on 9/30/20.
//

import UIKit

class FavoriteTableViewCell: UITableViewCell {

    @IBOutlet weak var goalName: UILabel!
    @IBOutlet weak var goalImage: UIImageView!
    @IBOutlet weak var goalDescription: UILabel! {
        didSet {
            goalDescription.numberOfLines = 0
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
