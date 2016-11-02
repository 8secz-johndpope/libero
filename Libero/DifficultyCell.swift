//
//  DifficultyCell.swift
//  Libero
//
//  Created by Daniel Moder on 11/1/16.
//  Copyright © 2016 DALI Lab. All rights reserved.
//

import UIKit

class DifficultyCell: UITableViewCell {

    
    
    @IBOutlet weak var Difficulty: UILabel!
    @IBOutlet weak var Description: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
