//
//  LeaderboardCell.swift
//  Libero
//
//  Created by Daniel Moder on 10/30/16.
//  Copyright © 2016 DALI Lab. All rights reserved.
//

import UIKit

class LeaderboardCell: UITableViewCell {

    @IBOutlet weak var rank: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var score: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
